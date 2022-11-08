// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../libraries/Math.sol";

library Pagination {
    function paginate(
        bytes32[] memory array,
        uint256 page,
        uint256 limit
    ) internal pure returns (bytes32[] memory) {
        page -= 1;
        int256 start = int256(array.length) - int256(page) * int256(limit);

        int256 end = int256(start) - int256(limit);

        start = Math.getMin(start, int256(array.length));

        start = Math.getMax(start, 0);
        end = Math.getMax(end, 0);

        bytes32[] memory results = new bytes32[](uint256(start - end));

        uint256 x = 0;
        for (int256 i = start - 1; i >= end; i--) {
            uint256 t = uint256(i);
            results[x] = array[t];
            x++;
        }

        return results;
    }
}
