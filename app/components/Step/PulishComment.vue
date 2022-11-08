<template>
    <div class="publish-comment" v-if="publishCommentStore.status != -1">
        <el-steps class="steps" simple>
            <el-step
                v-for="step in publishCommentStore.steps"
                :title="$t(step.title)"
                :status="step.status"
            ></el-step>
        </el-steps>
        <el-button
            v-if="publishCommentStore.isShowFinish"
            type="primary"
            round
            @click="publishCommentStore.end"
            >{{ $t("complete") }}</el-button
        >
        <el-button
            v-if="publishCommentStore.isShowWork"
            type="primary"
            round
            @click="publishCommentStore.work"
            >{{ $t("continue") }}</el-button
        >
        <el-button
            v-if="publishCommentStore.isShowAbor"
            type="danger"
            round
            @click="publishCommentStore.end"
            >{{ $t("abort") }}</el-button
        >
    </div>
</template>
<script setup>
import { usePublishCommentStore } from "@/stores/publish/comment"

const publishCommentStore = usePublishCommentStore()
</script>
<style lang="stylus" scoped>
.publish-comment
    max-width 1280px
    margin 10px auto
    display flex
    align-items center
    padding 0 10px
    background-color white
    .steps
        flex 1
        margin-right 20px
</style>
