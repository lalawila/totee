// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../storages/EternalStorage.sol";
import "../storages/ChainStorage.sol";
import "../libraries/Encoder.sol";

struct ContentV1 {
    string replyToArId;
    address authorAccount;
    string arId;
    string content;
    bool completed;
    uint256 publishTime;
}

struct ReturnContent {
    string replyToArId;
    string arId;
    address authorAccount;
    string content;
    bool completed;
    uint256 publishTime;
}

contract ContentV2Retot is
    Initializable,
    EternalStorage,
    ChainStorage,
    OwnableUpgradeable
{
    bytes32 constant CONTENTS = "CONTENTS:";
    bytes32 constant RETOT_AMOUNT = "RETOT_AMOUNT:";

    function initialize() public initializer {
        __Ownable_init();
    }

    function publishContent(
        address authorAccount,
        string calldata replyToArId,
        string calldata arId,
        string calldata content,
        bool completed
    ) external onlyOwner returns (bytes32) {
        bytes32 arIdKey = Encoder.getKey(arId);
        ContentV1 memory ct = ContentV1({
            replyToArId: replyToArId,
            authorAccount: authorAccount,
            arId: arId,
            content: content,
            completed: completed,
            publishTime: block.timestamp
        });
        VersionBox memory vb = VersionBox({version: 1, data: abi.encode(ct)});
        set(Encoder.getKey(CONTENTS, arIdKey), abi.encode(vb));
        return arIdKey;
    }

    function getContentsByArIdKeyArray(bytes32[] calldata arIdKeys)
        external
        view
        returns (ReturnContent[] memory)
    {
        ReturnContent[] memory results = new ReturnContent[](arIdKeys.length);

        for (uint256 i = 0; i < arIdKeys.length; i++) {
            VersionBox memory vb = abi.decode(
                getBytesValue(Encoder.getKey(CONTENTS, arIdKeys[i])),
                (VersionBox)
            );
            if (vb.version == 1) {
                ContentV1 memory ct = abi.decode(vb.data, (ContentV1));

                results[i] = ReturnContent({
                    replyToArId: ct.replyToArId,
                    arId: ct.arId,
                    authorAccount: ct.authorAccount,
                    content: ct.content,
                    completed: ct.completed,
                    publishTime: ct.publishTime
                });
            }
        }

        return results;
    }

    function isExist(bytes32 arIdKey) external view returns (bool) {
        return getBytesValue(Encoder.getKey(CONTENTS, arIdKey)).length > 0;
    }

    function increaseRetotAmount(bytes32 arIdKey) external onlyOwner {
        uint256Storage[arIdKey]++;
    }

    function getRetotAmountByArId(string calldata arId)
        external
        view
        returns (uint256)
    {
        return uint256Storage[Encoder.getKey(arId)];
    }
}
