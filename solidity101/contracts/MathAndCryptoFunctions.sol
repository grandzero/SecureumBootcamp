// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract MathAndCryptoFunctions {
    function mymod(
        uint256 x,
        uint256 y,
        uint256 k
    ) public pure returns (uint256) {
        return addmod(x, y, k);
    }

    function mymod2(
        uint256 x,
        uint256 y,
        uint256 k
    ) public pure returns (uint256) {
        return mulmod(x, y, k);
    }

    function myKeccak(string memory val) public pure returns (bytes32) {
        return keccak256(bytes(val));
    }

    function mySHA256(string memory val) public pure returns (bytes32) {
        return sha256(bytes(val));
    }

    function myRipeMd160(string memory val) public pure returns (bytes32) {
        return ripemd160(bytes(val));
    }

    //For the use of this function, it would be good to have a look at the ECDSA.sol library additionally.
    function myEcroCover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public pure returns (address) {
        bytes32 messageDigest = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );
        //For the use of this function, it would be good to have a look at the ECDSA.sol library additionally.
        return ecrecover(messageDigest, v, r, s);
    }
}
/*

 async function signMessage() {
// Create a wallet to sign the message with
let privateKey = '0x0123456789012345678901234567890123456789012345678901234567890123';
let wallet = new ethers.Wallet(privateKey);

    // The hash we wish to sign and verify
    let messageHash = ethers.utils.id("MessageValue");

    // Note: messageHash is a string, that is 66-bytes long, to sign the
    //       binary value, we must convert it to the 32 byte Array that
    //       the string represents
    //
    // i.e.
    //   // 66-byte string
    //   "0x592fa743889fc7f92ac2a37bb1f5ba1daf2a5c84741ca0e0061d243a2e6707ba"
    //
    //   ... vs ...
    //
    //  // 32 entry Uint8Array
    //  [ 89, 47, 167, 67, 136, 159, 199, 249, 42, 194, 163,
    //    123, 177, 245, 186, 29, 175, 42, 92, 132, 116, 28,
    //    160, 224, 6, 29, 36, 58, 46, 103, 7, 186]

    let messageHashBytes = ethers.utils.arrayify(messageHash)

    // Sign the binary data
    //let flatSig = await wallet.signMessage(messageHashBytes);
    //
   const provider = new ethers.providers.Web3Provider(window.ethereum);
   const signer = provider.getSigner();
   let flatSig2 = await signer.signMessage(messageHashBytes);
    //

    // For Solidity, we need the expanded-format of a signature
    let sig = ethers.utils.splitSignature(flatSig2);
    console.log("hash: " + messageHash);
    console.log("R: " + sig.r);
    console.log("S: " + sig.s);
    console.log("V: " + sig.v);
    console.log(wallet);
  }
  */
