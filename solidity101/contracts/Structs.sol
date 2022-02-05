// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


// https://docs.soliditylang.org/en/v0.8.8/internals/layout_in_storage.html
// https://dev.to/javier123454321/solidity-gas-optimizations-pt-3-packing-structs-23f4
// https://kubertu.com/blog/solidity-storage-in-depth/
// https://jeancvllr.medium.com/solidity-tutorial-all-about-structs-b3e7ca398b1e


contract emptyAsReference{
    // 67066
}

contract C1_OneElementStruct{
    // Gas 67066
    struct Person{
        uint8 age;
    }
}

contract C2_TwoElementStruct{
    // Gas 67042
    struct Person{
        uint8 age;
        uint16 salary;
    }

}

contract C3_StructGeneration {
    // Gas 67054
    struct Person{
        uint8 age;
        uint16 salary;
    }

    Person private person;
}

contract C4_1_SlotLogicInStruct{
    // Gas : 136875
    struct Person{
        uint128 age;
        uint256 salary;
        uint128 weight;
    }

    Person private person = Person(10,10000,50);
}


contract C4_2_SlotLogicInStruct{
    // Gas : 115037
    struct Person{
        uint256 age;
        uint128 weight;
        uint128 salary;
    }

    Person private person  = Person(10,10000,50);
}

contract C5_StructWithConstructor{
    // Gas : 194532
    struct Person{
        uint128 age;
        uint256 salary;
        uint128 weight;
    }

    Person public person;
    constructor(){
        Person storage p = person;
        p.age = 30;
        p.salary = 10000;
        p.weight = 100;
    }
}

contract C6_CreateStructJsonSyntax{
    // Gas: 152032

    struct Person{
        uint8 age;
        uint8 weight;
        uint128 salary;
    }

    Person public person;
    constructor(){
        person = Person({
            age:25,
            weight: 80,
            salary: 12000
        });
    }
}

contract C7_CreateStructFuncSyntax{
    // Gas: 152032

    struct Person{
        uint8 age;
        uint8 weight;
        uint128 salary;
    }

    Person public person;
    constructor(){
        person = Person(25,80,12000);
    }
}

contract C8_1_NewSlotStruct{
    struct Person{
        uint128 age;
    }
    // Gas : 220110
    uint128 first = 10;
    Person public person = Person(10);
    uint128 second = 20;
}

contract C8_2_NewSlotStruct{

    struct Person{
        uint128 age;
    }
    // Gas: 198248
    uint128 first = 10;
    uint128 second = 20;
    Person public person = Person(10);
    
}

contract C8_3_NewSlotStruct{

    struct Person{
        uint256 age;
    }
    // Gas: 140270
    uint128 first = 10;
    uint128 second = 20;
    Person public person = Person(10);
    
}

contract C8_4_Reference_NewSlotStruct{
    // Gas: 114417
    uint128 first = 10;
    uint128 second = 20;
    uint128 third = 10;
}

contract C9_1_ReadWriteStruct{
    // Gas : 275995
    struct Person{
        uint128 age;
        uint128 weight;
    }

    Person public person = Person(10,20);
    uint256 test = 10;
    uint128 test2 = 20;

    function writeToStruct() external{
        // Gas: 26681
        person = Person(30,40);
    }

    function writeToUint256() external{
        // Gas : 26266
        test = 30;
    }

    function writeToUint128() external{
        // Gas : 26297
        test2 = 40;
    }

    function writeBothUint256128() external{
        // Gas: 31289
        test=30;
        test2=40;
    }

}

contract C9_2_ReadWriteStruct{
    // Gas : 296411
    struct Person{
        uint128 age;
        uint128 weight;
    }

    Person public person = Person(10,20);
    uint256 test = 10;
    uint128 test2 = 20;
    uint128 test3 = 60;

    function writeToStruct() external{
        // Gas: 26681
        person = Person(30,40);
    }

    function writeToUint256() external{
        // Gas : 26266
        test = 30;
    }

    function writeToUint128() external{
        // Gas_Old : 26297
        // Gas_New : 26319
        test2 = 40;
    }

    function writeBothUint256128() external{
        // Gas_Old: 31289
        // Gas_New: 25711
        test=30;
        test2=40;
    }

    function writeBothUint128() external{
        // Gas_Old: 31289
        // Gas_New: 25755
        test=30;
        test2=40;
    }

}

