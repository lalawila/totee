// Pull in the shims (BEFORE importing ethers)
// import "@ethersproject/shims"
// import { ethers } from "ethers"
import { ElMessage } from "element-plus"

import detectEthereumProvider from "@metamask/detect-provider"

import { useToteeStore } from "@/stores/totee"
import { useAccountStore } from "@/stores/account"

class Totee {
    private provider: any
    private contract: any
    private toteeStore: any
    private accountStore: any
    private abi: any
    private signer: any

    constructor() {
        const config = useRuntimeConfig()
        this.abi = config.toteeAbi
        this.toteeStore = useToteeStore()
        this.accountStore = useAccountStore()
    }

    public async setUsername(username: string) {
        await this.contract.setUsername(username)
    }

    public async setAvatarUrl(url: string) {
        await this.contract.setAvatarUrl(url)
    }

    public async setBannerUrl(url: string) {
        await this.contract.setBannerUrl(url)
    }

    public async getUsername(account: string) {
        const username = await this.contract.getUsername(account)
        if (!username) {
            alert("请注册")
        } else {
            return username
        }
    }

    public async getUserPageInfo(account: string) {
        return await this.contract.getUserPageInfo(account)
    }

    public async getUserContents(
        account: string,
        { startArId = "", amount = 5 } = {}
    ) {
        const contents = await this.contract.getUserContents(
            account,
            startArId,
            amount,
            true
        )
        return contents
    }

    public async getCommentsByArId(
        arId: string,
        { startCommentId = "", amount = 5 } = {}
    ) {
        const comments = await this.contract.getCommentsByArId(
            arId,
            startCommentId,
            amount,
            true
        )
        return comments
    }

    public async getExploreContents({ startArId = "", amount = 5 } = {}) {
        const contents = await this.contract.getExploreContents(
            startArId,
            amount,
            true
        )
        return contents
    }

    public async signContent(content: string) {
        const contentDigest = ethers.utils.base58.encode(
            ethers.utils.id(content)
        )

        const signature = await this.signer.signMessage(contentDigest)

        const msgHash = ethers.utils.hashMessage(contentDigest)
        const msgHashBytes = ethers.utils.arrayify(msgHash)
        const recoveredPubKey = ethers.utils.recoverPublicKey(
            msgHashBytes,
            signature
        )
        const recoveredAddress = ethers.utils.recoverAddress(
            msgHashBytes,
            signature
        )

        return {
            contentDigest,
            signature: ethers.utils.base58.encode(signature),
            publicKey: recoveredPubKey,
            address: recoveredAddress,
        }
    }

    public async checkInit() {
        let pageinfo = await this.getUserPageInfo(this.accountStore.account)
        this.accountStore.setUsername(pageinfo.username)
        this.accountStore.avatarUrl = pageinfo.avatarUrl
    }

    public async publishContent(
        arId: string,
        content: string,
        completed: boolean
    ) {
        // const data: any = await $fetch(
        //     "https://gasstation-mainnet.matic.network/v2"
        // )
        // const maxFeePerGas = ethers.utils.parseUnits(
        //     Math.ceil(data.fast.maxFee) + "",
        //     "gwei"
        // )
        // const maxPriorityFeePerGas = ethers.utils.parseUnits(
        //     Math.ceil(data.fast.maxPriorityFee) + "",
        //     "gwei"
        // )
        // await this.contract.publishContent(arId, content, completed, {
        //     maxFeePerGas,
        //     maxPriorityFeePerGas,
        // })
        console.log(await this.provider.getGasPrice())
        await this.contract.publishContent(arId, content, completed, {
            gasPrice: await this.provider.getGasPrice(),
        })
    }

    public async publishComment(
        replyToArId: string,
        commentArId: string,
        content: string,
        completed: boolean
    ) {
        await this.contract.publishComment(
            replyToArId,
            commentArId,
            content,
            completed
        )
    }

    public async retot(arId: string) {
        await this.contract.retot(arId)
    }

    public async init() {
        console.log("init")

        const metaProvider: any = await detectEthereumProvider()

        if (!metaProvider) {
            this.toteeStore.setIsMetaMask(false)

            this.useCustomNetwork()
            return
        }

        this.toteeStore.setIsMetaMask(metaProvider.isMetaMask)

        if (!this.toteeStore.isMetaMask) {
            this.useCustomNetwork()
            return
        }

        metaProvider.on("chainChanged", (_) => this.autoConnect())
        metaProvider.on("accountsChanged", (_) => this.autoConnect())
        metaProvider.on("disconnect", (_) => this.autoConnect())
        metaProvider.on("connect", (_) => this.autoConnect())

        await this.autoConnect()
    }

    public async autoConnect() {
        const metaProvider: any = await detectEthereumProvider()

        this.provider = new ethers.providers.Web3Provider(metaProvider)

        this.toteeStore.setIsNetworkRight(await this.checkNetwork())

        console.log(this.toteeStore.isNetworkRight)
        if (!this.toteeStore.isNetworkRight) {
            this.useCustomNetwork()
            return
        }

        this.toteeStore.isConnected = await this.checkConnected()

        if (this.toteeStore.isConnected) {
            await this.connect()
        } else {
            this.contract = new ethers.Contract(
                useRuntimeConfig().contractAddr,
                this.abi,
                this.provider
            )
        }
    }

    public async checkNetwork() {
        // const chainId = await window.ethereum.request({ method: "eth_chainId" })
        const chainId = await this.provider.send("eth_chainId")
        console.log(chainId)
        if (process.env.NODE_ENV === "production") {
            if (chainId == 137) {
                return true
            }
        } else if (chainId == 1337) {
            return true
        }

        return false
    }

    public async switchPolygon() {
        await this.provider.send("wallet_addEthereumChain", [
            {
                chainId: "0x89",
                chainName: "Polygon Mainnet",
                rpcUrls: ["https://polygon-rpc.com/"],
                blockExplorerUrls: ["https://polygonscan.com/"],
                nativeCurrency: {
                    name: "MATIC",
                    symbol: "MATIC",
                    decimals: 18,
                },
            },
        ])

        // try {
        //     await this.provider.send("wallet_switchEthereumChain", [
        //         { chainId: "0x89" },
        //     ])
        // } catch (switchError) {
        //     // This error code indicates that the chain has not been added to MetaMask.
        //     // console.log(switchError)
        //     // if (switchError.code === 4902) {
        //     //     await this.provider.send("wallet_addEthereumChain", [
        //     //         {
        //     //             chainId: "0x89",
        //     //             chainName: "Polygon Mainnet",
        //     //             rpcUrls: ["https://polygon-rpc.com/"],
        //     //             blockExplorerUrls: ["https://polygonscan.com/"],
        //     //         },
        //     //     ])
        //     // }
        // }
    }

    public async useCustomNetwork() {
        let network
        if (process.env.NODE_ENV === "production") {
            network = {
                name: "matic",
                chainId: 137,
                _defaultProvider: (providers) =>
                    new providers.JsonRpcProvider("https://polygon-rpc.com/"),
            }
        } else {
            network = {
                name: "Ganache 测试",
                chainId: 1337,
                _defaultProvider: (providers) =>
                    new providers.JsonRpcProvider("http://127.0.0.1:7545"),
            }
        }

        const provider = ethers.getDefaultProvider(network)
        this.contract = new ethers.Contract(
            useRuntimeConfig().contractAddr,
            this.abi,
            provider
        )
    }

    public async checkConnected() {
        return (await this.provider.listAccounts()).length > 0
    }

    public async connect() {
        // 1. 先检查 metamask 有没有安装
        // 2. 再检查有没有切换至 polygon 网络

        console.log("connect")

        const { $t } = useNuxtApp()

        if (!this.toteeStore.isMetaMask) {
            ElMessage.warning($t("Install MetaMask first."))
            return
        }

        if (!this.toteeStore.isNetworkRight) {
            await this.switchPolygon()
        }

        if (!(await this.checkNetwork())) {
            ElMessage.warning($t("Switch to polygon network."))
            return
        }

        const accounts = await this.provider.send("eth_requestAccounts", [])

        if (accounts.length > 0) {
            this.toteeStore.isConnected = true
            this.accountStore.account = accounts[0]
            this.signer = this.provider.getSigner()
            this.contract = new ethers.Contract(
                useRuntimeConfig().contractAddr,
                this.abi,
                this.signer
            )
            await this.checkInit()
        }
    }
}

export default defineNuxtPlugin(async () => {
    const totee = new Totee()
    if (process.client) {
        await totee.init()
    }
    return {
        provide: {
            totee,
        },
    }
})
