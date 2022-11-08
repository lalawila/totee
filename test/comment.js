const Totee = artifacts.require("Totee")
const User = artifacts.require("User")

contract("Totee", async (accounts) => {
    beforeEach(async () => {
        this.totee = await Totee.deployed()
    })

    it("注册流程：", async () => {
        await this.totee.setUsername("123456")
        console.log(
            "打印名字：",
            await this.totee.getUsername.call(accounts[0])
        )
    })
    it("发表流程：", async () => {
        console.log("发表1：")
        await this.totee.publishContent(
            "123",
            "第一次发表第一次发表第一次发表第一次发表",
            true
        )
        console.log("发表2：")
        await this.totee.publishContent(
            "456",
            "第二次发表第二次发表第二次发表第二次发表",
            true
        )
    })

    it("发表评论：", async () => {
        console.log("发表评论1：")
        await this.totee.publishComment(
            "123",
            "999",
            "第一次评论第一次评论第一次评论第一次评论",
            true
        )
        console.log("发表评论2：")
        await this.totee.publishComment(
            "123",
            "abc",
            "第一次评论第一次评论第一次评论第一次评论",
            true
        )
    })
    it("获取评论列表：", async () => {
        console.log(
            "评论列表反向：",
            await this.totee.getCommentsByArId.call("123", "", 10, true)
        )
        console.log(
            "评论列表正向：",
            await this.totee.getCommentsByArId.call("123", "", 10, false)
        )
    })
})
