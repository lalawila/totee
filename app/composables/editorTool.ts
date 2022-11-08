export const getExcerpt = (content, limit = 300) => {
    // 如果总体长度超 300 * 0.8 字符，或存在一张图片，就不完全显示
    // 1. 将文本截取 300 * 0.8 字符作为展示文本
    // 2. 将图片取出第一张作为缩略图

    // 否则全部显示

    // console.assert(limit > 200, "requered limit  bigger than 200")

    let excerpt = ""
    let thumbnail = ""
    let video = ""

    for (const block of content.blocks) {
        if (block.type == "header" || block.type == "paragraph") {
            excerpt += block.data.text
        } else if (block.type == "image" && thumbnail == "") {
            thumbnail = block.data.file.url
        } else if (block.type == "video" && video == "") {
            video = block.data.file.url
        }
    }

    if (JSON.stringify(content).length < limit) {
        return { excerpt: content, completed: true }
    }

    const element = document.createElement("div")
    element.innerHTML = excerpt
    excerpt = element.innerText

    const excerptLimit = Math.floor(limit * 0.5)

    let ellipsis = false

    if (excerpt.length > excerptLimit) {
        ellipsis = true
        excerpt = excerpt.substring(0, excerptLimit - 10)
    }

    if (video) {
        return { excerpt: { excerpt, video, ellipsis }, completed: false }
    } else if (thumbnail) {
        return { excerpt: { excerpt, thumbnail, ellipsis }, completed: false }
    } else {
        return { excerpt: { excerpt, ellipsis }, completed: false }
    }
}
