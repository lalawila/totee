// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../storages/EternalStorage.sol";
import "../storages/ChainStorage.sol";
import "../libraries/Encoder.sol";
import "../libraries/Math.sol";
import "../libraries/Pagination.sol";

struct UserPageInfo {
    string username;
    string avatarUrl;
    string bannerUrl;
}

contract User is
    Initializable,
    EternalStorage,
    ChainStorage,
    OwnableUpgradeable
{
    bytes32 private constant USERNAME = "USERNAME:";
    bytes32 private constant CONTENTS = "CONTENTS:";
    bytes32 private constant AVATAR_URL = "AVATAR_URL:";
    bytes32 private constant BANNER_URL = "BANNER_URL:";

    function initialize() public initializer {
        __Ownable_init();
    }

    function getUserPageInfo(address account)
        public
        view
        returns (UserPageInfo memory)
    {
        return
            UserPageInfo({
                username: getUsername(account),
                avatarUrl: getAvatarUrl(account),
                bannerUrl: getBannerUrl(account)
            });
    }

    function setUsername(address account, string calldata username)
        public
        onlyOwner
    {
        bytes32 key = Encoder.getKey(USERNAME, account);
        set(key, username);
    }

    function getUsername(address account) public view returns (string memory) {
        bytes32 key = Encoder.getKey(USERNAME, account);
        return getStringValue(key);
    }

    function setAvatarUrl(address account, string calldata avatarUrl)
        public
        onlyOwner
    {
        bytes32 key = Encoder.getKey(AVATAR_URL, account);
        set(key, avatarUrl);
    }

    function getAvatarUrl(address account) public view returns (string memory) {
        bytes32 key = Encoder.getKey(AVATAR_URL, account);
        return getStringValue(key);
    }

    function setBannerUrl(address account, string calldata bannerUrl)
        public
        onlyOwner
    {
        bytes32 key = Encoder.getKey(BANNER_URL, account);
        set(key, bannerUrl);
    }

    function getBannerUrl(address account) public view returns (string memory) {
        bytes32 key = Encoder.getKey(BANNER_URL, account);
        return getStringValue(key);
    }

    function submitContentArIdKey(address account, bytes32 arIdKey)
        external
        onlyOwner
    {
        submitChainDataWithSalt(Encoder.getKey(account), arIdKey);
    }

    function getContentArIdKeyArray(
        address account,
        string calldata startArId,
        uint256 amount,
        bool reverse
    ) external view returns (bytes32[] memory) {
        return
            getChainKeyArrayWithSalt(
                Encoder.getKey(account),
                Encoder.stringToKey(startArId),
                amount,
                reverse
            );
    }

    function removeContentByArIdKey(address account, bytes32 key)
        external
        onlyOwner
    {
        removeChainData(Encoder.getKey(account), key);
    }
}
