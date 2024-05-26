// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Script, console2 } from "forge-std/Script.sol";
import { CommitReveal } from "src/CommitReveal.sol";

contract Deployer is Script {
    function run() public {
        vm.startBroadcast();
        deploy();
        vm.stopBroadcast();
    }

    function deploy() public returns (CommitReveal) {
        address creator = msg.sender;
        uint256 answer = 42; // Example answer
        bytes32 creatorCommitment = keccak256(abi.encodePacked(creator, answer));

        // Deploy the contract with the initial commitment and send 1 ether
        CommitReveal commitReveal = new CommitReveal{ value: 1 ether }(creatorCommitment);
        return commitReveal;
    }
}
