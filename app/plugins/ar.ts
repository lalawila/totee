import { ElMessage } from "element-plus"
import Arweave from "arweave"

const KB = 1024
const MB = KB * 1024

class AR {
    arweave: any
    constructor() {
        this.arweave = Arweave.init({
            host: "arweave.net", // Hostname or IP address for a Arweave host
            port: 443, // Port
            protocol: "https", // Network protocol http or https
            timeout: 20000, // Network request timeouts in milliseconds
            logging: false, // Enable network request logging
        })
    }

    public async uploadFile(file, contentType = null, useServerAr = true) {
        const { $t } = useNuxtApp()
        if (useServerAr) {
            console.log(file)
            if (file.type.startsWith("image")) {
                if (file.size > 512 * KB) {
                    ElMessage.error($t("The image is too big."))
                    return null
                }
            } else if (file.type.startsWith("video")) {
                if (file.size > 10 * MB) {
                    ElMessage.error($t("The video is too big."))
                    return null
                }
            } else {
                throw "错误的类型"
            }

            var formData = new FormData()
            formData.append("file", file)
            const { arId } = await $fetch("/file", {
                method: "POST",
                body: formData,
            })
            console.log(arId)
            return arId
        }

        return new Promise((resolve) => {
            const reader = new FileReader()
            reader.onload = async (ev) => {
                let data = ev.target.result

                let transaction = await this.arweave.createTransaction({
                    data,
                })
                transaction.addTag("Content-Type", contentType || file.type)

                transaction.reward = String(Number(transaction.reward) * 10)
                console.log(transaction.reward)

                await this.arweave.transactions.sign(transaction)

                console.log(transaction)

                if (
                    parseInt(transaction.data_size) < 120_000 &&
                    window.arweaveWallet?.dispatch
                ) {
                    await window.arweaveWallet.connect(["DISPATCH"])
                    const response = await window.arweaveWallet.dispatch(
                        transaction
                    )
                } else {
                    let uploader = await this.arweave.transactions.getUploader(
                        transaction
                    )

                    while (!uploader.isComplete) {
                        await uploader.uploadChunk()
                        console.log(
                            `${uploader.pctComplete}% complete, ${uploader.uploadedChunks}/${uploader.totalChunks}`
                        )
                    }
                }

                resolve(transaction.id)
            }
            reader.readAsArrayBuffer(file)
        })
    }

    public async publishContent(
        content: object,
        { signature, contentDigest, publicKey, address },
        useServerAr = true
    ) {
        // arweave.wallets.jwkToAddress(config.PRIVATE_KEY).then((address) => {
        //     console.log(address)
        //     //1seRanklLU_1VTGkEk7P0xAwMJfA7owA1JHW5KyZKlY
        // })

        const data = JSON.stringify({
            content,
            contentDigest,
            authorship: {
                author: address,
                publicKey,
                message: contentDigest,
                signature,
            },
            version: "20220402",
        })

        if (useServerAr) {
            const { arId } = await $fetch("/content", {
                method: "POST",
                body: { data },
            })
            console.log(arId)
            return arId
        }

        let transaction = await this.arweave.createTransaction({
            data,
        })

        transaction.addTag("Content-Type", "application/json")
        transaction.addTag("Content-Digest", contentDigest)
        transaction.addTag("Author", address)
        transaction.reward = String(Number(transaction.reward) * 10)
        console.log(transaction.reward)

        await this.arweave.transactions.sign(transaction)
        console.log(transaction)

        let response
        if (window.arweaveWallet?.dispatch) {
            await window.arweaveWallet.connect(["DISPATCH"])
            response = await window.arweaveWallet.dispatch(transaction)
        } else {
            response = await this.arweave.transactions.post(transaction)
        }
        console.log(response)

        return transaction.id
    }

    public async getData(id: string) {
        const data = await this.arweave.transactions.getData(id, {
            decode: true,
            string: true,
        })
        return JSON.parse(data)
    }
}

export { AR }

export default defineNuxtPlugin(() => {
    const ar = new AR()
    return {
        provide: {
            ar,
        },
    }
})
