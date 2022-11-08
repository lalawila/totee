const { deployProxy } = require("@openzeppelin/truffle-upgrades")

const Totee = artifacts.require("Totee")
const User = artifacts.require("User")
const Content = artifacts.require("Content")
const Explore = artifacts.require("Explore")
const Comment = artifacts.require("Comment")

module.exports = async function (deployer) {
    const user = await deployProxy(User, [], { deployer })
    const content = await deployProxy(Content, [], { deployer })
    const explore = await deployProxy(Explore, [], { deployer })
    const comment = await deployProxy(Comment, [], { deployer })
    const totee = await deployProxy(
        Totee,
        [user.address, content.address, explore.address, comment.address],
        {
            deployer,
        }
    )

    await user.transferOwnership(totee.address)
    await content.transferOwnership(totee.address)
    await explore.transferOwnership(totee.address)
    await comment.transferOwnership(totee.address)

    console.log("合约地址：", totee.address)
}
