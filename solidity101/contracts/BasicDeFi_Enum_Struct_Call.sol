// SPDX-License-Identifier: MIT

/*
- In this basic contract, anyone can set their APY and create their own interes rate credits
- Requirements and Business Logic is just like this: 
- Owner deploys contract
- Owner sets selected lending token by giving it to constructor
- Owner deposits certain amount to lend while deploying contract
- Owner can lend all funds to only one person
- Owner can change duration before lending started
- Owner can set requested token amount for total balance
    -- For example: 
    -- Lending Token : USDT
    -- Total Balance Of Contract : 3000 USDT
    -- Interest Amount : 1
    -- Duration : 1 Week
    -- User needs to deposit 1 ETH to Borrow 3000 USDT
    -- If user pays 3000 USDT after 1 week, user can have back 1 ETH
    -- If user doesn't pay 3000 USDT, Owner can withdraw all contract balance
- Owner can accept or reject proposals
    -- If user accepts proposal, State changes to Ongoing, Interest, BeginDate and Duration can't be changed
    -- If user rejects proposal, ETH reverted to proposa owner
- Owner can withdraw money when duration ended
    -- If user pays interest amount, can get back ETH
    -- If not, users all ETH liquditated
*/

pragma solidity ^0.8.0;
// Whichone is best practice? Using Interface or Using Contract?
// Which one is better for gas efficiency? 
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
contract BasicDeFi{

    struct Proposal{
        uint amount;
        address payable  proposalSender;
    }

    
    enum Status{Initial, PendingApproval, Ongoing, Completed}

    Status public creditStatus;
    
    uint256 public beginTime;
    uint256 public duration;
    uint256 public requestedTokenAmount;
    uint256 public expectedAmount;
    address private owner;
    IERC20 private _vestingToken;

    // Immutable added after 0.6.5
    //address immutable private owner;
    //ERC20 immutable private _vestingToken;

    
    Proposal public proposal;

    constructor(IERC20 _tokenAddress, uint256 depositAmount, uint256 _exptectedAmount){
        _vestingToken = _tokenAddress;
        _vestingToken.transferFrom(owner,address(this), depositAmount);
        expectedAmount = _exptectedAmount;
        owner = msg.sender;
    }

    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier detailsSet(){
        require(duration > 0 && requestedTokenAmount > 0);
        _;
    }


    modifier notOngoing(){
        require(creditStatus != Status.Ongoing, "Interest can't be changed while credit Ongoing");
        _;
    }

    modifier lockTimeEnd(){
        require(block.timestamp >= beginTime + duration);
        _;
    }

    function setDuration(uint256 _duration) external onlyOwner notOngoing{
        duration = _duration;
    }

    function setExpectedAmount(uint256 _exptectedAmount) external onlyOwner notOngoing{
        expectedAmount = _exptectedAmount;
    }

    function setBeginTime(uint256 _beginTime) internal onlyOwner notOngoing{
        beginTime = _beginTime;
    }

    function setRequestedTokenAmount(uint256 _amount) internal onlyOwner notOngoing{
        requestedTokenAmount = _amount;
    }


    function proposeCredit() payable external notOngoing notOwner{
        require(msg.value >= expectedAmount, "You can't borrow that much token");
        require(proposal.amount == 0 && proposal.proposalSender == payable(0));
        creditStatus = Status.PendingApproval;
        proposal.amount = msg.value;
        proposal.proposalSender = payable(msg.sender);
    }

    function acceptRejectProposal(bool aR) external onlyOwner notOngoing detailsSet{
        require(proposal.proposalSender != payable(address(0)));
        if(aR){
            creditStatus = Status.Ongoing;
            _vestingToken.transfer(proposal.proposalSender,requestedTokenAmount);
        }else{
            (bool success, ) = proposal.proposalSender.call{value: proposal.amount}("");
            require(success);
            proposal = Proposal(0, payable(0));
        }
    }

    function withdrawOwner() payable external onlyOwner detailsSet lockTimeEnd{
        require(proposal.proposalSender != payable(address(0)));
        uint256 contractBalance = _vestingToken.balanceOf(address(this));
        if(contractBalance == requestedTokenAmount){
            _vestingToken.transfer(owner,contractBalance);
            (bool success, ) = payable(proposal.proposalSender).call{value: address(this).balance}("");
            require(success);
        }else{
            (bool success, ) =payable(owner).call{value: address(this).balance}("");
            require(success);
            proposal = Proposal(0, payable(0));
        }
    }

    function withdrawUser() payable external notOwner detailsSet lockTimeEnd{
        require(msg.sender == proposal.proposalSender);
        require(_vestingToken.allowance(msg.sender, address(this)) >= requestedTokenAmount);
        require(_vestingToken.transferFrom(msg.sender,address(this),requestedTokenAmount));
        (bool success, ) = msg.sender.call{value:address(this).balance}("");
        require(success);
        creditStatus = Status.Initial;
        proposal = Proposal(0, payable(0));
    }

    
    

}