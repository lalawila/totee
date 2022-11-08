// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../libraries/Encoder.sol";
import "./EternalStorage.sol";

struct SaltMark {
    bytes32 CHAIN_PREV;
    bytes32 CHAIN_NEXT;
    bytes32 CHAIN_DATA;
    bytes32 CHAIN_SCORE;
    //
    bytes32 CHAIN_LAST;
    bytes32 CHAIN_FIRST;
    bytes32 CHAIN_AMOUNT;
}



contract ChainStorage is EternalStorage {
    bytes32 constant CHAIN_SALT_MARK = "CHAIN_SALT_MARK:";

    bytes32 constant CHAIN_PREV = "CHAIN_PREV:";
    bytes32 constant CHAIN_NEXT = "CHAIN_NEXT:";
    bytes32 constant CHAIN_DATA = "CHAIN_DATA:";
    bytes32 constant CHAIN_SCORE = "CHAIN_SCORE:";

    bytes32 constant CHAIN_LAST = "CHAIN_LAST:";
    bytes32 constant CHAIN_FIRST = "CHAIN_FIRST:";
    bytes32 constant CHAIN_AMOUNT = "CHAIN_AMOUNT:";

    function submitChainData(bytes32 key) internal {
        bytes memory data = "";
        submitChainData(key, data);
    }

    function submitChainData(bytes32 key, bytes memory data) internal {
        submitChainDataWithSalt(0, key, data);
    }

    function submitChainDataWithSalt(bytes32 salt, bytes32 key) internal {
        bytes memory data = "";
        submitChainDataWithSalt(salt, key, data);
    }

    function getChainAmount() internal view returns (uint256) {
        return getChainAmountWithSalt(0);
    }

    function getChainKeyArray(
        bytes32 startKey,
        uint256 amount,
        bool reverse
    ) internal view returns (bytes32[] memory) {
        return getChainKeyArrayWithSalt(0, startKey, amount, reverse);
    }

    function getChainDataArray(
        bytes32 startKey,
        uint256 amount,
        bool reverse
    ) internal view returns (bytes[] memory) {
        return getChainDataArrayWithSalt(0, startKey, amount, reverse);
    }

    function submitChainDataWithSalt(
        bytes32 salt,
        bytes32 key,
        bytes memory data
    ) internal {
        SaltMark memory sm = setSaltMark(salt);
        require(
            getBytes32Value(sm.CHAIN_LAST) != key &&
                getBytes32Value(Encoder.getKey(sm.CHAIN_PREV, key)) == 0,
            "only allow submit once"
        );

        bytes32 lastArIdKey = getBytes32Value(sm.CHAIN_LAST);

        if (lastArIdKey == 0) {
            // 空链
            set(sm.CHAIN_FIRST, key);
        } else {
            set(Encoder.getKey(sm.CHAIN_NEXT, lastArIdKey), key);
            set(Encoder.getKey(sm.CHAIN_PREV, key), lastArIdKey);
        }

        // 设置最后一个为最新提交的 key
        set(sm.CHAIN_LAST, key);
        set(Encoder.getKey(sm.CHAIN_DATA, key), data);

        // 计数加一
        uint256Storage[sm.CHAIN_AMOUNT]++;
    }

    function getChainAmountWithSalt(bytes32 salt)
        internal
        view
        returns (uint256)
    {
        return uint256Storage[Encoder.getKey(CHAIN_AMOUNT, salt)];
    }

    function getChainKeyArrayWithSalt(
        bytes32 salt,
        bytes32 startKey,
        uint256 amount,
        bool reverse
    ) internal view returns (bytes32[] memory) {
        if (uint256Storage[Encoder.getKey(CHAIN_AMOUNT, salt)] == 0) {
            return new bytes32[](0);
        }
        SaltMark memory sm = getSaltMark(salt);


        bytes32 firstKey = getBytes32Value(sm.CHAIN_FIRST);
        bytes32 lastKey = getBytes32Value(sm.CHAIN_LAST);

        bytes32[] memory result = new bytes32[](amount);

        uint256 i;
        if (startKey == 0) {
            if (reverse) {
                startKey = lastKey;
            } else {
                startKey = firstKey;
            }
            result[0] = startKey;
            i = 1;
        } else {
            i = 0;
        }
        for (; i < amount; i++) {
            if (reverse) {
                if (startKey == firstKey) {
                    break;
                }
                startKey = getBytes32Value(
                    Encoder.getKey(sm.CHAIN_PREV, startKey)
                );
            } else {
                if (startKey == lastKey) {
                    break;
                }
                startKey = getBytes32Value(
                    Encoder.getKey(sm.CHAIN_NEXT, startKey)
                );
            }
            result[i] = startKey;
        }
        uint256 x = amount - i;
        assembly {
            mstore(result, sub(mload(result), x))
        }
        return result;
    }

    function getChainDataByKey(bytes32 key)
        internal
        view
        returns (bytes memory)
    {
        return getChainDataByKeyWithSalt(0, key);
    }

    function getChainDataByKeyWithSalt(bytes32 salt, bytes32 key)
        internal
        view
        returns (bytes memory)
    {
        SaltMark memory sm = getSaltMark(salt);
        return getBytesValue(Encoder.getKey(sm.CHAIN_DATA, key));
    }

    function getChainDataArrayWithSalt(
        bytes32 salt,
        bytes32 startKey,
        uint256 amount,
        bool reverse
    ) internal view returns (bytes[] memory) {
        SaltMark memory sm = getSaltMark(salt);

        bytes32[] memory keyArray = getChainKeyArrayWithSalt(
            salt,
            startKey,
            amount,
            reverse
        );
        bytes[] memory dataArray = new bytes[](keyArray.length);

        for (uint256 i = 0; i < keyArray.length; i++) {
            dataArray[i] = getBytesValue(
                Encoder.getKey(sm.CHAIN_DATA, keyArray[i])
            );
        }

        return dataArray;
    }

    function removeChainData(bytes32 key) internal {
        removeChainData(0, key);
    }

    function setSaltMark(bytes32 salt) internal returns (SaltMark memory) {
        bytes memory smData = getBytesValue(
            Encoder.getKey(CHAIN_SALT_MARK, salt)
        );

        if (smData.length == 0) {
            SaltMark memory sm = SaltMark({
                CHAIN_PREV: Encoder.getKey(CHAIN_PREV, salt),
                CHAIN_NEXT: Encoder.getKey(CHAIN_NEXT, salt),
                CHAIN_DATA: Encoder.getKey(CHAIN_DATA, salt),
                CHAIN_SCORE: Encoder.getKey(CHAIN_SCORE, salt),
                //
                CHAIN_LAST: Encoder.getKey(CHAIN_LAST, salt),
                CHAIN_FIRST: Encoder.getKey(CHAIN_FIRST, salt),
                CHAIN_AMOUNT: Encoder.getKey(CHAIN_AMOUNT, salt)
            });
            set(Encoder.getKey(CHAIN_SALT_MARK, salt), abi.encode(sm));
            return sm;
        } else {
            return abi.decode(smData, (SaltMark));
        }
    }

    function getSaltMark(bytes32 salt) internal view returns (SaltMark memory) {
        return
            abi.decode(
                getBytesValue(Encoder.getKey(CHAIN_SALT_MARK, salt)),
                (SaltMark)
            );
    }

    function removeChainData(bytes32 salt, bytes32 key) internal {
        SaltMark memory sm = getSaltMark(salt);

        bytes32 prev = getBytes32Value(Encoder.getKey(sm.CHAIN_PREV, key));
        bytes32 next = getBytes32Value(Encoder.getKey(sm.CHAIN_NEXT, key));

        bytes32 firstKey = getBytes32Value(sm.CHAIN_FIRST);
        bytes32 lastKey = getBytes32Value(sm.CHAIN_LAST);

        if (firstKey == key) {
            if (lastKey == key) {
                // 链上只有一条数据
                delete bytes32Storage[sm.CHAIN_LAST];
                delete bytes32Storage[sm.CHAIN_FIRST];
            } else {
                // 这是第一条数据
                // 删除后一元素的 prev
                // delete bytes32Storage[Encoder.getKey(sm.CHAIN_PREV, next)];
                // 设置第一条数据为下一个元素
                set(sm.CHAIN_FIRST, next);
            }
        } else {
            if (lastKey == key) {
                // 这是最后一条数据

                // 删除前一元素的 next
                // delete bytes32Storage[Encoder.getKey(sm.CHAIN_NEXT, prev)];
                //将最后一条数据设为前一个
                set(sm.CHAIN_LAST, prev);
            } else {
                // 前后都有数据

                // 让前一元素的 next 指向后一个元素
                set(Encoder.getKey(sm.CHAIN_NEXT, prev), next);
                // 让后一元素的 prev 指向前一个元素
                set(Encoder.getKey(sm.CHAIN_PREV, next), prev);
            }
        }

        // 删除数据
        delete bytesStorage[Encoder.getKey(sm.CHAIN_DATA, key)];
        delete bytesStorage[Encoder.getKey(sm.CHAIN_PREV, key)];
        delete bytesStorage[Encoder.getKey(sm.CHAIN_NEXT, key)];

        // 计数减一
        uint256Storage[sm.CHAIN_AMOUNT]--;
    }
    function moveToAfter(
        bytes32 from,
        bytes32 to
    ) internal {
        moveToAfter(0, from, to);
    }

    function moveToAfter(
        bytes32 salt,
        bytes32 from,
        bytes32 to
    ) internal {
        SaltMark memory sm = getSaltMark(salt);

        bytes32 firstKey = getBytes32Value(sm.CHAIN_FIRST);
        bytes32 lastKey = getBytes32Value(sm.CHAIN_LAST);

        bytes32 fromPrev = getBytes32Value(Encoder.getKey(sm.CHAIN_PREV, from));
        bytes32 fromNext = getBytes32Value(Encoder.getKey(sm.CHAIN_NEXT, from));

        bytes32 toNext = getBytes32Value(Encoder.getKey(sm.CHAIN_NEXT, to));

        if (toNext == from){
            return;
        }

        // 先移除 from
        if (from == firstKey) {
            // from 是第一个元素
            set(sm.CHAIN_FIRST, fromNext);
        } else if (from == lastKey) {
            // from 是最后一个元素
            set(sm.CHAIN_LAST, fromPrev);
        } else {
            set(Encoder.getKey(sm.CHAIN_NEXT, fromPrev), fromNext);
            set(Encoder.getKey(sm.CHAIN_PREV, fromNext), fromPrev);
        }


        // 设置 from 的 prev 为 to
        set(Encoder.getKey(sm.CHAIN_PREV, from), to);
        // 设置 to 的 next 为 from
        set(Encoder.getKey(sm.CHAIN_NEXT, to), from);

        if (to == lastKey) {
            // to 是最后一个元素
            // 设置最后一个元素为 from
            set(sm.CHAIN_LAST, from);
        } else {
            // 设置 from 的 next 为 to 的 next
            set(Encoder.getKey(sm.CHAIN_NEXT, from), toNext);
            // 设置 to 的 next 的 prev 为 from
            set(Encoder.getKey(sm.CHAIN_PREV, toNext), from);
        }
    }
}
