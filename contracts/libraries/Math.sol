// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library Math {
    function getMax(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    function getMin(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }
}
