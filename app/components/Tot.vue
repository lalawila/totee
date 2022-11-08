<template>
    <NuxtLink
        class="tot"
        :to="{
            name: 'tot-arId',
            params: { arId: arId },
        }"
    >
        <div class="section">
            <div class="left">
                <nuxt-link
                    :to="{
                        name: 'account',
                        params: { account: props.authorAccount },
                    }"
                >
                    <avatar
                        :src="props.avatarUrl || '/default/avatar.jpg'"
                        :size="64"
                    ></avatar>
                    <!-- <el-avatar class="avatar">user</el-avatar> -->
                </nuxt-link>
            </div>
            <div :class="box.box">
                <div :class="box.info">
                    <span :class="box['author-name']">
                        {{ props.authorName || $t("nobody") }}
                    </span>
                    <span :class="box.time">{{
                        $beautifulTime(props.publishTime)
                    }}</span>
                </div>
                <NuxtLink
                    :to="{
                        name: 'account',
                        params: { account: props.authorAccount },
                    }"
                    :class="box['author-account']"
                    >{{ props.authorAccount.substring(0, 6) }}</NuxtLink
                >

                <viewer
                    :class="box.content"
                    v-if="totData && showMoreVisiable"
                    :content="totData.content"
                ></viewer>
                <div :class="box.content" v-else>
                    <viewer
                        v-if="props.completed"
                        :maxHeightImg="400"
                        :content="JSON.parse(props.content)"
                    ></viewer>
                    <template v-else>
                        <template v-if="excerpt">
                            <p>
                                {{
                                    excerpt.excerpt +
                                    (excerpt.ellipsis ? "......" : "")
                                }}
                            </p>

                            <div v-if="excerpt.video" @click="prevent">
                                <video
                                    ref="videoEl"
                                    class="video-js vjs-big-play-centered vjs-16-9"
                                    :class="box.video"
                                    v-if="excerpt.video"
                                    controls
                                >
                                    <source
                                        :src="excerpt.video"
                                        type="video/mp4"
                                    />
                                </video>
                            </div>
                            <el-image
                                :class="box.thumbnail"
                                v-if="excerpt.thumbnail"
                                @click="prevent"
                                fit="contain"
                                :src="excerpt.thumbnail"
                                :preview-src-list="[excerpt.thumbnail]"
                                :preview-teleported="true"
                            ></el-image>
                        </template>
                        <p v-else :class="box.content">
                            {{ props.content + "......" }}
                        </p>
                    </template>
                </div>
                <div class="clear-a" :class="bottom.bottom">
                    <div v-if="isUserPage && !isOwner" :class="bottom.retot">
                        转发的 tot
                    </div>
                    <div @click="retot" :class="bottom['inner-box']">
                        <div
                            :title="$t('Retot')"
                            :class="bottom['icon-container']"
                        >
                            <RetotIcon :class="bottom.icon"></RetotIcon>
                        </div>
                        <div v-if="props.retotAmount" :class="bottom.amount">
                            {{ props.retotAmount }}
                        </div>
                    </div>
                    <div @click="reply($event)" :class="bottom['inner-box']">
                        <div
                            :title="$t('Reply')"
                            :class="bottom['icon-container']"
                        >
                            <Close v-if="replyVisiable" :class="bottom.icon" />
                            <ReplyIcon v-else :class="bottom.icon"></ReplyIcon>
                        </div>
                        <div v-if="props.commentAmount" :class="bottom.amount">
                            {{ props.commentAmount }}
                        </div>
                    </div>
                    <div @click="showSign($event)" :class="bottom['inner-box']">
                        <div
                            :title="$t('Show Sign')"
                            :class="bottom['icon-container']"
                        >
                            <Close v-if="signVisiable" :class="bottom.icon" />
                            <SignIcon v-else :class="bottom.icon"></SignIcon>
                        </div>
                    </div>
                    <div
                        v-if="!completed"
                        :class="bottom['show-more']"
                        @click="showMore($event)"
                    >
                        {{
                            showMoreVisiable ? $t("Hide More") : $t("View More")
                        }}
                    </div>
                </div>
            </div>
        </div>
    </NuxtLink>
    <div v-if="signVisiable || replyVisiable" :class="another.another">
        <div v-if="signVisiable" :class="another.authorship">
            <nuxt-link
                :class="another.item"
                :to="`https://viewblock.io/arweave/tx/${props.arId}`"
                target="_blank"
                >ARWEAVE TX<span> {{ props.arId }}</span></nuxt-link
            >
            <p :class="another.item">
                CONTENT DIGEST<span>{{ totData?.contentDigest }}</span>
            </p>
        </div>
        <comment-input
            :class="another['comment-input']"
            v-if="replyVisiable"
            :arId="props.arId"
        ></comment-input>
    </div>
</template>
<script setup>
import { Close } from "@element-plus/icons-vue"

import RetotIcon from "@/assets/svg/retot.svg?component"
import SignIcon from "@/assets/svg/sign.svg?component"
import ReplyIcon from "@/assets/svg/reply.svg?component"

import videojs from "video.js/core.js"
import "video.js/dist/video-js.min.css"

const videoEl = ref(null)
const props = defineProps({
    arId: String,
    authorName: String,
    authorAccount: String,
    avatarUrl: String,
    content: String,
    completed: Boolean,
    commentAmount: Number,
    retotAmount: Number,
    publishTime: Number,
    isUserPage: {
        type: Boolean,
        default: false,
    },
})

const retotAmount = ref(props.retotAmount)
const replyVisiable = ref(false)
const signVisiable = ref(false)
const showMoreVisiable = ref(false)

let totData = ref(null)
const getTotData = (target) => {
    return async function (...args) {
        event.preventDefault()
        if (!totData.value) {
            totData.value = await $fetch(`https://arweave.net/${props.arId}`)
        }

        return target.call(this, ...args)
    }
}

const isOwner = computed(
    () =>
        props.authorAccount.toUpperCase() ==
        useRoute().params.account?.toUpperCase()
)

const excerpt = computed(() => tryParseJSONObject(props.content))

function tryParseJSONObject(str) {
    try {
        let o = JSON.parse(str)
        if (o && typeof o === "object") {
            return o
        }
    } catch (e) {}
    return false
}

const retot = useAuth(async (event) => {
    event.preventDefault()
    const { $totee } = useNuxtApp()
    await $totee.retot(props.arId)
    retotAmount.value += 1
})

const reply = getTotData(() => {
    replyVisiable.value = !replyVisiable.value
})

const showSign = getTotData(() => {
    signVisiable.value = !signVisiable.value
})

const showMore = getTotData(() => {
    showMoreVisiable.value = !showMoreVisiable.value
})

function prevent(event) {
    event.preventDefault()
}

onMounted(async () => {
    if (videoEl.value) {
        videojs(videoEl.value)
    }
})
</script>

<style lang="stylus" scoped>
.tot
    display block
    width 100%
    color inherit
    text-decoration none
    .section
        padding 20px
        display flex
        .left
            flex 0 0 50px
            margin-right 10px
.tot:hover
    background-color #f7f7f7
    cursor pointer
</style>
<style module="box" lang="stylus" scoped>
.box
    flex 1 1
    min-width 0
    .time
        font-size 14px
        color var(--minor-color)
    .info
        display flex
        justify-content space-between
    .author-name
        font-weight bold
        font-size 18px
        margin 0
        margin-bottom 10px
    .author-account
        margin 0
        font-size 12px
        color #aaa
        background-color #f1f1f1
        padding 4px 8px
        border-radius 99999px
        text-decoration none
    .author-account:hover
        color var(--primary-color)

    .content
        margin 20px 0

    .thumbnail
        display block
        width fit-content
        margin 20px 0
    .thumbnail :deep(img)
        border-radius 18px
        max-height 400px
        max-width 100%
        width auto
        height auto
    .video
        border-radius 18px
        margin 20px 0
        width 100%
        max-height 300px
</style>
<style module="bottom" lang="stylus" scoped>
.bottom
    font-size 14px
    display flex
    justify-content space-between
    align-items center
    .retot
        font-weight bold
        color var(--primary-color)
    .inner-box
        display inline-flex
        align-items center
        .amount
            margin-left 10px
        .icon-container
            padding 8px
            border-radius 50%
            .icon
                display block
                height 20px
    .inner-box:hover
        color var(--primary-color)
        .icon-container
            background-color var(--second-color)
    a.show-more
        margin-left 40px
    .show-more:hover
        color var(--primary-color)
</style>
<style module="another" lang="stylus" scoped>
.another
    .comment-input
        margin 20px
    .authorship
        color #aaa
        font-size 12px
        margin 20px
        .item
            margin 0
            color inherit
            text-decoration none
            padding 4px 20px
            display flex
            justify-content space-between
            margin 0 -20px
        a.item:hover
            background-color #f9f9f9
</style>
