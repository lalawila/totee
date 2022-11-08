// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library Encoder {
    function stringToKey(string calldata str) internal pure returns (bytes32) {
        bytes32 key;
        if (bytes(str).length == 0) {
            key = 0;
        } else {
            key = Encoder.getKey(str);
        }
        return key;
    }

    //
    function getKey(string calldata _key) internal pure returns (bytes32) {
        return bytes32(keccak256(abi.encodePacked(_key)));
    }

    function getKey(string calldata _key1, address _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(string calldata _key1, string calldata _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(string calldata _key1, uint256 _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(string calldata _key1, bytes32 _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(string calldata _key1, bool _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    // bytes32
    function getKey(bytes32 _key1, address _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(bytes32 _key1, string calldata _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(bytes32 _key1, uint256 _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(bytes32 _key1, bytes32 _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(bytes32 _key1, bool _key2) internal pure returns (bytes32) {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    // address
    function getKey(address _key) internal pure returns (bytes32) {
        return bytes32(keccak256(abi.encodePacked(_key)));
    }

    function getKey(address _key1, address _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(address _key1, string calldata _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(address _key1, uint256 _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(address _key1, bytes32 _key2)
        internal
        pure
        returns (bytes32)
    {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function getKey(address _key1, bool _key2) internal pure returns (bytes32) {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }
}
