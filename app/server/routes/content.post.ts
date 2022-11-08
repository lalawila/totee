import Arweave from "arweave"

export default defineEventHandler(async (event) => {
    const ar = Arweave.init({
        host: "arweave.net", // Hostname or IP address for a Arweave host
        port: 443, // Port
        protocol: "https", // Network protocol http or https
        timeout: 20000, // Network request timeouts in milliseconds
        logging: false, // Enable network request logging
    })
    const body = await useBody(event)

    let transaction = await ar.createTransaction({
        data: body.data,
    })

    const sourceData = JSON.parse(body.data)

    transaction.addTag("Content-Type", "application/json")
    transaction.addTag("Content-Digest", sourceData.contentDigest)
    transaction.addTag("Author", sourceData.authorship.author)
    transaction.reward = String(Number(transaction.reward) * 10)

    await ar.transactions.sign(transaction, JSON.parse(process.env.AR_KEY))

    const response = await ar.transactions.post(transaction)

    return { arId: transaction.id }
})
