<template>
    <div class="container" v-if="stepStore.status != -1">
        <el-steps
            class="steps"
            :active="stepStore.status"
            finish-status="success"
            simple
        >
            <template v-for="(step, index) in stepStore.steps">
                <template v-if="index == stepStore.status">
                    <el-step
                        v-if="stepStore.opStatus == 'working'"
                        class="custom"
                        status="process"
                        :title="$t(step.title)"
                    >
                        <template #icon>
                            <el-icon :size="24" class="is-loading"
                                ><Loading
                            /></el-icon>
                        </template>
                    </el-step>
                    <el-step
                        v-else
                        :status="stepStore.opStatus"
                        :title="$t(step.title)"
                    >
                    </el-step>
                </template>
                <el-step v-else :title="$t(step.title)"></el-step>
            </template>
        </el-steps>
        <el-button
            v-if="stepStore.isShowRun"
            type="primary"
            round
            @click="stepStore.run()"
            >{{ $t("continue") }}</el-button
        >
        <el-button
            v-if="stepStore.isShowFinish"
            type="primary"
            round
            @click="stepStore.end()"
            >{{ $t("complete") }}</el-button
        >

        <el-button
            v-if="stepStore.isShowAbor"
            type="danger"
            round
            @click="stepStore.end()"
            >{{ $t("abort") }}</el-button
        >
    </div>
</template>
<script setup>
import { Loading } from "@element-plus/icons-vue"
const props = defineProps({
    stepStore: Object,
})
</script>
<style lang="stylus" scoped>
.container
    max-width 1280px
    margin 10px auto
    display flex
    align-items center
    padding 0 10px
    background-color white
    gap 14px
    .steps
        flex 1
        .custom :deep(.el-step__icon)
            border none
    :deep(.el-button+.el-button)
        margin-left 0
@media only screen and (max-width 720px)
    .container
        flex-direction column
        align-items flex-end
        .steps
            align-self stretch
</style>
