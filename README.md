# Casinc Smart Contract

Casinc is a decentralized casino game smart contract designed to ensure fairness, transparency, and robust security for users and administrators. This contract is built on Solidity, deployed and tested using Foundry, and leverages advanced Web3 principles to enhance the security and functionality of the payment system.

---

## Key Features

### **1. Core Game Logic**
- Users can:
  - Deposit Ether into their account.
  - Place bets on a casino game with configurable parameters such as bet limits and multipliers.
  - Withdraw winnings securely after a configurable delay.
- Random game outcomes are determined using a basic pseudorandom mechanism (to be enhanced for production).

### **2. Security Enhancements**
- **Time-Locked Withdrawals**: Ensures that users can only withdraw winnings after a 1-day delay, providing time to detect and act on potential suspicious activities.
- **Admin Approval**: Administrators can approve or decline large withdrawal requests, protecting the contract's funds.
- **Checks-Effects-Interactions**: Proper sequence ensures resistance to reentrancy attacks.
- **Blocked Users**: Admins can block/unblock users to prevent malicious activity.

### **3. Configurable Parameters**
- Admins can dynamically update game parameters, such as:
  - Minimum and maximum bet limits.
  - Maximum multiplier for winnings.

### **4. Pausable Contract**
- The contract is pausable by the admin, ensuring emergency stops for unforeseen situations.

### **5. 10-Second Game Interval**
- Users can only play once every 10 seconds to ensure fairness and reduce system overload.

---

## Tech Stack

### **Smart Contract**
- Language: **Solidity (v0.8.0)**
- Framework: **Foundry** for deployment and testing
- Libraries:
  - **OpenZeppelin**: Utilized for `Pausable` functionality to manage the contract's state securely.

### **Testing and Deployment**
- Developed and tested using:
  - **Foundry**: Fast and modular testing and deployment framework for Solidity.
  - Custom test cases to verify core functionalities and edge cases.
- Deployment: Configured for seamless deployment to any EVM-compatible blockchain.

---

## Installation and Setup

### Prerequisites
1. **Foundry**: Install Foundry by following the [Foundry Installation Guide](https://book.getfoundry.sh/getting-started/installation.html).
2. **Node.js**: Ensure you have Node.js installed for additional tooling (e.g., Hardhat for testing if needed).

### Installation
Clone the repository:
```bash
$ git clone https://github.com/your-github-username/casinc-smart-contract.git
$ cd casinc-smart-contract
```

Install dependencies:
```bash
$ forge install
```

### Compilation
Compile the contract using Foundry:
```bash
$ forge build
```

### Testing
Run the test suite:
```bash
$ forge test
```

---

## Smart Contract Overview

### **Game Parameters**
- `minBet`: Minimum allowable bet (default: 0.01 Ether).
- `maxBet`: Maximum allowable bet (default: 1 Ether).
- `multiplierLimit`: Maximum multiplier allowed for winnings (default: 10).

### **User Flow**
1. **Deposit Funds:**
   - Users deposit Ether into the contract using the `createDeposit()` function.

2. **Play Game:**
   - Users place bets via `playGame(bet, multiplier)` with the configured bet limits and multipliers.
   - The game enforces a 10-second cooldown between plays.

3. **Initiate Withdrawal:**
   - Users can request their winnings withdrawal via `initiateWithdrawal()`. The request is queued with a 1-day delay.

4. **Admin Approval:**
   - Admins approve or decline high-value withdrawal requests via `decideWithdrawalRequest()`.

5. **Execute Withdrawal:**
   - Approved withdrawals are executed after the delay using `executeWithdrawal()`.

---

## Security Features

1. **Reentrancy Protection:**
   - Ensures no reentrancy vulnerabilities via proper state updates before external interactions.

2. **Blocked Users:**
   - Admins can block or unblock users, restricting malicious actors.

3. **Pausable Contract:**
   - Admins can pause or unpause the contract during emergencies.

4. **Time-Locked Withdrawals:**
   - Prevents immediate large withdrawals and allows admin intervention if necessary.

5. **10-Second Game Interval:**
   - Prevents spam or excessive betting by enforcing a cooldown.

---

## Project Highlights
This project showcases:
- Advanced smart contract design principles.
- A secure and efficient payment system for Web3 gaming applications.
- Professional use of Foundry for development and testing.

---

## Future Improvements
1. **Enhanced Randomness:** Integrate Chainlink VRF for provably fair random number generation.
2. **Frontend Integration:** Build a React.js frontend to allow users to interact with the smart contract seamlessly.
3. **Multisig Wallet Integration:** Add Gnosis Safe or a similar solution for multi-admin withdrawal approvals.

---

## License
This project is licensed under the MIT License.

---

## Contact
For any inquiries, feel free to reach out:
- **Email:** your-email@example.com
- **GitHub:** [your-github-username](https://github.com/your-github-username)

---

## Acknowledgments
Special thanks to OpenZeppelin and Foundry for their amazing tools and frameworks that made this project possible.

