export const onBottom = (callback = () => {}) => {
    function fuc() {
        // 下拉加载：2. 判断滚动条接近底部，100 个像素以内
        let bottomOfWindow =
            document.documentElement.scrollTop +
                document.documentElement.clientHeight >
            document.documentElement.offsetHeight - 100
        // scrollTop：滚动上去的距离
        // clientHeight：元素可见区域的高度
        // offsetHeight：整个元素的高度
        if (bottomOfWindow) {
            callback()
        }
    }

    onMounted(() => {
        window.addEventListener("scroll", fuc)
    })
    onUnmounted(() => {
        window.removeEventListener("scroll", fuc)
    })
}
