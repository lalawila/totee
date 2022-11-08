const { upgradeProxy } = require("@openzeppelin/truffle-upgrades")

const Totee = artifacts.require("Totee")
const ToteeV2Retot = artifacts.require("ToteeV2Retot")

const Content = artifacts.require("Content")
const ContentV2Retot = artifacts.require("ContentV2Retot")

module.exports = async function (deployer) {
    const content = await Content.deployed()
    const contentv2 = await upgradeProxy(content.address, ContentV2Retot, {
        deployer,
    })

    const totee = await Totee.deployed()
    const toteev2 = await upgradeProxy(totee.address, ToteeV2Retot, {
        deployer,
    })
    console.log("toteev2 合约地址：", toteev2.address)
}
