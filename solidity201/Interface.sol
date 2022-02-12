// SPDX-License-Identifier: GPL-3.0

// Resources:
// https://github.com/danielrees-eth/secureum-slot3-solidity201/blob/master/00_inheritance.md

pragma solidity >=0.7.0 <0.9.0;



/*
- no functions are implemented
- further restrictions:
- cannot inherit from contract types, but can from interface
- declared functions must be external
- cannot declare a constructor()
- cannot declare state variables

*/
interface IBase{
    function setA(uint256) external;
}

contract BaseContract is IBase{
    uint256 public test;

    function setA(uint256 _a) 
    override // Throws an error, if this keyword is not included !!
    external{
        test=_a;
    }
}

contract C1_Loader{
    IBase public cAddress;
    BaseContract public newBase;

    constructor(address _cAddr){
        cAddress = IBase(_cAddr);
        // IBase created = new IBase(); // Cannot instantiate an interface.
        newBase = new BaseContract(); 
    }   

    function setAOnBase() external{
        cAddress.setA(15);
        newBase.setA(7);
    }

}
// This will fail because interfaces can't inherit actual contracts

// interface Child is BaseContract{

// }

interface Child is IBase{
    function setB(uint256 _val) external;
}

contract C2_Loader{

    Child public shildAddress;

    constructor(address _chAddr) {
        shildAddress = Child(_chAddr);
    }

    function callB() external{
        shildAddress.setA(19); // This wont work below line will revert
        shildAddress.setB(25); // This reverts tx
    }
}


/*
    OOP Best Practice : Always try to write code agains interface rather then object(in our case it's contract) 
*/

contract ChildBase is Child{
    uint256 public test;

    function setA(uint256 _a) 
    override // Throws an error, if this keyword is not included !!
    external{
        test=_a;
    }
    function setB(uint256 _a) 
    override // Throws an error, if this keyword is not included !!
    external{
        test=_a;
    }
}

contract C3_InterfaceCaller{
    IBase public baseInterface;
    Child public childInterface;
    ChildBase public base;
    constructor(address _cAddr){
        baseInterface = IBase(_cAddr);
        childInterface = Child(_cAddr);
        base = new ChildBase();
    }

    function callFromBaseI(IBase addr) public{
        // Gas: 27653
        addr.setA(2);
    }

    function callFromChild(Child addr) public{
        // Gas: 30432
        addr.setA(3);
    }

    function callFromContract(ChildBase addr) public{
        // Gas: 30388
        addr.setA(4);
    }

    function callFunction() external {
        // Gas: 51356
        callFromBaseI(base);
        callFromChild(base);
        callFromContract(base);
    }
}
