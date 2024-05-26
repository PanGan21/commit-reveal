// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { CommitReveal } from "../src/CommitReveal.sol";

contract CommitRevealTest is Test {
    CommitReveal public commitReveal;
    address public creator;
    address public user1;
    address public user2;
    bytes32 public creatorCommitment;
    uint256 public answer;

    function setUp() public {
        creator = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        answer = 42; // Example answer
        creatorCommitment = keccak256(abi.encodePacked(creator, answer));

        commitReveal = new CommitReveal{ value: 1 ether }(creatorCommitment);
    }

    function test_Guess() public {
        vm.prank(user1);
        commitReveal.guess(keccak256(abi.encodePacked(user1, answer)));

        bytes32 commitment = commitReveal.commitments(user1);
        assertEq(commitment, keccak256(abi.encodePacked(user1, answer)));
    }

    function test_Reveal() public {
        vm.prank(user1);
        commitReveal.guess(keccak256(abi.encodePacked(user1, answer)));

        // Move blocks to past guessDeadline
        vm.roll(block.number + commitReveal.GUESS_DURATION_BLOCKS() + 1);

        vm.prank(user1);
        commitReveal.reveal(answer);

        assertTrue(commitReveal.isWinner(user1));
    }

    function test_Claim() public {
        vm.prank(user1);
        commitReveal.guess(keccak256(abi.encodePacked(user1, answer)));

        // Move blocks to past guessDeadline
        vm.roll(block.number + commitReveal.GUESS_DURATION_BLOCKS() + 1);

        vm.prank(user1);
        commitReveal.reveal(answer);

        // Move blocks to past revealDeadline
        vm.roll(block.number + commitReveal.REVEAL_DURATION_BLOCKS() + 1);

        uint256 balanceBefore = user1.balance;

        vm.prank(user1);
        commitReveal.claim();

        uint256 balanceAfter = user1.balance;

        assertTrue(commitReveal.isWinner(user1));
        assertEq(balanceAfter, balanceBefore + 1 ether);
        assertEq(commitReveal.winnersCount(), 1);
    }

    function testFuzz_GuessRevealClaim(uint256 _answer) public {
        bytes32 userCommitment = keccak256(abi.encodePacked(user1, _answer));

        vm.prank(user1);
        commitReveal.guess(userCommitment);

        // Move blocks to past guessDeadline
        vm.roll(block.number + commitReveal.GUESS_DURATION_BLOCKS() + 1);

        // Ensure the guess phase is over before revealing
        if (
            keccak256(abi.encodePacked(user1, _answer)) == userCommitment
                && keccak256(abi.encodePacked(creator, _answer)) == creatorCommitment
        ) {
            vm.prank(user1);
            commitReveal.reveal(_answer);

            // Move blocks to past revealDeadline
            vm.roll(block.number + commitReveal.REVEAL_DURATION_BLOCKS() + 1);

            uint256 balanceBefore = user1.balance;

            vm.prank(user1);
            commitReveal.claim();

            uint256 balanceAfter = user1.balance;
            assertEq(balanceAfter, balanceBefore + 1 ether);
            assertEq(commitReveal.winnersCount(), 1);
        }
    }
}
