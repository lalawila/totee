import { defineStore } from "pinia"

export const useToteeStore = defineStore("totee", {
    state: () => ({
        isConnected: false,
        isNetworkRight: false,
        isMetaMask: false,
    }),
    actions: {
        setIsMetaMask(value: boolean) {
            this.isMetaMask = value
            if (!value) {
                this.isNetworkRight = false
                this.isConnected = false
            }
        },
        setIsNetworkRight(value: boolean) {
            this.isNetworkRight = value
            if (!value) {
                this.isConnected = false
            }
        },
        setIsConnected(value: boolean) {
            this.isConnected = value
        },
    },
    persist: true,
})
