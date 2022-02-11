// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract ProxyContractWithCallNoStorage {
    address public proxiedAddress;

    constructor(address _realAddress){
        proxiedAddress = _realAddress;
    }

    fallback() external payable{
        (bool s, ) = proxiedAddress.call(msg.data);
        require(s);
    }

    function returnHex() external pure returns(bytes memory){
        return abi.encodeWithSignature("setTest(uint256)",11);
    }

    function returnHexForSetBoolean() external pure returns(bytes memory){
        return abi.encodeWithSignature("setBoolean()");
    }

    receive() external payable{

    }
}

contract RealContract {
    uint256 public test;
    bool public updated;
    bytes public mData;
    struct SWithCallback{
        uint256 counter;
        bytes callbackFunction;
    }

    SWithCallback public callbackedStruct;

    constructor(){
        callbackedStruct = SWithCallback({
            counter:0,
            callbackFunction: abi.encodeWithSignature("setBoolean()")
        });
    }

    function setTest(uint256 val) external{
        test = val;
    }

    function runCallback() external{
        runWithCall(callbackedStruct.callbackFunction);
    }

    function returnHex() external pure returns(bytes memory){
        bytes4 select = bytes4(keccak256(abi.encodePacked("setTest(uint256)")));
        return abi.encodeWithSelector(select,22);
    }

    function returnWithSelector() pure external returns(bytes memory){
        return abi.encodeWithSelector(this.setTest.selector, 100);
    }

    function setBoolean() external{
        updated = true;
    }

    function runWithCall(bytes memory callback) internal{
        address c = address(this);
        (bool s, ) = c.delegatecall(callback);
        require(s, "require was false");
    }

}


/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Proxy {

    uint256 public number;
    address public proxyAddress;
    function setProxyAddr(address _proxy) external {
        proxyAddress = _proxy;
    }

    function decode(bytes memory _output) external pure returns(bytes memory, uint, bool){
        return abi.decode(_output, (bytes, uint, bool));

    }

    fallback(bytes calldata input) external returns(bytes memory){
        (bool success, bytes memory returnData) = proxyAddress.delegatecall(msg.data);
        require(success);
        return returnData;
    }
}

contract LogicContract{
    uint256 public number; // Storage is same with the proxy

    function changeUint(uint256 _n) external returns(bytes memory, uint, bool){
        number = _n;

        return("Hello World", 100, true);
    }
}

contract ProxyWithLowLevel {

    uint256 public number;
    address public proxyAddress;
    function setProxyAddr(address _proxy) external {
        proxyAddress = _proxy;
    }

    function decode(bytes memory _output) external pure returns(bytes memory, uint, bool){
        return abi.decode(_output, (bytes, uint, bool));

    }

    fallback(bytes calldata input) external returns(bytes memory){
        address localProxy = proxyAddress;
        assembly {
  let ptr := mload(0x40)
   
  // (1) copy incoming call data
  calldatacopy(ptr, 0, calldatasize())

  // (2) forward call to logic contract
  let result := delegatecall(gas(), localProxy, ptr, calldatasize(), 0, 0)
  let size := returndatasize()

  // (3) retrieve return data
  returndatacopy(ptr, 0, size)

  // (4) forward return data back to caller
  switch result
  case 0 { revert(ptr, size) }
  default { return(ptr, size) }
}
    }
}



