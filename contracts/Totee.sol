// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./storages/EternalStorage.sol";
import "./modules/User.sol";
import "./modules/Content.sol";
import "./modules/Explore.sol";
import "./modules/Comment.sol";

struct ResultContent {
    string replyToArId;
    string authorName;
    string avatarUrl;
    address authorAccount;
    uint256 commentAmount;
    string arId;
    string content;
    bool completed;
    uint256 publishTime;
}

contract Totee is Initializable, OwnableUpgradeable {
    User private _user;
    Content private _content;
    Explore private _explore;
    Comment private _comment;

    function initialize(
        User user,
        Content content,
        Explore explore,
        Comment comment
    ) public initializer {
        _user = user;
        _content = content;
        _explore = explore;
        _comment = comment;
    }

    function setUsername(string calldata username) public {
        _user.setUsername(msg.sender, username);
    }

    function setAvatarUrl(string calldata avatarUrl) public {
        _user.setAvatarUrl(msg.sender, avatarUrl);
    }

    function setBannerUrl(string calldata bannerUrl) public {
        _user.setBannerUrl(msg.sender, bannerUrl);
    }

    function getUsername(address account) public view returns (string memory) {
        return _user.getUsername(account);
    }

    function getAvatarUrl(address account) public view returns (string memory) {
        return _user.getAvatarUrl(account);
    }

    function getBannerUrl(address account) public view returns (string memory) {
        return _user.getBannerUrl(account);
    }

    function getUserPageInfo(address account)
        public
        view
        returns (UserPageInfo memory)
    {
        return _user.getUserPageInfo(account);
    }

    function publishContent(
        string calldata arId,
        string calldata content,
        bool completed
    ) external {
        bytes32 arIdKey = _content.publishContent(
            msg.sender,
            "",
            arId,
            content,
            completed
        );
        _user.submitContentArIdKey(msg.sender, arIdKey);
        _explore.submitContentArIdKey(arIdKey);
    }

    function publishComment(
        string calldata replyToArId,
        string calldata commentArId,
        string calldata content,
        bool completed
    ) external {
        bytes32 commentArIdKey = _content.publishContent(
            msg.sender,
            replyToArId,
            commentArId,
            content,
            completed
        );
        bytes32 replyToArIdKey = Encoder.getKey(replyToArId);
        _comment.submitCommentId(replyToArIdKey, commentArIdKey);
    }

    function getCommentsByArId(
        string calldata contentArId,
        string calldata startCommentId,
        uint256 amount,
        bool reverse
    ) public view returns (ResultContent[] memory) {
        bytes32[] memory commentIds = _comment.getCommentIdArray(
            contentArId,
            startCommentId,
            amount,
            reverse
        );
        ReturnContent[] memory comments = _content.getContentsByArIdKeyArray(
            commentIds
        );

        return getResultContentByReturn(comments);

        // ResultContent[] memory result = new ResultContent[](comments.length);

        // for (uint256 i = 0; i < comments.length; i++) {
        //     result[i] = ResultContent({
        //         authorName: _user.getUsername(comments[i].authorAccount),
        //         avatarUrl: _user.getAvatarUrl(comments[i].authorAccount),
        //         commentAmount: _comment.getCommentAmountByArIdKey(
        //             commentIds[i]
        //         ),
        //         replyToArId: comments[i].replyToArId,
        //         authorAccount: comments[i].authorAccount,
        //         arId: comments[i].arId,
        //         content: comments[i].content,
        //         completed: comments[i].completed,
        //         publishTime: comments[i].publishTime
        //     });
        // }

        // return result;
    }

    function getUserContents(
        address account,
        string calldata startArId,
        uint256 amount,
        bool reverse
    ) public view returns (ResultContent[] memory) {
        bytes32[] memory arIdKeys = _user.getContentArIdKeyArray(
            account,
            startArId,
            amount,
            reverse
        );

        ReturnContent[] memory contents = _content.getContentsByArIdKeyArray(
            arIdKeys
        );

        return getResultContentByReturn(contents);
    }

    function removeContent(string calldata arId) public {
        bytes32 arIdKey = Encoder.getKey(arId);
        _user.removeContentByArIdKey(msg.sender, arIdKey);
    }

    function getResultContentByReturn(ReturnContent[] memory contents)
        internal
        view
        returns (ResultContent[] memory)
    {
        ResultContent[] memory result = new ResultContent[](contents.length);

        for (uint256 i = 0; i < contents.length; i++) {
            result[i] = ResultContent({
                replyToArId: contents[i].replyToArId,
                authorName: _user.getUsername(contents[i].authorAccount),
                avatarUrl: _user.getAvatarUrl(contents[i].authorAccount),
                commentAmount: _comment.getCommentAmountByArId(
                    contents[i].arId
                ),
                authorAccount: contents[i].authorAccount,
                arId: contents[i].arId,
                content: contents[i].content,
                completed: contents[i].completed,
                publishTime: contents[i].publishTime
            });
        }

        return result;
    }

    function getExploreContents(
        string calldata startArId,
        uint256 amount,
        bool reverse
    ) public view returns (ResultContent[] memory) {
        bytes32[] memory arIdKeys = _explore.getExploreArIdKeyArray(
            startArId,
            amount,
            reverse
        );

        ReturnContent[] memory contents = _content.getContentsByArIdKeyArray(
            arIdKeys
        );

        return getResultContentByReturn(contents);

        // ResultContent[] memory result = new ResultContent[](contents.length);

        // for (uint256 i = 0; i < contents.length; i++) {
        //     result[i] = ResultContent({
        //         authorName: _user.getUsername(contents[i].authorAccount),
        //         avatarUrl: _user.getAvatarUrl(contents[i].authorAccount),
        //         commentAmount: _comment.getCommentAmountByArIdKey(arIdKeys[i]),
        //         authorAccount: contents[i].authorAccount,
        //         arId: contents[i].arId,
        //         content: contents[i].content,
        //         completed: contents[i].completed,
        //         publishTime: contents[i].publishTime
        //     });
        // }

        // return result;
    }

    // function test(string calldata from, string calldata to) external {
    //     _explore.test(Encoder.stringToKey(from), Encoder.stringToKey(to));
    // }
}
