<template>
    <div class="container">
        <div class="info">
            <avatar
                class="avatar"
                :src="userInfo?.avatarUrl"
                :size="64"
            ></avatar>
            <div>
                <p class="author-name">
                    {{ userInfo?.username || $t("nobody") }}
                </p>
                <NuxtLink
                    class="author-account"
                    :to="{
                        name: 'account',
                        params: {
                            account: totData?.authorship?.author || 'not',
                        },
                    }"
                    >{{
                        totData?.authorship?.author.substring(0, 6) || " "
                    }}</NuxtLink
                >
            </div>
        </div>
        <viewer
            class="content"
            v-if="totData"
            :centerImg="true"
            :content="totData?.content"
        ></viewer>
        <div class="operation">
            <span class="retot" v-if="!isAuthor" @click="retot">转发 tot</span>
        </div>
        <div class="authorship">
            <nuxt-link
                class="item"
                :to="`https://viewblock.io/arweave/tx/${route.params.arId}`"
                target="_blank"
                >ARWEAVE TX<span> {{ route.params.arId }}</span></nuxt-link
            >
            <p class="item">
                CONTENT DIGEST<span>{{ totData?.contentDigest }}</span>
            </p>
        </div>
        <CommentView :arId="route.params.arId"></CommentView>
    </div>
</template>
<script setup>
import { useAccountStore } from "@/stores/account"
const accountStore = useAccountStore()

const route = useRoute()
const { $totee } = useNuxtApp()

const isAuthor = computed(
    () =>
        totData.value?.authorship.author.toUpperCase() ==
        accountStore.account.toUpperCase()
)

const { data: totData, error } = await useLazyAsyncData(
    "totData",
    async () => {
        if (route.params.arId) {
            return await $fetch(`https://arweave.net/${route.params.arId}`)
        }
    },
    { server: false, watch: [() => route.params.arId], initialCache: false }
)

const { data: userInfo } = await useLazyAsyncData(
    "userInfo",
    async () => {
        if (totData.value?.authorship.author) {
            return await $totee.getUserPageInfo(
                totData.value?.authorship.author
            )
        }
    },
    { server: false, watch: [totData], initialCache: false }
)

async function retot() {
    await $totee.retot(route.params.arId)
}
</script>
<style lang="stylus" scoped>
.container
    padding 0 20px
    padding-top 20px
    .info
        display flex
        p
            margin 0
        .avatar
            margin-right 10px
        .author-name
            font-size 18px
            font-weight bold
            margin-bottom 10px
        .author-account
            margin 0
            font-size 12px
            color #aaa
            background-color #f1f1f1
            padding 4px 8px
            border-radius 99999px
            text-decoration none
    .content
        margin 20px 0

    .operation
        display flex
        justify-content flex-end
        .retot
            font-size 14px
            color var(--primary-color)
            cursor pointer
            font-weight bold

    .authorship
        color #aaa
        font-size 12px
        margin 20px -10px
        .item
            margin 0
            color inherit
            text-decoration none
            padding 4px 10px
            display flex
            justify-content space-between
        a.item:hover
            background-color #f9f9f9
</style>
