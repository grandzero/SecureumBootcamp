// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

contract EmptyAsReference{
    // 67066
}

// Call constructor from outside
contract C1_BasicConstructor {
    uint256 public stateVar;
    constructor(uint256 _newState) {
        stateVar = _newState;
    }
}
// Call constructor from inside
contract C2_CallConstructorFromSC {
    C1_BasicConstructor public newContract;
    constructor(uint256 _newState) {
        newContract = new C1_BasicConstructor(_newState);
    }
}

// Call parent constructor
contract C3_1_ParentConstructor{
    uint256 public parentValue;

    constructor(uint256 _parentValue){
        parentValue = _parentValue;
    }
}
contract C3_2_ChildConstructor is C3_1_ParentConstructor(11){
    uint256 public childState;
    constructor(uint256 childValue){
        childState = childValue;
    }
}

// Call parent's parent's contructor
contract C4_1_ParentConstructor{
    uint256 public parentVa;

    constructor(uint256 _parentValue){
        parentVa = _parentValue;
    }
}
contract C4_2_ChildConstructor is C4_1_ParentConstructor(11){
    uint256 public childState;
    constructor(uint256 childValue){
        childState = childValue;
    }
}
contract C4_3_GrandChildConstructor is C4_2_ChildConstructor(9){  // We can't add more then one here
    uint256 public grandChildState;
    constructor(uint256 gcValue){
        grandChildState = gcValue;
    }
}

// Call constructor after deploy
contract C5_CallConstructorAfterDeploy {
    uint256 public localState;
    constructor(uint256 _newState){
        localState = _newState;
    }

    function callConstAgain() external{
        //constructor(17);
    }
}
// Call parents constructor with current constructors argument
contract C6_1_ParentConstructor{
    uint256 public parentVal;

    constructor(uint256 _parentValue){
        parentVal = _parentValue;
    }
}
contract C6_2_ChildConstructor is C6_1_ParentConstructor{
    uint256 public childState;
    constructor(uint256 childValue) C6_1_ParentConstructor(17){
        childState = childValue;
    }
}
contract C6_3_GrandChildConstructor is C6_2_ChildConstructor{  // We can't add more then one here
    uint256 public grandChildState;
    constructor(uint256 gcValue) C6_2_ChildConstructor(60){
        grandChildState = gcValue;
    }
}

contract C6_4_MultipleInhertance is C4_1_ParentConstructor, C3_1_ParentConstructor, C6_1_ParentConstructor{
    uint256 public grandChildState;
    constructor(uint256 gcValue) C4_1_ParentConstructor(1) C3_1_ParentConstructor(2) C6_1_ParentConstructor(gcValue) {
        grandChildState = gcValue;
    }
}

// Create internal constructor
    // Will be added after polymorphism lessons

// Create payable constructor
contract C7_PayableConstructor{
    constructor() payable{

    }

    function getBalance() external view returns(uint256){
        return address(this).balance;
    }
}
// See if Parent constructor is payable, makes current payable?
contract C8_PayableParent is C7_PayableConstructor{
    constructor() C7_PayableConstructor(){ // Doesn't make child constructor payable

    }
}


