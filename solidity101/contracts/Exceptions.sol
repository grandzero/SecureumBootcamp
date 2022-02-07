// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

interface IHelper {
    function bol(uint256 a, uint256 b) external returns (uint256);
}

contract MyPart {
    IHelper Helper;
    uint256 public counter = 0;

    function setContractAddress(address adr) public {
        Helper = IHelper(adr);
    }

    function test(uint256 pay, uint256 payda) public returns (uint256) {
        try Helper.bol(pay, payda) {
            counter++;
        } catch {
            counter--;
        }
        return 0;
    }
}
