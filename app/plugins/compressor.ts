import Compressor from "compressorjs"

export default defineNuxtPlugin(async () => {
    async function compressor(file, options) {
        return new Promise((resolve, reject) => {
            options.success = (result) => resolve(result)
            options.reject = (err) => reject(err)
            new Compressor(file, options)
        })
    }

    return {
        provide: {
            compressor,
        },
    }
})
