<template>
    <comment-input :arId="props.arId"></comment-input>
    <div id="comments" class="comments">
        <div v-for="comment in comments">
            <tot
                :authorAccount="comment.authorAccount"
                :avatarUrl="comment.avatarUrl"
                :content="comment.content"
                :completed="comment.completed"
                :commentAmount="Number(comment.commentAmount)"
                :retotAmount="Number(comment.retotAmount)"
                :arId="comment.arId"
                :authorName="comment.authorName"
                :publishTime="Number(comment.publishTime)"
            ></tot>
        </div>
    </div>
    <p class="nomore" v-if="comments?.length != 0 && finished">
        {{ $t("no more") }}
    </p>
</template>
<script setup>
let startCommentId = ""
const amount = 5
const props = defineProps({
    arId: String,
})
const { $totee } = useNuxtApp()

const finished = ref(false)

watch(
    () => props.arId,
    async () => {
        startCommentId = ""
        refresh()
    }
)

const {
    pending,
    refresh,
    data: comments,
    error,
} = await useLazyAsyncData(
    "comments",
    async () => {
        const result = await $totee.getCommentsByArId(props.arId, {
            startCommentId,
            amount,
        })
        if (result.length < amount) {
            finished.value = true
        }
        if (startCommentId == "") {
            return result
        }
        return comments.value.concat(result)
    },
    { server: false, initialCache: false }
)

onBottom(() => {
    if (pending.value || finished.value) return
    startCommentId = comments.value[comments.value.length - 1].arId
    refresh()
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
.nomore
    text-align center
    color var(--minor-color)
    margin 80px 0
.comments
    margin 0 -10px
</style>
