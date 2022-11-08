<template>
    <div class="navigator">
        <div class="menu">
            <NavigatorLink
                :icon="HashIcon"
                :to="{ name: 'index' }"
            ></NavigatorLink>
            <NavigatorLink
                v-if="accountStore.account"
                :icon="UserIcon"
                :to="{
                    name: 'account',
                    params: { account: accountStore.account },
                }"
            ></NavigatorLink>
            <NavigatorLink
                :icon="QuestionIcon"
                :to="{
                    name: 'about',
                }"
            ></NavigatorLink>

            <NuxtLink
                class="button go-metamask"
                v-if="!toteeStore.isMetaMask"
                to="https://metamask.app.link/dapp/totee.xyz/"
                >Open in Metamask</NuxtLink
            >
            <button
                v-else-if="toteeStore.isConnected"
                class="button round"
                @click="show"
            >
                {{ $t("Speak Out") }}
            </button>
            <button v-else @click="$totee.connect" class="button round">
                {{ $t("Connect Wallet") }}
            </button>
        </div>
    </div>
</template>
<script setup>
import HashIcon from "@/assets/svg/hash.svg?component"
import UserIcon from "@/assets/svg/user.svg?component"
import QuestionIcon from "@/assets/svg/question.svg?component"

import { useToteeStore } from "@/stores/totee"
import { useAccountStore } from "@/stores/account"

const toteeStore = useToteeStore()
const accountStore = useAccountStore()

const { $totee, $router } = useNuxtApp()

const show = useAuth(() => {
    $router.push({
        name: "post",
    })
})
</script>

<style lang="stylus" scoped>
.navigator
    position fixed
    bottom 0
    left 0
    right 0
    z-index 999

    background white
    padding 10px 10px
    margin 0
    .menu
        display flex
        flex-direction row
        justify-content space-between
        .go-metamask
            text-decoration none
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
            padding 0 40px
</style>
