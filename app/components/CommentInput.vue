<template>
    <div class="input-box">
        <avatar
            class="right-10"
            :src="accountStore.avatarUrl"
            :size="64"
        ></avatar>
        <div class="right">
            <editor
                class="comment-input"
                ref="commentInput"
                :placeholder="$t('reply-placeholder')"
            ></editor>
            <div class="button-list">
                <el-button
                    size="large"
                    class="publish-button"
                    type="primary"
                    round
                    @click="publish()"
                    >{{ $t("Reply") }}</el-button
                >
            </div>
        </div>
    </div>
</template>
<script setup>
import { useAccountStore } from "@/stores/account"
import { usePublishCommentStore } from "@/stores/publish/comment"

const publishCommentStore = usePublishCommentStore()
const accountStore = useAccountStore()

const props = defineProps({
    arId: String,
})

const commentInput = ref(null)
const publish = useAuth(async () => {
    const comment = await commentInput.value.save()

    publishCommentStore.publishComment(props.arId, comment)
})
</script>
<style lang="stylus">
.input-box
    display flex
    .right
        flex 1
        min-width 0
        .comment-input
            margin-bottom 10px
        .button-list
            display flex
            justify-content flex-end
            margin-bottom 10px
</style>
<style module="item" lang="stylus">
.item
    display flex
    p
        margin 0
    .left
        margin-right 10px
</style>
