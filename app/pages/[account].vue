<template>
    <div class="container">
        <div v-if="isOwner" class="uploader" @click="uploadBanner">
            <el-image
                :src="userPageInfo?.bannerUrl || '/default/banner.png'"
                :class="banner.banner"
                fit="cover"
            />
        </div>
        <div v-else>
            <el-image
                :src="userPageInfo?.bannerUrl || '/default/banner.png'"
                :class="banner.banner"
                fit="cover"
                :preview-src-list="[
                    userPageInfo?.bannerUrl || '/default/banner.png',
                ]"
                :preview-teleported="true"
            />
        </div>
        <div :class="page.page">
            <div :class="info.info">
                <avatar
                    v-if="isOwner"
                    class="uploader"
                    :class="info.avatar"
                    :src="userPageInfo?.avatarUrl"
                    :size="128"
                    :borderSize="6"
                    @click="uploadAvatar"
                    :isPreview="false"
                ></avatar>
                <avatar
                    v-else
                    :class="info.avatar"
                    :src="userPageInfo?.avatarUrl"
                    :size="128"
                    :borderSize="6"
                    :isPreview="true"
                ></avatar>
                <div :class="info.box">
                    <p v-if="isOwner" @click="setName" :class="info.name">
                        {{ userPageInfo?.username || $t("nobody") }}
                    </p>
                    <p v-else :class="info.name">
                        {{ userPageInfo?.username || $t("nobody") }}
                    </p>
                    <nuxt-link
                        :class="info.polygon"
                        :to="`https://polygonscan.com/address/${route.params.account}`"
                        target="_blank"
                        >POLYGON ADDRESS
                        <span>{{ route.params.account }}</span></nuxt-link
                    >
                </div>
            </div>
        </div>
        <div v-for="content in contents">
            <tot
                :authorAccount="content.authorAccount"
                :avatarUrl="content.avatarUrl"
                :content="content.content"
                :completed="content.completed"
                :commentAmount="Number(content.commentAmount)"
                :retotAmount="Number(content.retotAmount)"
                :arId="content.arId"
                :authorName="content.authorName"
                :publishTime="Number(content.publishTime)"
                :isUserPage="true"
            ></tot>
        </div>
        <p class="nomore" v-if="finished">{{ $t("no more") }}</p>
    </div>
</template>
<script setup>
import { useAccountStore } from "@/stores/account"
const accountStore = useAccountStore()

const route = useRoute()
const { $totee } = useNuxtApp()

const isOwner = computed(
    () =>
        route.params.account?.toUpperCase() ==
        accountStore.account.toUpperCase()
)

const { data: userPageInfo, error } = await useLazyAsyncData(
    "userinfo",
    () => {
        return $totee.getUserPageInfo(route.params.account)
    },
    { server: false, initialCache: false }
)

let startArId = ""
const amount = 8

const finished = await useState("finished", (_) => false)

const {
    pending,
    refresh,
    data: contents,
    error: contentsError,
} = await useLazyAsyncData(
    "contents",
    async () => {
        const result = await $totee.getUserContents(route.params.account, {
            startArId,
            amount,
        })

        if (result.length < amount) {
            finished.value = true
        }
        if (startArId == "") {
            return result
        }
        return contents.value.concat(result)
    },
    { server: false, initialCache: false }
)

onBottom(async () => {
    if (pending.value || finished.value) return
    startArId = contents.value[contents.value.length - 1].arId
    refresh()
})

async function uploadBanner() {
    const arId = await uploadImage()
    $totee.setBannerUrl(`https://arweave.net/${arId}`)
}

async function uploadAvatar() {
    const { $totee } = useNuxtApp()
    const arId = await uploadImage()
    $totee.setAvatarUrl(`https://arweave.net/${arId}`)
}

async function setName() {
    const username = prompt("请输入用户名")
    if (username) {
        $totee.setUsername(username)
    }
}
</script>
<style lang="stylus" scoped>
.nomore
    text-align center
    color var(--minor-color)
    margin 80px 0

.uploader
    position relative

.uploader:hover::before
    cursor pointer
    content "upload"
    z-index 999
    font-size 32px
    color white
    font-weight bold
    position absolute
    filter brightness(100%)

    // 水平上下居中
    display block
    left 0
    right 0
    top 0
    bottom 0
    margin auto

    width max-content
    height max-content
</style>
<style module="banner" lang="stylus" scoped>
.banner
    display block
    width 100%
    height 300px
    margin-bottom -60px
    cursor pointer
.banner:hover
    filter brightness(80%)
</style>
<style module="page" lang="stylus" scoped>
.page
    border-radius 20px 20px 0 0
    background-color #fefefe
    padding  0 20px

    position relative
    z-index 10
</style>
<style module="info" lang="stylus" scoped>
.info
    display flex
    .avatar
        margin-top -64px
    .box
        margin-left 10px
        .name
            font-size 20px
            margin 0
            margin-top 10px
        .polygon
            font-size 14px
            color var(--minor-color)
            text-decoration none
</style>
