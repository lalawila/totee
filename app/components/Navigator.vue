<template>
    <aside class="navigator">
        <div class="menu">
            <!-- <div class="brand">Totee</div> -->
            <img class="logo" src="/logo.png" />
            <div class="links">
                <NavigatorLink
                    :icon="HashIcon"
                    :label="$t('Explore')"
                    :to="{ name: 'index' }"
                ></NavigatorLink>
                <NavigatorLink
                    v-if="accountStore.account"
                    :icon="UserIcon"
                    :label="$t('Profile')"
                    :to="{
                        name: 'account',
                        params: { account: accountStore.account },
                    }"
                ></NavigatorLink>
                <NavigatorLink
                    class="middle-display"
                    :label="$t('About')"
                    :icon="QuestionIcon"
                    :to="{
                        name: 'about',
                    }"
                ></NavigatorLink>
            </div>
            <button class="button round" @click="show">
                {{ $t("Speak Out") }}
            </button>

            <button
                v-if="!toteeStore.isConnected"
                @click="$totee.connect"
                class="button round"
            >
                {{ $t("Connect Wallet") }}
            </button>
        </div>
        <!-- <div class="info"></div> -->
    </aside>
    <client-only>
        <el-dialog
            custom-class="publish-dialog"
            v-model="editorVisiable"
            width="680px"
            draggable
        >
            <div class="publish-box">
                <avatar
                    class="right-10"
                    :src="accountStore.avatarUrl"
                    :size="64"
                ></avatar>
                <editor
                    class="content-input"
                    ref="editorEl"
                    :maxHeight="maxHeight"
                    :placeholder="$t('tot-placeholder')"
                ></editor>
            </div>
            <template #footer>
                <span class="dialog-footer">
                    <el-button
                        size="large"
                        type="primary"
                        @click="publish"
                        round
                        >{{ $t("Speak Out") }}</el-button
                    >
                </span>
            </template>
        </el-dialog>
    </client-only>
</template>
<script setup>
import HashIcon from "@/assets/svg/hash.svg?component"
import UserIcon from "@/assets/svg/user.svg?component"
import QuestionIcon from "@/assets/svg/question.svg?component"

import { useToteeStore } from "@/stores/totee"
import { useAccountStore } from "@/stores/account"
import { usePublishContentStore } from "@/stores/publish/content"

const toteeStore = useToteeStore()
const accountStore = useAccountStore()
const publishContentStore = usePublishContentStore()

const ee = useToteeStore()

const { $totee } = useNuxtApp()
const editorEl = ref(null)

const editorVisiable = useEditorVisiable()

const show = useAuth(() => {
    editorVisiable.value = true
})

const maxHeight = computed(() => window.innerHeight - 400)

async function publish() {
    editorVisiable.value = false
    const content = await editorEl.value.save()
    publishContentStore.publishContent(content)
}
</script>

<style lang="stylus" scoped>
.navigator
    width 260px
    display flex
    flex-direction column
    justify-content space-between
    position sticky
    top 0
    .brand
        font-size 36px
        font-weight bold
        padding 12px
    .logo
        height 40px
        margin 12px
    .links
        margin-bottom 20px

    .button
        cursor pointer
        background-color var(--primary-color)
        color white

        font-size 18px

        font-weight bold
        text-align center
        line-height 52px
        height 52px
        border-radius 999px

        border none
        outline none
        margin-bottom 20px
        width 100%
    .button:hover
        background-color var(--second-color)
    .info
        text-align center
        margin-bottom 20px

    .middle-display
        display none
    @media only screen and (max-width 1024px)
        .middle-display
            display block
</style>
<style lang="stylus">
.publish-dialog
    border-radius 30px
    .publish-box
        display flex
        .content-input
            flex 1
            min-width 0
    .el-dialog__headerbtn
        left 14px
        top  14px
        font-size 24px
        width max-content
        height auto
        .el-dialog__close
            border-radius 50%
            padding 6px
            width auto
            height auto
        .el-dialog__close:hover
            background-color #eee
</style>
