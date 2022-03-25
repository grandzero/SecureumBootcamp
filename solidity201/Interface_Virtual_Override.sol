// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract A {

    uint256 number;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) virtual public {
        number = num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }

    function getNum() private virtual view returns(uint256){
        return number;
    }
}

contract B is A {

    function store(uint256 num) override virtual public {
        number = num+140;
    }
}

contract C is B {
    function store(uint256 num) override public {
        number = num+140;
    }
}


 contract F{
    uint256 number;
    function store(uint256 num) virtual public;
}

contract D is F{
     function store(uint256 num) override public {
        number = num+140;
    }
}

contract E is D{
    function store(uint256 num) public {
        number = num+170;
    }
}