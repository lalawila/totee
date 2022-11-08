<template>
    <NuxtLink class="link" :to="to">
        <div class="button round">
            <component class="icon" :is="props.icon"></component>
            <span v-if="props.label" class="name">{{ props.label }}</span>
        </div>
    </NuxtLink>
</template>
<script setup>
const props = defineProps({
    icon: Object,
    label: String,
    to: Object,
})
</script>
<style lang="stylus" scope>
.link
    display block
    color inherit
    text-decoration none
    .button
        display inline-flex
        align-items center
        padding 12px
        transition 0.2s
        .icon
            width 26px
            height 26px
            color var(--second-color)
        .name
            font-size 20px
            margin 0 20px
.link:hover
    .button
        background-color #e7e7e8
</style>
