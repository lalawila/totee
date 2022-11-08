<template>
    <!-- <el-collapse-transition> -->
    <div class="steps">
        <!-- <StepPulishContent></StepPulishContent>
        <StepPulishComment></StepPulishComment> -->
        <steps :stepStore="publishContentStore"></steps>
        <steps :stepStore="publishCommentStore"></steps>
    </div>

    <!-- </el-collapse-transition> -->

    <!-- <div v-if="statusStore.errorMsg" class="error">
        <el-alert
            :title="statusStore.errorMsg"
            type="error"
            effect="dark"
            :closable="false"
        />
    </div> -->
    <main class="main">
        <header class="header">
            <Navigator />
        </header>
        <div class="container">
            <slot />
        </div>
        <Sider class="sider" />
    </main>
    <BottomNavigator class="bottom-navigator" />
</template>
<script setup>
import { usePublishContentStore } from "@/stores/publish/content"
import { usePublishCommentStore } from "@/stores/publish/comment"

const publishContentStore = usePublishContentStore()
const publishCommentStore = usePublishCommentStore()
</script>
<style lang="stylus" scoped>
.error
    max-width 1280px
    margin 10px auto
    padding 0 10px

.steps
    position fixed
    left 0
    right 0
    bottom 0

    background-color white
    z-index 999

.main
    max-width 1280px
    padding 0 20px
    margin 0 auto

    display flex
    .header
        flex-shrink 0
    .container
        flex-grow 1
        margin 0 20px
    .sider
        flex-shrink 0
.bottom-navigator
    display none

@media only screen and (max-width 1024px)
    .main
        .sider
            display none

@media only screen and (max-width 720px)
    .steps
        top 0
        bottom auto
    .main
        width 100%
        padding 0
        .header
            display none
        .container
            margin 0
        .sider
            display none
    .bottom-navigator
        display block
</style>
