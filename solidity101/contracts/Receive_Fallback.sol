// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
// https://medium.com/coinmonks/delegatecall-calling-another-contract-function-in-solidity-b579f804178c
// https://medium.com/coinmonks/upgradeable-proxy-contract-from-scratch-3e5f7ad0b741
// https://docs.soliditylang.org/en/v0.6.2/contracts.html#receive-ether-function
// https://medium.com/remix-ide/low-level-interactions-on-remix-ide-5f79b05ac86
// https://solidity-by-example.org/delegatecall/
// https://solidity-by-example.org/call/
// https://ethereum.stackexchange.com/questions/3667/difference-between-call-callcode-and-delegatecall
// https://www.blocksism.com/solidity-delegatecall-call-library/
// https://solidity-by-example.org/delegatecall/
// https://fravoll.github.io/solidity-patterns/proxy_delegate.html

contract EmptyReference {

}

// Simple Usage
contract C1_SimpleReceive{
    receive() payable external{
    }
    function getBalance() external returns(uint256){
        return address(this).balance;
    }
}

// Inheritance
contract C2_1_ParentReceive{
    receive() payable external{

    }
    function getBalance() external returns(uint256){
        return address(this).balance;
    }
}

contract C2_2_ChildReceive is C2_1_ParentReceive{

}

// Gas Usage
contract C3_1_ReceiveGasUsage{
     receive() payable external{
         // Gas : 379087
         uint256 i;
         for(i = 0; i<2000; i++){}
    }
    function getBalance() external returns(uint256){
        return address(this).balance;
    }
}

contract C3_2_ReceiveGasUsage{
     receive() payable external{
         // Gas : 737087
         uint256 i;
         for(i = 0; i<4000; i++){}
    }
    function getBalance() external returns(uint256){
        return address(this).balance;
    }
}

contract C4_FallbackSimple{
    bytes public input;
    function getHex() external returns(bytes memory){
        return abi.encodeWithSignature("test(uint256)",100);
    }

    fallback(bytes calldata _input) external returns(bytes memory _output){
        input = _input;
        return _input;
    }

}

contract C5_FallbackPayable{
    bytes public input;

    function getHex() external returns(bytes memory){
        return abi.encodeWithSignature("test(uint256)",100);
    }

    function getBalance() external returns(uint256){
        return address(this).balance;
    }

    fallback(bytes calldata _input) external payable returns(bytes memory _output){
        input = _input;
        return _input;
    }

}

contract C6_1_FallbackGasUsage{
    fallback(bytes calldata _input) external payable returns(bytes memory _output){
        // Gas : 110583
        uint256 i;
        for(i = 0; i<500; i++){}
    } 
}

contract C6_2_FallbackGasUsage{
    fallback(bytes calldata _input) external payable returns(bytes memory _output){
        // Gas : 200083
        uint256 i;
        for(i = 0; i<1000; i++){}
    } 
}

contract C7_Receive_And_FallBack{

}

contract ProxyContract {
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



// NOTE: Deploy this contract first
contract D {
    // NOTE: storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;
    bool public booleanValue;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }

    function setBoolean(bool _val) internal{
        booleanValue = _val;
    }
}

contract E {
    uint public num;
    address public sender;
    uint public value;
    bool public booleanValue;
    
    function setVars2(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setBoolean(bool)", true)
        );
    }
}