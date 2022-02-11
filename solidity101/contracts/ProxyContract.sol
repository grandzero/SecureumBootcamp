// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// Nice To Follow : 
// https://blog.openzeppelin.com/ethereum-in-depth-part-2-6339cf6bddb9/
// https://blog.openzeppelin.com/proxy-patterns/
// https://blog.openzeppelin.com/the-transparent-proxy-pattern/
// https://www.youtube.com/watch?v=YpEm9Ki0qLE
// https://www.youtube.com/watch?v=bdXJmWajZRY
// https://www.youtube.com/watch?v=zUtnYtxjOrc



/**
    This contract help us call another contract with only metadata
    But what about storage?
 */
contract ProxyContractWithCallNoStorage {
    address public proxiedAddress;

    constructor(address _realAddress){
        proxiedAddress = _realAddress;
    }

    fallback() external payable{

        // With the code block we are able to call any contract just using same abi
        // All we need is update proxy address
        // But problem here is the storage
        // When we change the address of pointing contract, we can't access old datas anymore
        // All datas are lost now
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

/**
This contract is the main logic contract
We store main logic and storage here
 */
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
 * @title Proxy contract
 * @dev Calls functions from other contract while keeping storage same
 * By using delegate call, we managed to solve the issue with the top and 
 * Now we are not losing storage data while we can still change the logic
 * delegatecall let's us use any contracts functions like libraries
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
        address localProxy = proxyAddress; // in assembly we can only call local variables
        assembly {
  let ptr := mload(0x40) // Get the pointer which points to address 0x40 (EVM provides this address and ensures this address is available)
   
  // (1) copy incoming call data
  // Calldatasize function simply gives the size of msg.data
  // calldata copy takes 3 argument and (t, f, s): it will copy s bytes of calldata at position f into memory at position t. In addition, Solidity lets you access to the calldata through msg.data
  calldatacopy(ptr, 0, calldatasize()) 

  // (2) forward call to logic contract
  // Running delegate call
  let result := delegatecall(gas(), localProxy, ptr, calldatasize(), 0, 0)
  // Return data size
  let size := returndatasize()

  // (3) retrieve return data
  // Copy return data
  returndatacopy(ptr, 0, size)

  // (4) forward return data back to caller
  // If there is result return else revert
  switch result
  case 0 { revert(ptr, size) }
  default { return(ptr, size) }
}
    }
}



