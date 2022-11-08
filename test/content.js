const ContentT = artifacts.require("ContentT")

contract("测试发布并获取文章。", (accounts) => {
    it("测试发表并获取。", async () => {
        const instance = await ContentT.deployed()
        await instance.publishContent(accounts[0], "213213", "213213", true)
        const result = await instance.getContentsByAccount.call(accounts[0])
        console.log(result)
    }).timeout(10000)
})
