// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../storages/EternalStorage.sol";
import "../storages/ChainStorage.sol";
import "../libraries/Encoder.sol";

contract Explore is
    Initializable,
    EternalStorage,
    ChainStorage,
    OwnableUpgradeable
{
    function initialize() public initializer {
        __Ownable_init();
    }

    function submitContentArIdKey(bytes32 arIdKey) external onlyOwner {
        submitChainData(arIdKey);
    }

    // function test(bytes32 from, bytes32 to) external onlyOwner {
    //     moveToAfter(from, to);
    // }

    function getExploreArIdKeyArray(
        string calldata startArId,
        uint256 amount,
        bool reverse
    ) external view returns (bytes32[] memory) {
        return
            getChainKeyArray(Encoder.stringToKey(startArId), amount, reverse);
    }
}
