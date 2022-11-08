<template>
    <div class="publish-content" v-if="publishContentStore.status != -1">
        <el-steps class="steps" simple>
            <el-step
                v-for="step in publishContentStore.steps"
                :title="step.title"
                :status="step.status"
            ></el-step>
        </el-steps>
        <el-button
            v-if="publishContentStore.isShowFinish"
            type="primary"
            round
            @click="publishContentStore.end"
            >完成</el-button
        >
        <el-button
            v-if="publishContentStore.isShowWork"
            type="primary"
            round
            @click="publishContentStore.work"
            >继续</el-button
        >
        <el-button
            v-if="publishContentStore.isShowAbor"
            type="danger"
            round
            @click="publishContentStore.end"
            >放弃</el-button
        >
    </div>
</template>
<script setup>
import { usePublishContentStore } from "@/stores/publish/content"

const publishContentStore = usePublishContentStore()
</script>
<style lang="stylus" scoped>
.publish-content
    max-width 1280px
    margin 10px auto
    display flex
    align-items center
    padding 0 10px
    .steps
        flex 1
        margin-right 20px
</style>
