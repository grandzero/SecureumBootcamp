// SPDX-License-Identifier: MIT

/*
- In this basic contract, anyone can set their APY and create their own interes rate credits
- Requirements and Business Logic is just like this: 
- Owner deploys contract
- Owner sets selected lending token 
- Owner deposits certain amount to lend 
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
    -- If user rejects proposal, ETH reverted to proposal owner
- Owner can withdraw money when duration ended
    -- If user pays interest amount, can get back ETH
    -- If not, users all ETH liquditated
*/

pragma solidity ^0.8.0;
// Whichone is best practice? Using Interface or Using Contract?
// Which one is better for gas efficiency? 
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract BasicDeFi is ReentrancyGuard{

    struct Proposal{
        uint256 amount;
        address payable  proposalSender;
    }

    
    enum Status{Initial, PendingApproval, Ongoing, Completed}

    Status public creditStatus;
    
    uint256 public beginTime; // When lending begin
    uint256 public duration; // Duration for fund to return
    //uint256 public requestedTokenAmount; // 
    uint256 public expectedAmount; // Expected eth in wei for deposited amount
    address private owner;
    IERC20 private _vestingToken;

    // Immutable added after 0.6.5
    //address immutable private owner;
    //ERC20 immutable private _vestingToken;

    
    Proposal public proposal;

    constructor(IERC20 _tokenAddress){
        _vestingToken = _tokenAddress;
        owner = msg.sender;
    }

    function depositToken(uint256 amount, uint256 _exptectedAmount) external onlyOwner{
        require(_vestingToken != IERC20(address(0)),"Select a token");
        require(_vestingToken.allowance(msg.sender,address(this)) >= amount, "Not enough fund approved");
        _vestingToken.transferFrom(owner,address(this), amount);
        expectedAmount = _exptectedAmount;
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
        require(duration > 0 && expectedAmount > 0);
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



    function proposeCredit() payable external notOngoing notOwner{
        require(msg.value >= expectedAmount, "You can't borrow that much token");
        require(proposal.amount == 0 && proposal.proposalSender == payable(0), "There is already a funder and ongoing fund");
        creditStatus = Status.PendingApproval;
        proposal.amount = msg.value;
        proposal.proposalSender = payable(msg.sender);
    }

    function acceptRejectProposal(bool aR) external onlyOwner notOngoing detailsSet nonReentrant {
        require(proposal.proposalSender != payable(address(0)));
        if(aR){
            creditStatus = Status.Ongoing;
            beginTime = block.timestamp;
            _vestingToken.transfer(proposal.proposalSender,expectedAmount);
            
        }else{
            proposal = Proposal(0, payable(0));
            (bool success, ) = proposal.proposalSender.call{value: proposal.amount}("");
            require(success);
            
        }
    }

    function withdrawOwner() payable external onlyOwner detailsSet lockTimeEnd nonReentrant{
        require(proposal.proposalSender != payable(address(0)));
        uint256 contractBalance = _vestingToken.balanceOf(address(this));
        if(contractBalance == expectedAmount){
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
        require(_vestingToken.allowance(msg.sender, address(this)) >= expectedAmount);
        creditStatus = Status.Initial;
        proposal = Proposal(0, payable(0));
        require(_vestingToken.transferFrom(msg.sender,address(this),expectedAmount));
        (bool success, ) = msg.sender.call{value:address(this).balance}("");
        require(success);
        
    }

    
    

}