// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

contract AddressSet {
    error IndexInvalid(uint256 index);

    event AddressAdded(address element);

    uint256 private _elementCount;

    mapping(uint256 => address) private _elementMap;

    mapping(address => uint256) private _elementPresent;

    constructor() {
        _elementCount = 0;
    }

    modifier requireValidIndex(uint256 index) {
        if (index == 0 || index > _elementCount) revert IndexInvalid(index);
        _;
    }

    function add(address _element) external returns (uint256) {
        uint256 elementIndex = ++_elementCount;
        _elementMap[elementIndex] = _element;
        _elementPresent[_element] = elementIndex;
        emit AddressAdded(_element);
        return elementIndex;
    }

    function erase(address _element) external returns (bool) {
        uint256 elementIndex = _elementPresent[_element];
        if (elementIndex > 0) {
            _elementMap[elementIndex] = address(0x0);
            _elementPresent[_element] = 0;
            delete _elementMap[elementIndex];
            delete _elementPresent[_element];
            return true;
        }
        return false;
    }

    function size() external view returns (uint256) {
        return _elementCount;
    }

    function get(uint256 index) external view requireValidIndex(index) returns (address) {
        return _elementMap[index];
    }

    function contains(address element) external view returns (bool) {
        return _elementPresent[element] > 0;
    }
}
