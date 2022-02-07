// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract ErrorHandling {
    uint256 public counter;

    function updateCounter(uint256 age) public {
        counter += 1;
        assert(age > 18);
    }

    function updateCounterV2(uint256 age) public {
        counter++;
        require(age > 18);
    }

    function updateCounterV3(uint256 age) public {
        counter++;
        require(age > 18, "you must be over 18");
    }

    function updateCounterV4(uint256 age) public {
        counter++;
        if (age < 18) revert();
    }

    function updateCounterV5(uint256 age) public {
        counter++;
        if (age < 18) revert("you must be over 18");
    }
}
