export const uploadImage = async () => {
    return new Promise((resolve) => {
        const input = document.createElement("input")
        input.type = "file"
        input.accept = "image/*"

        input.onchange = async (event) => {
            const { $ar } = useNuxtApp()
            let file = (event.target as HTMLInputElement).files[0]

            if (file) {
                const arId = await $ar.uploadFile(file)
                resolve(arId)
            }
        }

        input.click()
    })
}
