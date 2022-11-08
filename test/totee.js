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
        await this.totee.publishContent("123", "213123", true)
        console.log("发表2：")
        await this.totee.publishContent("456", "bbbbbbbbbbbbb", true)
        console.log("发表3：")
        await this.totee.publishContent("789", "bbbbbbbbbbbbb", true)
        console.log("发表4：")
        await this.totee.publishContent("abc", "bbbbbbbbbbbbb", true)
        console.log("发表5：")
        await this.totee.publishContent("efg", "213123", true)
    })
    // it("删除内容：", async () => {
    //     await this.totee.removeContent("123")
    // })
    it("移动内容：", async () => {
        await this.totee.test("efg", "789")
    })
    it("获取用户列表：", async () => {
        console.log(
            "用户列表：",
            await this.totee.getUserContents.call(accounts[0], "", 10, true)
        )
    })
    it("获取首页列表：", async () => {
        console.log(
            "首页列表：",
            await this.totee.getExploreContents.call("", 13, false)
        )
    })
    it("查看升级结果：", async () => {
        console.log("升级结果：", await this.totee.test2.call())
    })
})
