
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Pausable.sol";

contract Casinc is Pausable {
    address public admin;
    uint256 public unclaimedWithdrawalAmount;
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public winnings;
    mapping(address => bool) public blockedUsers;
    mapping(address => PendingWithdrawal) public pendingWithdrawals;

    struct GameParameters {
        uint256 minBet;
        uint256 maxBet;
        uint256 multiplierLimit;
    }

    struct PendingWithdrawal {
    uint256 amount;
    uint256 unlockTime;
    bool approved;
    bool declined;
    }

    GameParameters public gameParameters;

    event DepositCreated(address indexed user, uint256 amount);
    event GamePlayed(address indexed user, uint256 bet, uint256 winnings);
    event WithdrawalRequested(address indexed user, uint256 amount);
    event WithdrawalExecuted(address indexed user, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor(address _admin) {
        admin = _admin;
        gameParameters = GameParameters({minBet: 0.01 ether, maxBet: 1 ether, multiplierLimit: 10});

    }

    function createDeposit() external payable whenNotPaused{
        require(msg.value > 0, "Deposit must be greater than zero");
        deposits[msg.sender] += msg.value;
        emit DepositCreated(msg.sender, msg.value);
    }

    function playGame(uint256 bet, uint256 multiplier) external whenNotPaused{
        require(bet >= gameParameters.minBet, "Bet is below the minimum limit");
        require(bet <= gameParameters.maxBet, "Bet exceeds the maximum limit");
        require(multiplier <= gameParameters.multiplierLimit, "Multiplier exceeds the limit");
        require(deposits[msg.sender] >= bet, "Insufficient balance");

        // Deduct the bet amount
        deposits[msg.sender] -= bet;

        // Simulate the game logic (e.g., a simple random win/loss)
        bool won = (block.timestamp % 2 == 0); // Replace with better randomization
        uint256 winningsAmount = 0;
        if (won) {
            winningsAmount = bet * multiplier;
            winnings[msg.sender] += winningsAmount;
        }

        emit GamePlayed(msg.sender, bet, winningsAmount);
    }

    function initiateWithdrawal() external  whenNotPaused{
        uint256 amount = winnings[msg.sender];
        require(amount > 0, "No winnings available to withdraw");
        winnings[msg.sender] = 0;
        PendingWithdrawal storage pendingWithdrawal = pendingWithdrawals[msg.sender];
        pendingWithdrawal.amount += amount;
        pendingWithdrawal.unlockTime = block.timestamp + 1 days;
        emit WithdrawalRequested(msg.sender, amount);
    }

    function decideWithdrawalRequest(address user, bool approved) external onlyAdmin {
        PendingWithdrawal storage pendingWithdrawal = pendingWithdrawals[user];
        require(pendingWithdrawal.approved || pendingWithdrawal.declined, "Admin already decided on this withdrawal");
        if(!approved){
            pendingWithdrawal.declined = true;
            return;
        }
        uint256 amount = pendingWithdrawal.amount;
        unclaimedWithdrawalAmount += amount; // Track the total unclaimed withdrawal amount
        require(address(this).balance >= unclaimedWithdrawalAmount, "Insufficient contract balance");
        pendingWithdrawal.approved = approved;
    }

    function executeWithdrawal() external whenNotPaused{
        PendingWithdrawal memory pendingWithdrawal = pendingWithdrawals[msg.sender];
        require(pendingWithdrawal.approved, "Withdrawal not approved");
        require(pendingWithdrawal.unlockTime <= block.timestamp, "Withdrawal is still locked");
        uint256 amount = pendingWithdrawal.amount;
        unclaimedWithdrawalAmount -= amount;
        delete pendingWithdrawals[msg.sender];
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Failed to send Ether");
        emit WithdrawalExecuted(msg.sender, amount);
    }

    function pause() external onlyAdmin {
        _pause();
    }

    function unpause() external onlyAdmin {
        _unpause();
    }
}


