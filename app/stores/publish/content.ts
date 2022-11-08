import { defineStore } from "pinia"

const Steps = [
    {
        title: "Signature content",
        work: async function () {
            const { $totee } = useNuxtApp()
            this.authorship = await $totee.signContent(
                JSON.stringify(this.content)
            )
        },
    },
    {
        title: "Upload to AR",
        work: async function () {
            const { $ar } = useNuxtApp()
            this.arId = await $ar.publishContent(this.content, this.authorship)
        },
    },
    {
        title: "Publish to smart contract",
        work: async function () {
            const { $totee } = useNuxtApp()
            const { excerpt, completed } = getExcerpt(this.content)
            console.log(excerpt)
            console.log(this.arId)
            await $totee.publishContent(
                this.arId,
                JSON.stringify(excerpt),
                completed
            )
        },
    },
]

export const usePublishContentStore = defineStore({
    id: "publish-content",
    state: () => ({
        status: -1,
        opStatus: "",
        authorship: {},
        arId: "",
    }),
    getters: {
        isShowRun: (state) =>
            state.status < Steps.length && state.opStatus != "working",
        isShowFinish: (state) => state.status >= Steps.length,
        isShowAbor: (state) =>
            state.status != -1 && state.status < Steps.length,
        steps: () => {
            return Steps
        },
        content(): Object {
            const value = window.localStorage.getItem("publish-content")
            return JSON.parse(value)
        },
    },

    actions: {
        setContent(value: string) {
            window.localStorage.setItem(
                "publish-content",
                JSON.stringify(value)
            )
        },
        async publishContent(content: Object) {
            this.setContent(content)
            this.opStatus = ""
            this.status = 0
            this.run()
        },
        async run() {
            // const content = this.content
            // switch (this.status) {
            //     case 0:
            //         this.authorship = await $totee.signContent(
            //             JSON.stringify(content)
            //         )
            //         this.status = 1
            //     case 1:
            //         this.arId = await $ar.publishContent(
            //             content,
            //             this.authorship
            //         )
            //         this.status = 2
            //     case 2:
            //         const { excerpt, completed } = getExcerpt(content)
            //         console.log(excerpt)
            //         await $totee.publishContent(
            //             this.arId,
            //             JSON.stringify(excerpt),
            //             completed
            //         )
            //         this.status = 3
            // }

            if (this.opStatus == "working") {
                return
            }
            for (let i = this.status; i < Steps.length; i++) {
                try {
                    this.opStatus = "working"
                    await Steps[i].work.call(this)
                } catch (e) {
                    this.opStatus = "error"
                    console.error(e)
                    break
                }
                this.status++
            }
        },
        async end() {
            this.status = -1
        },
    },
    persist: {
        afterRestore: ({ store }) => {
            if (store.status >= 3) {
                store.end()
            } else if (store.status != -1) {
                if (store.opStatus == "working") {
                    store.opStatus = "process"
                }
            }
        },
    },
})
