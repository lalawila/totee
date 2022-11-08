<template>
    <div class="container">
        <avatar
            class="right-10"
            :src="accountStore.avatarUrl"
            :size="64"
        ></avatar>
        <editor
            class="content-input"
            ref="editorEl"
            :placeholder="$t('tot-placeholder')"
        ></editor>
        <div class="buttons">
            <el-button size="large" type="primary" @click="publish" round>{{
                $t("Speak Out")
            }}</el-button>
        </div>
    </div>
</template>
<script setup>
import { useAccountStore } from "@/stores/account"
import { usePublishContentStore } from "@/stores/publish/content"

const accountStore = useAccountStore()
const publishContentStore = usePublishContentStore()

const { $totee } = useNuxtApp()
const editorEl = ref(null)

const editorVisiable = useEditorVisiable()

async function publish() {
    editorVisiable.value = false
    const content = await editorEl.value.save()
    publishContentStore.publishContent(content)
}
</script>

<style lang="stylus" scoped>
.container
    padding 20px
    .content-input
        width 100%
    .buttons
        display flex
        justify-content flex-end
</style>
