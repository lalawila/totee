import Arweave from "arweave"

import formidable from "formidable"
import fs from "fs"

const KB = 1024
const MB = KB * 1024

export default defineEventHandler(async (event) => {
    const ar = Arweave.init({
        host: "arweave.net", // Hostname or IP address for a Arweave host
        port: 443, // Port
        protocol: "https", // Network protocol http or https
        timeout: 20000, // Network request timeouts in milliseconds
        logging: false, // Enable network request logging
    })
    const form = formidable()

    const files: any = await new Promise((resolve) => {
        form.parse(event.req, (err, fields, files) => {
            resolve(files)
        })
    })

    const file = files.file[0]
    if (file.mimetype.startsWith("image")) {
        if (file.size > 512 * KB) {
            throw "图片太大"
        }
    } else if (file.mimetype.startsWith("video")) {
        if (file.size > 10 * MB) {
            throw "视频太大"
        }
    } else {
        throw "错误的类型"
    }

    const data = fs.readFileSync(file.filepath)

    let transaction = await ar.createTransaction({
        data: data,
    })

    transaction.addTag("Content-Type", file.mimetype)
    transaction.reward = String(Number(transaction.reward) * 20)

    await ar.transactions.sign(transaction, JSON.parse(process.env.AR_KEY))

    let uploader = await ar.transactions.getUploader(transaction)

    while (!uploader.isComplete) {
        await uploader.uploadChunk()
        console.log(
            `${uploader.pctComplete}% complete, ${uploader.uploadedChunks}/${uploader.totalChunks}`
        )
    }

    return { arId: transaction.id }
})
