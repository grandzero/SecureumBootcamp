//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Empty {
    // Gas : 67066
}

contract Enum {
    // Gas : 67066
    enum Statuses {
        Pending,
        Confirmed,
        Cancelled
    }
}

contract DefinedEnum {
    // Gas : 67066
    enum Statuses {
        Pending,
        Confirmed,
        Cancelled
    }
    Statuses private status;
}

contract EnumWithOutAssignment {
    // Gas : 67066
    enum Statuses {
        Pending,
        Confirmed,
        Cancelled
    }
    Statuses private status;

    constructor() {}
}

contract EnumAssignment {
    // Tx Gas : 70409
    // Execution Gas : 70409
    enum Statuses {
        Pending,
        Confirmed,
        Cancelled
    }
    Statuses internal _status;

    constructor() {
        _status = Statuses.Confirmed;
    }
}

contract InhertiedAssignmentWOCallingParentConst is EnumAssignment {
    // Tx Gas : 91575
    // Execution Gas : 91575

    Statuses internal _newStatus;

    constructor() {
        _newStatus = _status;
    }
}

contract InhertiedAssignment is EnumAssignment {
    // Tx Gas : 71663
    // Execution Gas : 71663

    Statuses internal _newStatus;

    constructor() EnumAssignment() {
        _newStatus = _status;
    }
}

contract InheritedWithFunction is EnumAssignment {
    // Tx Gas : 118590
    // Execution Gas : 118590

    Statuses internal _newStatus;

    constructor() EnumAssignment() {
        _newStatus = _status;
    }

    function getStatus() external view returns (Statuses) {
        // Execution cost : 23660
        return _newStatus;
    }
}

contract InheritedWithFunctionWOCallingParentConstructor is EnumAssignment {
    // Tx Gas : 138514
    // Execution Gas : 138514

    Statuses internal _newStatus;

    constructor() {
        _newStatus = _status;
        console.log();
    }

    function getStatus() external view returns (Statuses) {
        // Execution cost : 23660
        return _newStatus;
    }
}

contract TraverseInEnums {
    // Tx Gas : 175111
    // Execution Gas : 175111

    enum Statuses {
        Pending,
        Accepted,
        Ongoing,
        Ended
    }

    Statuses private status;

    constructor() {}

    function getStatus() external view returns (Statuses) {
        // Execution cost : 23660
        return status;
    }

    function nextStage() external {
        // Execution cost : 43774
        status = Statuses(uint256(status) + 1);
    }
}

contract EnumAsModifier {
    // Tx Gas : 241844
    // Execution Gas : 241844

    enum Statuses {
        Pending,
        Accepted,
        Ongoing,
        Ended
    }

    Statuses private status;

    constructor() {}

    function nextStage() public {
        status = Statuses(uint256(status) + 1);
    }

    modifier atStage(Statuses _stage) {
        require(status == _stage, "Function cannot be called at this time.");
        _;
    }
    // Go to the next stage after the function is done.
    modifier transitionNext() {
        _;
        nextStage();
    }

    function getStatus() external view returns (Statuses) {
        // Execution cost : 23660
        return status;
    }

    function continueWork()
        external
        atStage(Statuses.Accepted)
        transitionNext
    {}
}

contract EnumAsArgument {
    // Gas: 154285
    enum Stage {
        Pending,
        Accepted,
        Ended
    }
    Stage private currentStage;

    function setStage(Stage _stage) external {
        // Gas: 43732
        currentStage = _stage;
    }

    function getStage() external view returns (Stage) {
        return currentStage;
    }
}

contract UintAsEnum {
    // Gas: 187039
    uint8 val;

    function setStage(uint8 _stage) external {
        // Gas: 44099
        require(val < 3 && val >= 0, "Can not be bigger then 3");
        val = _stage;
    }

    function getStage() external view returns (uint256) {
        return val;
    }
}

/*
    Access another contracts defined enum values
*/
contract EnumOwner {
    enum Stages {
        Pending,
        Accepted,
        Ongoing,
        Completed
    }
    Stages private stage;
}

contract CallsFromEnumOwner {
    EnumOwner private immutable enumowner;

    constructor(EnumOwner addr) {
        enumowner = EnumOwner(addr);
    }

    function getValueFromOwner() external pure returns (EnumOwner.Stages) {
        return EnumOwner.Stages.Accepted;
    }
}
