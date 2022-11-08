import { defineStore } from "pinia"

const Steps = [
    {
        title: "Signature content",
        work: async function () {
            const { $totee } = useNuxtApp()
            this.authorship = await $totee.signContent(
                JSON.stringify(this.comment)
            )
        },
    },
    {
        title: "Upload to AR",
        work: async function () {
            const { $ar } = useNuxtApp()
            this.arId = await $ar.publishContent(this.comment, this.authorship)
        },
    },
    {
        title: "Publish to smart contract",
        work: async function () {
            const { excerpt, completed } = getExcerpt(this.comment)
            const { $totee } = useNuxtApp()
            await $totee.publishComment(
                this.replyToArId,
                this.arId,
                JSON.stringify(excerpt),
                completed
            )
        },
    },
]

export const usePublishCommentStore = defineStore({
    id: "publish-comment",
    state: () => ({
        status: -1,
        opStatus: "",
        replyToArId: "",
        authorship: {},
        arId: "",
    }),
    getters: {
        isShowRun: (state) =>
            state.status < Steps.length && state.opStatus != "working",
        isShowFinish: (state) => state.status >= Steps.length,
        isShowAbor: (state) =>
            state.status != -1 && state.status < Steps.length,
        steps: (state) => {
            return Steps
        },
        comment(): Object {
            const value = window.localStorage.getItem("publish-comment")
            return JSON.parse(value)
        },
    },

    actions: {
        setComment(value: string) {
            window.localStorage.setItem(
                "publish-comment",
                JSON.stringify(value)
            )
        },
        async publishComment(replyToArId: string, comment: Object) {
            this.replyToArId = replyToArId
            this.setComment(comment)
            this.opStatus = ""
            this.status = 0
            this.run()
        },
        async run() {
            // const { $ar, $totee } = useNuxtApp()
            // const comment = this.comment
            // switch (this.status) {
            //     case 0:
            //         this.status = 0
            //         this.authorship = await $totee.signContent(
            //             JSON.stringify(comment)
            //         )
            //         this.status = 1
            //     case 1:
            //         this.arId = await $ar.publishContent(
            //             comment,
            //             this.authorship
            //         )
            //         this.status = 2
            //     case 2:
            //         const { excerpt, completed } = getExcerpt(comment)
            //         console.log(excerpt)

            //         await $totee.publishComment(
            //             this.replyToArId,
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
