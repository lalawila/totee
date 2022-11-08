<template>
    <div>
        <div class="box" :style="`border-width:${borderSize}`">
            <el-image
                @click="prevent"
                :src="props.src || '/default/avatar.jpg'"
                class="avatar"
                fit="cover"
                :style="`width:${size};height:${size}`"
                :preview-src-list="
                    isPreview ? [props.src || '/default/avatar.jpg'] : []
                "
                :preview-teleported="true"
            />
        </div>
    </div>
</template>
<script setup>
const props = defineProps({
    src: String,
    size: {
        type: Number,
        default: 64,
    },
    borderSize: {
        type: Number,
        default: 0,
    },
    isPreview: {
        type: Boolean,
        default: true,
    },
})
const size = computed((_) => `${props.size}px`)
const borderSize = computed((_) => `${props.borderSize}px`)

function prevent(event) {
    event.preventDefault()
}
</script>
<style lang="stylus" scoped>
.box
    // border-width v-bind('borderSize')
    display inline-block

    border-style solid
    border-color white
    border-radius 36%
    overflow hidden
    .avatar
        display block
        cursor pointer
        // width  v-bind('size')
    .avatar:hover
        filter brightness(80%)
</style>
