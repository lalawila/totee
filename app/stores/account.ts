import { defineStore } from "pinia"

export const useAccountStore = defineStore({
    id: "account",
    state: () => ({
        account: "",
        _username: "",
        avatarUrl: "",
    }),
    getters: {
        username: (state) => decodeURIComponent(state._username),
    },
    actions: {
        setUsername(value: string) {
            this._username = encodeURIComponent(value)
        },
    },
    persist: true,
})
