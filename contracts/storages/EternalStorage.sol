// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

struct VersionBox {
    uint256 version;
    bytes data;
}

contract EternalStorage {
    /// @notice Internal mappings used to store all kinds on data into the contract
    mapping(bytes32 => uint256) internal uint256Storage;
    mapping(bytes32 => string) internal stringStorage;
    mapping(bytes32 => address) internal addressStorage;
    mapping(bytes32 => bytes) internal bytesStorage;
    mapping(bytes32 => bool) internal boolStorage;
    mapping(bytes32 => int256) internal intStorage;
    mapping(bytes32 => bytes32) internal bytes32Storage;

    /// @notice Internal mappings used to store arrays of different data types
    mapping(bytes32 => bytes32[]) internal bytes32ArrayStorage;
    mapping(bytes32 => uint256[]) internal uint256ArrayStorage;
    mapping(bytes32 => int256[]) internal int256ArrayStorage;
    mapping(bytes32 => address[]) internal addressArrayStorage;
    mapping(bytes32 => string[]) internal stringArrayStorage;
    mapping(bytes32 => bytes[]) internal bytesArrayStorage;

    //////////////////
    //// set functions
    //////////////////
    /// @notice Set the key values using the Overloaded `set` functions
    /// Ex- string version = "0.0.1"; replace to
    /// set(keccak256(abi.encodePacked("version"), "0.0.1");
    /// same for the other variables as well some more example listed below
    /// ex1 - address securityTokenAddress = 0x123; replace to
    /// set(keccak256(abi.encodePacked("securityTokenAddress"), 0x123);
    /// ex2 - bytes32 tokenDetails = "I am ST20"; replace to
    /// set(keccak256(abi.encodePacked("tokenDetails"), "I am ST20");
    /// ex3 - mapping(string => address) ownedToken;
    /// set(keccak256(abi.encodePacked("ownedToken", "Chris")), 0x123);
    /// ex4 - mapping(string => uint) tokenIndex;
    /// tokenIndex["TOKEN"] = 1; replace to set(keccak256(abi.encodePacked("tokenIndex", "TOKEN"), 1);
    /// ex5 - mapping(string => SymbolDetails) registeredSymbols; where SymbolDetails is the structure having different type of values as
    /// {uint256 date, string name, address owner} etc.
    /// registeredSymbols["TOKEN"].name = "MyFristToken"; replace to set(keccak256(abi.encodePacked("registeredSymbols_name", "TOKEN"), "MyFirstToken");
    /// More generalized- set(keccak256(abi.encodePacked("registeredSymbols_<struct variable>", "keyname"), "value");

    function set(bytes32 _key, uint256 _value) internal {
        uint256Storage[_key] = _value;
    }

    function set(bytes32 _key, address _value) internal {
        addressStorage[_key] = _value;
    }

    function set(bytes32 _key, bool _value) internal {
        boolStorage[_key] = _value;
    }

    function set(bytes32 _key, bytes32 _value) internal {
        bytes32Storage[_key] = _value;
    }

    function set(bytes32 _key, string memory _value) internal {
        stringStorage[_key] = _value;
    }

    function set(bytes32 _key, bytes memory _value) internal {
        bytesStorage[_key] = _value;
    }

    /// Public getters functions
    /////////////////////// @notice Get function use to get the value of the singleton state variables
    /// Ex1- string internal version = "0.0.1";
    /// string _version = getString(keccak256(abi.encodePacked("version"));
    /// Ex2 - assert(temp1 == temp2); replace to
    /// assert(getUint(keccak256(abi.encodePacked(temp1)) == getUint(keccak256(abi.encodePacked(temp2));
    /// Ex3 - mapping(string => SymbolDetails) registeredSymbols; where SymbolDetails is the structure having different type of values as
    /// {uint256 date, string name, address owner} etc.
    /// string _name = getString(keccak256(abi.encodePacked("registeredSymbols_name", "TOKEN"));

    function getUintValue(bytes32 _variable) internal view returns (uint256) {
        return uint256Storage[_variable];
    }

    function getBoolValue(bytes32 _variable) internal view returns (bool) {
        return boolStorage[_variable];
    }

    function getStringValue(bytes32 _variable)
        internal
        view
        returns (string memory)
    {
        return stringStorage[_variable];
    }

    function getAddressValue(bytes32 _variable)
        internal
        view
        returns (address)
    {
        return addressStorage[_variable];
    }

    function getBytes32Value(bytes32 _variable)
        internal
        view
        returns (bytes32)
    {
        return bytes32Storage[_variable];
    }

    function getBytesValue(bytes32 _variable)
        internal
        view
        returns (bytes memory)
    {
        return bytesStorage[_variable];
    }

    ////////////////////////////
    // deleteArray functions
    ////////////////////////////
    /// @notice Function used to delete the array element.
    /// Ex1- mapping(address => bytes32[]) tokensOwnedByOwner;
    /// For deleting the item from array developers needs to create a funtion for that similarly
    /// in this case we have the helper function deleteArrayBytes32() which will do it for us
    /// deleteArrayBytes32(keccak256(abi.encodePacked("tokensOwnedByOwner", 0x1), 3); -- it will delete the index 3

    //Deletes from mapping (bytes32 => array[]) at index _index
    function deleteArrayAddress(bytes32 _key, uint256 _index) internal {
        address[] storage array = addressArrayStorage[_key];
        require(
            _index < array.length,
            "Index should less than length of the array"
        );
        array[_index] = array[array.length - 1];
        array.pop();
    }

    //Deletes from mapping (bytes32 => bytes32[]) at index _index
    function deleteArrayBytes32(bytes32 _key, uint256 _index) internal {
        bytes32[] storage array = bytes32ArrayStorage[_key];
        require(
            _index < array.length,
            "Index should less than length of the array"
        );
        array[_index] = array[array.length - 1];
        array.pop();
    }

    //Deletes from mapping (bytes32 => uint[]) at index _index
    function deleteArrayUint256(bytes32 _key, uint256 _index) internal {
        uint256[] storage array = uint256ArrayStorage[_key];
        require(
            _index < array.length,
            "Index should less than length of the array"
        );
        array[_index] = array[array.length - 1];
        array.pop();
    }

    //Deletes from mapping (bytes32 => int[]) at index _index
    function deleteArrayInt256(bytes32 _key, uint256 _index) internal {
        int256[] storage array = int256ArrayStorage[_key];
        require(
            _index < array.length,
            "Index should less than length of the array"
        );
        array[_index] = array[array.length - 1];
        array.pop();
    }

    //Deletes from mapping (bytes32 => string[]) at index _index
    function deleteArrayString(bytes32 _key, uint256 _index) internal {
        string[] storage array = stringArrayStorage[_key];
        require(
            _index < array.length,
            "Index should less than length of the array"
        );
        array[_index] = array[array.length - 1];
        array.pop();
    }

    ////////////////////////////
    //// pushArray functions
    ///////////////////////////
    /// @notice Below are the helper functions to facilitate storing arrays of different data types.
    /// Ex1- mapping(address => bytes32[]) tokensOwnedByTicker;
    /// tokensOwnedByTicker[owner] = tokensOwnedByTicker[owner].push("xyz"); replace with
    /// pushArray(keccak256(abi.encodePacked("tokensOwnedByTicker", owner), "xyz");

    /// @notice use to store the values for the array
    /// @param _key bytes32 type
    /// @param _value [uint256, string, bytes32, address] any of the data type in array
    function pushArray(bytes32 _key, address _value) internal {
        addressArrayStorage[_key].push(_value);
    }

    function pushArray(bytes32 _key, bytes32 _value) internal {
        bytes32ArrayStorage[_key].push(_value);
    }

    function pushArray(bytes32 _key, string memory _value) internal {
        stringArrayStorage[_key].push(_value);
    }

    function pushArray(bytes32 _key, uint256 _value) internal {
        uint256ArrayStorage[_key].push(_value);
    }

    function pushArray(bytes32 _key, bytes memory _value) internal {
        bytesArrayStorage[_key].push(_value);
    }

    function pushArray(bytes32 _key, int256 _value) internal {
        int256ArrayStorage[_key].push(_value);
    }

    /////////////////////////
    //// Set Array functions
    ////////////////////////
    /// @notice used to intialize the array
    /// Ex1- mapping (address => address[]) internal reputation;
    /// reputation[0x1] = new address[](0); It can be replaced as
    /// setArray(hash('reputation', 0x1), new address[](0));

    function setArray(bytes32 _key, address[] memory _value) internal {
        addressArrayStorage[_key] = _value;
    }

    function setArray(bytes32 _key, uint256[] memory _value) internal {
        uint256ArrayStorage[_key] = _value;
    }

    function setArray(bytes32 _key, bytes32[] memory _value) internal {
        bytes32ArrayStorage[_key] = _value;
    }

    function setArray(bytes32 _key, string[] memory _value) internal {
        stringArrayStorage[_key] = _value;
    }

    function setArray(bytes32 _key, bytes[] memory _value) internal {
        bytesArrayStorage[_key] = _value;
    }

    function setArray(bytes32 _key, int256[] memory _value) internal {
        int256ArrayStorage[_key] = _value;
    }

    /////////////////////////
    /// getArray functions
    /////////////////////////
    /// @notice Get functions to get the array of the required data type
    /// Ex1- mapping(address => bytes32[]) tokensOwnedByOwner;
    /// getArrayBytes32(keccak256(abi.encodePacked("tokensOwnedByOwner", 0x1)); It return the bytes32 array
    /// Ex2- uint256 _len =  tokensOwnedByOwner[0x1].length; replace with
    /// getArrayBytes32(keccak256(abi.encodePacked("tokensOwnedByOwner", 0x1)).length;

    function getArrayAddress(bytes32 _key)
        internal
        view
        returns (address[] memory)
    {
        return addressArrayStorage[_key];
    }

    function getArrayBytes32(bytes32 _key)
        internal
        view
        returns (bytes32[] memory)
    {
        return bytes32ArrayStorage[_key];
    }

    function getArrayUint256(bytes32 _key)
        internal
        view
        returns (uint256[] memory)
    {
        return uint256ArrayStorage[_key];
    }

    function getArrayString(bytes32 _key)
        internal
        view
        returns (string[] memory)
    {
        return stringArrayStorage[_key];
    }

    function getArrayBytes(bytes32 _key)
        internal
        view
        returns (bytes[] memory)
    {
        return bytesArrayStorage[_key];
    }

    ///////////////////////////////////
    /// setArrayIndexValue() functions
    ///////////////////////////////////
    /// @notice set the value of particular index of the address array
    /// Ex1- mapping(bytes32 => address[]) moduleList;
    /// general way is -- moduleList[moduleType][index] = temp;
    /// It can be re-write as -- setArrayIndexValue(keccak256(abi.encodePacked('moduleList', moduleType)), index, temp);

    function setArrayIndexValue(
        bytes32 _key,
        uint256 _index,
        address _value
    ) internal {
        addressArrayStorage[_key][_index] = _value;
    }

    function setArrayIndexValue(
        bytes32 _key,
        uint256 _index,
        uint256 _value
    ) internal {
        uint256ArrayStorage[_key][_index] = _value;
    }

    function setArrayIndexValue(
        bytes32 _key,
        uint256 _index,
        int256 _value
    ) internal {
        int256ArrayStorage[_key][_index] = _value;
    }

    function setArrayIndexValue(
        bytes32 _key,
        uint256 _index,
        bytes32 _value
    ) internal {
        bytes32ArrayStorage[_key][_index] = _value;
    }

    function setArrayIndexValue(
        bytes32 _key,
        uint256 _index,
        string memory _value
    ) internal {
        stringArrayStorage[_key][_index] = _value;
    }

    function setArrayIndexValue(
        bytes32 _key,
        uint256 _index,
        bytes memory _value
    ) internal {
        bytesArrayStorage[_key][_index] = _value;
    }

    ///////////////////////////////////
    /// getArrayIndexValue() functions
    ///////////////////////////////////
    /// @notice get the value of particular index of the address array
    /// Ex1- mapping(bytes32 => address[]) moduleList;
    /// general way is -- return moduleList[moduleType][index];
    /// It can be re-write as -- getArrayIndexValue(keccak256(abi.encodePacked('moduleList', moduleType)), index);

    function getArrayAddressIndexValue(bytes32 _key, uint256 _index)
        internal
        view
        returns (address)
    {
        return addressArrayStorage[_key][_index];
    }

    function getArrayUint256IndexValue(bytes32 _key, uint256 _index)
        internal
        view
        returns (uint256)
    {
        return uint256ArrayStorage[_key][_index];
    }

    function getArrayInt256IndexValue(bytes32 _key, uint256 _index)
        internal
        view
        returns (int256)
    {
        return int256ArrayStorage[_key][_index];
    }

    function getArrayBytesIndexValue(bytes32 _key, uint256 _index)
        internal
        view
        returns (bytes memory)
    {
        return bytesArrayStorage[_key][_index];
    }

    function getArrayStringIndexValue(bytes32 _key, uint256 _index)
        internal
        view
        returns (string memory)
    {
        return stringArrayStorage[_key][_index];
    }

    function getArrayBytes32IndexValue(bytes32 _key, uint256 _index)
        internal
        view
        returns (bytes32)
    {
        return bytes32ArrayStorage[_key][_index];
    }
}
