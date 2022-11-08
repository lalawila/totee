// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../storages/EternalStorage.sol";
import "../storages/ChainStorage.sol";
import "../libraries/Encoder.sol";

contract Comment is
    Initializable,
    EternalStorage,
    ChainStorage,
    OwnableUpgradeable
{
    function initialize() public initializer {
        __Ownable_init();
    }

    function submitCommentId(bytes32 contentArIdKey, bytes32 commentArIdKey)
        external
    {
        submitChainDataWithSalt(contentArIdKey, commentArIdKey);
    }

    function getCommentIdArray(
        string calldata contentArId,
        string calldata startCommentId,
        uint256 amount,
        bool reverse
    ) external view returns (bytes32[] memory) {
        return
            getChainKeyArrayWithSalt(
                Encoder.getKey(contentArId),
                Encoder.stringToKey(startCommentId),
                amount,
                reverse
            );
    }

    function getCommentAmountByArId(string calldata contentArId)
        external
        view
        returns (uint256)
    {
        return getChainAmountWithSalt(Encoder.getKey(contentArId));
    }
}
