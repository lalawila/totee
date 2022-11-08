import { defineNuxtConfig } from "nuxt"
import svgLoader from "vite-svg-loader"

const fs = require("fs")
let toteeAbi = fs.readFileSync("../build/contracts/ToteeV2Retot.json", "utf8")
toteeAbi = JSON.parse(toteeAbi).abi

const lifecycle = process.env.npm_lifecycle_event

const ProContractAddr = "0x3138768344659d26403170001360F67049F4Aa3e"
const DevContractAddr = "0xdb8574C5058b40c8A24c1de8690fF553209F9B65"

// https://v3.nuxtjs.org/docs/directory-structure/nuxt.config
export default defineNuxtConfig({
    app: {
        head: {
            script: [
                { src: "https://cdn.ethers.io/lib/ethers-5.2.umd.min.js" },
            ],
            meta: [
                {
                    name: "viewport",
                    content:
                        "width=device-width, height=device-height, user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0",
                },
            ],
            link: [
                {
                    rel: "shortcut icon",
                    type: "image/x-icon",
                    href: "/favicon..png",
                },
            ],
        },
    },
    css: [
        "@/assets/css/main.styl",
        "@/assets/css/element-ui-theme.styl",
        "@/assets/css/variables.styl",
    ],
    vite: {
        plugins: [svgLoader()],
        // optimizeDeps: {
        //     include: [
        //         // "mlly.js",
        //         // "bn.js",
        //         // "js-sha3",
        //         // "hash.js",
        //         // "eth-rpc-errors",
        //         // "web3-eth-contract",
        //         // "aes-js",
        //     ],
        // },
    },
    publicRuntimeConfig: {
        // PRIVATE_KEY: JSON.parse(process.env.PRIVATE_KEY),
        toteeAbi,
        contractAddr:
            process.env.NODE_ENV === "production"
                ? ProContractAddr
                : DevContractAddr,
    },
    build: {
        transpile: [
            process.env.NODE_ENV === "production" ? "element-plus" : "",
        ],
        // transpile: [
        //     "ethers",
        //     "@ethersproject",
        //     "@toruslabs/*",
        //     "@walletconnect/*",
        //     "@snapshot-labs/lock",
        // ],
    },
    // modules: ["@intlify/nuxt3"],
    buildModules: ["@pinia/nuxt"],
    // config for `@intlify/nuxt3`
})
