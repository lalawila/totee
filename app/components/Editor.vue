<template>
    <div class="editor" ref="editorEl"></div>
</template>

<script setup>
const KB = 1024
const MB = KB * 1024

const props = defineProps({
    placeholder: String,
    maxHeight: {
        type: Number,
    },
    minHeight: {
        type: Number,
        default: 100,
    },
})

let editor = null // 编辑器
const editorEl = ref(null)

const isScroll = ref(false)
const overflowX = computed(() => (isScroll.value ? "hidden" : "visible"))
const overflowY = computed(() => (isScroll.value ? "auto" : "visible"))

onMounted(async (_) => {
    const EditorJS = (await import("@editorjs/editorjs")).default
    const ImageTool = (await import("@editorjs/image")).default
    const VideoTool = (await import("@weekwood/editorjs-video")).default
    const LinkTool = (await import("@editorjs/link")).default
    const Embed = (await import("@editorjs/embed")).default
    const Header = (await import("@editorjs/header")).default
    const List = (await import("@editorjs/list")).default

    const Undo = (await import("editorjs-undo")).default
    const DragDrop = (await import("editorjs-drag-drop")).default

    editor = new EditorJS({
        holder: editorEl.value,
        placeholder: props.placeholder,
        minHeight: 0,
        onReady: () => {
            new Undo({
                editor,
                config: {
                    shortcuts: {
                        redo: "CMD+SHIFT+Z",
                        undo: "CMD+Z",
                    },
                },
            })
            new DragDrop(editor)
        },
        onChange: () => {
            if (props.maxHeight) {
                if (editorEl.value.clientHeight >= props.maxHeight) {
                    isScroll.value = true
                } else {
                    isScroll.value = false
                }
            }
        },
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
                config: {
                    uploader: {
                        async uploadByFile(file) {
                            const { $ar, $compressor } = useNuxtApp()
                            console.log(file)
                            let quality = 1 - (file.size / 2) * MB
                            quality = Math.min(quality, 0.8)
                            quality = Math.max(quality, 0.1)

                            console.log(quality)

                            const afterFile = await $compressor(file, {
                                quality,
                                maxHeight: 2048,
                                maxWidth: 2048,
                                mimeType: "image/webp",
                            })

                            if (afterFile.size > file.size) {
                                afterFile = await $compressor(file, {
                                    quality,
                                    maxHeight: 2048,
                                    maxWidth: 2048,
                                    mimeType: "image/jpeg",
                                })
                            }

                            const arId = await $ar.uploadFile(afterFile)
                            if (!arId) {
                                return {
                                    success: 0,
                                }
                            }

                            return {
                                success: 1,
                                file: {
                                    url: `https://arweave.net/${arId}`,
                                },
                            }
                        },
                        uploadByUrl(url) {
                            console.log(url)
                        },
                    },
                },
            },
            // video: {
            //     class: VideoTool,
            //     config: {
            //         player: {
            //             controls: true,
            //             autoplay: false,
            //         },
            //         uploader: {
            //             async uploadByFile(file) {
            //                 const { $ar } = useNuxtApp()
            //                 const arId = await $ar.uploadFile(file)
            //                 return {
            //                     success: 1,
            //                     file: {
            //                         url: `https://arweave.net/${arId}`,
            //                     },
            //                 }
            //             },
            //         },
            //     },
            // },
        },
    })
})

async function save() {
    return await editor.save()
}
defineExpose({ save })
</script>
<style lang="stylus" scoped>
.editor
    max-height v-bind('maxHeight + "px"')
    overflow-x v-bind('overflowX')
    overflow-y v-bind('overflowY')
    :deep(.codex-editor__redactor)
        min-height v-bind('minHeight + "px"')
    :deep(.ce-block__content)
        max-width unset
    :deep(.codex-editor__loader)
        display none!important
    :deep(.image-tool__image-picture)
        margin 0 auto
    :deep(.image-tool__caption)
        font-size 14px
        color var(--minor-color)
        text-align center
        padding 0
        border  none
    :deep(.image-tool__caption[contentEditable="true"][data-placeholder]:empty::before)
        display block
        right 0
        left 0
        margin auto
        width max-content
    @media (max-width: 650px)
        :deep(.ce-popover)
            bottom calc(80px + env(safe-area-inset-bottom))
</style>
