import ElementPlus from "element-plus/dist/index.full.js"
import "element-plus/dist/index.css"

export default defineNuxtPlugin((nuxtApp) => {
    nuxtApp.vueApp.use(ElementPlus)
})
