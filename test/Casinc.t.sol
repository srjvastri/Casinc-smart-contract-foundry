// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import "lib/forge-std/src/Test.sol";
import "../src/Casinc.sol";

contract CasincTest is Test {
    Casinc casino;
    address admin = address(0x123);
    address user = address(0x456);

    function setUp() public {
        casino = new Casinc(admin);
        vm.deal(user, 10 ether); // Fund the user with 10 ether
    }

    function testCreateDeposit() public {
        vm.prank(user);
        casino.createDeposit{value: 1 ether}();
        uint256 deposit = casino.deposits(user);
        assertEq(deposit, 1 ether, "Deposit should be 1 ether");
    }

    function testPlayGame() public {
        vm.prank(user);
        casino.createDeposit{value: 1 ether}();

        vm.prank(user);
        casino.playGame(0.5 ether, 2);

        uint256 deposit = casino.deposits(user);
        assertEq(deposit, 0.5 ether, "Deposit should be 0.5 ether after playing the game with 0.5 ether bet");
    }

    function testPlayGameInsufficientBalance() public {
        vm.prank(user);
        casino.createDeposit{value: 0.1 ether}();

        vm.prank(user);
        vm.expectRevert("Insufficient balance");
        casino.playGame(0.5 ether, 2);
    }

    function testPlayGameBelowMinBet() public {
        vm.prank(user);
        casino.createDeposit{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert("Bet is below the minimum limit");
        casino.playGame(0.001 ether, 2);
    }

    function testPlayGameAboveMaxBet() public {
        vm.prank(user);
        casino.createDeposit{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert("Bet exceeds the maximum limit");
        casino.playGame(2 ether, 2);
    }

    function testPlayGameAboveMultiplierLimit() public {
        vm.prank(user);
        casino.createDeposit{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert("Multiplier exceeds the limit");
        casino.playGame(0.5 ether, 20);
    }
}