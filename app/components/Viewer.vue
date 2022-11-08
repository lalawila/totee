<template>
    <div
        class="viewer"
        :class="{ center: props.centerImg }"
        ref="viewerEl"
    ></div>
</template>
<script setup>
let viewer = null // 编辑器变量
const viewerEl = ref(null)

const props = defineProps({
    content: Object,
    centerImg: {
        type: Boolean,
        default: false,
    },
    maxHeightImg: {
        type: Number,
    },
})

const maxHeightImg = computed(() =>
    maxHeightImg ? `${props.maxHeightImg}px` : "auto"
)

onMounted(async () => {
    const EditorJS = (await import("@editorjs/editorjs")).default
    const ImageTool = (await import("@editorjs/image")).default
    const VideoTool = (await import("@weekwood/editorjs-video")).default
    const LinkTool = (await import("@editorjs/link")).default
    const Embed = (await import("@editorjs/embed")).default
    const Header = (await import("@editorjs/header")).default
    const List = (await import("@editorjs/list")).default

    viewer = new EditorJS({
        holder: viewerEl.value,
        readOnly: true,
        data: props.content,
        minHeight: 0,
        tools: {
            header: {
                class: Header,
                config: {
                    placeholder: "Enter a header",
                    levels: [1, 2],
                    defaultLevel: 1,
                },
            },
            embed: Embed,
            list: {
                class: List,
                inlineToolbar: true,
                config: {
                    defaultStyle: "unordered",
                },
            },
            // linkTool: {
            //     class: LinkTool,
            //     config: {
            //         // endpoint: "http://localhost:8008/fetchUrl", // Your backend endpoint for url data fetching,
            //     },
            // },
            image: {
                class: ImageTool,
            },
            video: {
                class: VideoTool,
                config: {
                    player: {
                        controls: true,
                        autoplay: false,
                    },
                },
            },
        },
    })
})

watch(
    () => props.content,
    async () => {
        await viewer.isReady
        // console.log(props.content)
        // viewer.clear()
        viewer.render(props.content)
    }
)
</script>

<style lang="stylus" scoped>
.viewer
    :deep(.ce-block__content)
        max-width unset

    :deep(.codex-editor__loader)
        display none
    :deep(.codex-editor__redactor)
        margin-right 0
    :deep(.image-tool__image-picture)
        max-height v-bind('maxHeightImg')
        border-radius 18px
    :deep(.image-tool__caption)
        font-size 14px
        color var(--minor-color)
        padding 0
        border  none

    :deep(.video-tool__video > div)
        width 100%  !important
        height auto !important

.viewer.center
    :deep(.image-tool__image-picture)
        margin 0 auto
    :deep(.image-tool__caption)
        text-align center
</style>
