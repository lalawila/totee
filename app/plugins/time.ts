const minute = 60
const hour = minute * 60
const day = hour * 24

function fillZero(i) {
    return i < 10 ? "0" + i : i
}

const timestampToTime = (timestamp) => {
    const date = new Date(timestamp * 1000) // 时间戳为10位需*1000，时间戳为13位的话不需乘1000
    const Y = date.getFullYear() + "-"
    const M = fillZero(date.getMonth() + 1) + "-"
    const D = fillZero(date.getDate()) + " "
    const h = fillZero(date.getHours()) + ":"
    const m = fillZero(date.getMinutes()) + ":"
    const s = fillZero(date.getSeconds())
    return Y + M + D + h + m + s
    // return Y + M + D
}

const beautifulTime = (timestamp) => {
    const { $t } = useNuxtApp()
    const gap = new Date().valueOf() / 1000 - timestamp
    if (gap < minute * 5) return $t("a moment ago")
    if (gap < hour) return Math.floor(gap / minute) + " " + $t("minutes ago")
    if (gap < day) return Math.floor(gap / hour) + " " + $t("hours ago")
    let result = timestampToTime(timestamp).substring(0, 11)
    if (new Date().getFullYear().toString() === result.substring(0, 4)) {
        result = result.substring(5)
    }
    return result
}

export default defineNuxtPlugin(async () => {
    return {
        provide: {
            timestampToTime,
            beautifulTime,
        },
    }
})
