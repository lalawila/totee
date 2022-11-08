import { createI18n } from "vue-i18n"

const languages = [
    {
        key: "en",
        text: "English",
        message: {
            Explore: "Explore",
            Profile: "Profile",
            Publish: "Publish",
            "Connect Wallet": "Connect Wallet",
            nobody: "nobody",
            "What is totee": "What is totee",
            Retot: "Retot",
            Reply: "Reply",
            Sign: "Sign",
            "View More": "View More",
            "Hide More": "Hide More",
            "no more": "no more",
            "totee-explain":
                "Totee is a completely decentralized social platform based on blockchain.",
            "totee-freedom": "There is freedom of speech here.",
            "a moment ago": "a moment ago",
            "minutes ago": "minutes ago",
            "hours ago": "hours ago",
            abort: "abort",
            continue: "continue",
            complete: "complete",
            "Signature content": "Signature content",
            "Upload to AR": "Upload to AR",
            "Publish to smart contract": "Publish to smart contract",
            "Connect wallet first.": "Connect wallet first.",
            "Speak Out": "Speak Out",
            "tot-placeholder": "Share your views",
            "reply-placeholder": "Share your reply",
            "Show Sign": "Show Sign",
            "Switch to polygon network.": "Switch to polygon network.",
            "Install MetaMask first.": "Install MetaMask first.",
            About: "About",
        },
    },
    {
        key: "zh",
        text: "中文",
        message: {
            Explore: "发现",
            Profile: "我的",
            Publish: "发布",
            nobody: "无名氏",
            "Connect Wallet": "连接钱包",
            "What is totee": "了解 Totee",
            Retot: "转发 tot",
            Reply: "回复",
            Sign: "签名",
            "View More": "显示全文",
            "Hide More": "隐藏全文",
            "no more": "没有更多了",
            "totee-explain": "Totee 是一个基于区块链完全去中心化的社交平台。",
            "totee-freedom": "这里有言论自由。",
            "a moment ago": "刚刚",
            "minutes ago": "分钟前",
            "hours ago": "小时前",
            abort: "中止",
            continue: "继续",
            complete: "完成",
            "Signature content": "签名内容",
            "Upload to AR": "上传到 AR",
            "Publish to smart contract": "发布到智能合约",
            "Connect wallet first.": "请先连接钱包。",
            "Speak Out": "创作",
            "tot-placeholder": "分享你的观点",
            "reply-placeholder": "分享你的回复",
            "Show Sign": "显示签名",
            "Switch to polygon network.": "请切换至 polygon 网络",
            "Install MetaMask first.": "请先安装 MetaMask 插件.",
            About: "关于",
        },
    },
]

function getMessages() {
    let result = {}
    for (const lang of languages) {
        result[lang.key] = lang.message
    }
    return result
}

function formatLang(lang: string) {
    if (lang.length == 2) {
        return lang
    }

    switch (lang) {
        case "zh-CN":
        case "zh-TW":
            return "zh"
        case "en-US":
            return "en"
    }
}

export default defineNuxtPlugin(() => {
    const _lang = useCookie("_lang")

    if (!_lang.value && process.client) {
        for (const lang of navigator.languages) {
            const formated = formatLang(lang)
            if (formated) {
                _lang.value = formated
                break
            }
        }
    }

    const i18n = createI18n({
        locale: _lang.value || "en",
        fallbackLocale: "en",
        messages: getMessages(),
    }).global

    i18n["switchLang"] = function (lang) {
        this.locale = lang
        _lang.value = lang
    }

    i18n["getChoices"] = function () {
        return languages.filter((lang) => lang.key != this.locale)
    }

    return {
        provide: {
            i18n,
            t: i18n.t,
        },
    }
})
