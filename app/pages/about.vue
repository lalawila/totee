<template>
    <aside class="sider">
        <div class="trans-box">
            <el-popover
                popper-class="trans-popover"
                placement="bottom"
                trigger="click"
            >
                <template #reference>
                    <TransIcon></TransIcon>
                </template>

                <!-- <div class="lang" @click="switchLang('zh')">中文</div> -->
                <div
                    v-for="lang in $i18n.getChoices()"
                    @click="switchLang(lang.key)"
                    class="lang"
                >
                    {{ lang.text }}
                </div>
            </el-popover>
        </div>
        <p>{{ $t("totee-explain") }}</p>
        <p>{{ $t("totee-freedom") }}</p>
        <div class="to-right">
            <el-link
                class="explore"
                target="_blank"
                href="https://totee.notion.site/Totee-a2eee3b5457c40f480cf872f7246a7f7#d6ad78a9-69cd-45f3-91c5-3d47b3476a5a"
                type="primary"
                >{{ $t("What is totee") }}</el-link
            >
        </div>
        <div class="social-list">
            <nuxt-link
                class="social"
                title="discord"
                target="_blank"
                href="https://discord.gg/ufrREYCzw9"
                type="primary"
                ><DiscordIcon
            /></nuxt-link>
            <nuxt-link
                class="social"
                title="twitter"
                target="_blank"
                href="https://twitter.com/totee_xyz"
                type="primary"
                ><TwitterIcon
            /></nuxt-link>
        </div>
    </aside>
</template>
<script setup>
import TransIcon from "@/assets/svg/trans.svg?component"
import DiscordIcon from "@/assets/svg/discord.svg?component"
import TwitterIcon from "@/assets/svg/twitter.svg?component"

const { $i18n } = useNuxtApp()

function switchLang(key) {
    $i18n.switchLang(key)
}
</script>

<style lang="stylus" scoped>
.sider
    padding 10px
    position sticky
    top 0
    .trans-box
        text-align right
        margin 20px 0
        font-size 26px
    .to-right
        text-align right
        .explore
            font-size 24px
            font-weight bold

    .social-list
        margin 20px 0
        .social
            display inline-block
        .social + .social
            margin-left 20px
</style>
<style lang="stylus">
.el-popper.trans-popover
    padding 0
    .lang
        display block
        width 100%
        padding 10px 25px
        cursor pointer
        font-weight bold
    .lang:hover
        background-color #b1eae5
</style>
