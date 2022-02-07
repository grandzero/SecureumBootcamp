// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
contract EncodeAndDecode{
    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function encode(string calldata b) external view returns(bytes memory)
    {
        return abi.encode(b,"istanbul","ankara","izmir",msg.sender);
    }
    //decode işlevi yoktur
    function encodePacked(string calldata b) external view returns(bytes memory)
    {
        return abi.encodePacked(b,"istanbul","ankara","izmir",msg.sender);
    }

     function encodeWithSelector(string calldata b) external view returns(bytes memory)
    {
        return abi.encodeWithSelector(bytes4("abcd"),b,"istanbul","ankara","izmir",msg.sender);
    }

    //abi.encodeWithSignature(string memory signature, ...)
    function encodeWithSignature(string calldata b) external view returns(bytes memory)
    {
        return abi.encodeWithSignature("imza",b,"1","2","3",msg.sender);
    }

    //abi.encodeWithSelector(bytes4(keccack256(bytes(signature))), ...)
     function encodeWithSignatureV2(string calldata b) external view returns(bytes memory)
    {
        return abi.encodeWithSelector(bytes4(keccak256(bytes("imza"))),b,"1","2","3",msg.sender);
    }
    function decode(bytes calldata a) external pure returns(string memory,string memory,string memory,string memory,address)
    {
        return abi.decode(a,(string,string,string,string,address));
    }
}