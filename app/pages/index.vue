<template>
    <div class="container">
        <!-- <h1 v-if="error">{{ error }}</h1> -->
        <!-- <el-alert
            title="这是一个测试的版本，数据随时可能丢失。"
            type="error"
            effect="dark"
            :closable="false"
        /> -->
        <div class="tot" v-for="content in indexContents">
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
            ></tot>
        </div>
        <div v-if="pending" v-for="_ of 6" class="ph-item">
            <div class="ph-col-2">
                <div class="ph-avatar"></div>
            </div>
            <div>
                <div class="ph-row">
                    <div class="ph-col-12 big"></div>
                    <div class="ph-col-12 big"></div>
                    <div class="ph-col-6 big"></div>
                    <div class="ph-col-12 empty"></div>
                    <div class="ph-col-8 empty"></div>
                    <div class="ph-col-4"></div>
                </div>
            </div>
        </div>
        <el-empty
            v-else-if="!indexContents || indexContents?.length == 0"
            description="没有获取到数据，请反馈给开发人员~"
        ></el-empty>
        <!-- <p v-if="pending">加载中</p> -->
        <p class="nomore" v-if="finished">{{ $t("no more") }}</p>
    </div>
</template>

<script setup>
import "placeholder-loading/dist/css/placeholder-loading.min.css"

let startArId = ""
const amount = 10

const finished = ref(false)

const { $totee } = useNuxtApp()
const {
    pending,
    refresh,
    data: indexContents,
    error,
} = await useLazyAsyncData(
    "indexContents",
    async () => {
        const result = await $totee.getExploreContents({
            startArId,
            amount,
        })
        if (result.length < amount) {
            finished.value = true
        }
        if (startArId == "") {
            return result
        }
        return indexContents.value.concat(result)
    },
    { server: false }
)

watch(error, () => console.error(error.value))

onBottom(async () => {
    if (pending.value || finished.value) return
    startArId = indexContents.value[indexContents.value.length - 1].arId
    refresh()
})
</script>

<style lang="stylus" scoped>
.container
    margin-top 20px
    .tot:not(:last-child)
        border-bottom #eee 1px solid
    .nomore
        text-align center
        color var(--minor-color)
        margin 80px 0
</style>
