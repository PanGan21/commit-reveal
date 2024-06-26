// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CommitReveal {
    uint256 public constant GUESS_DURATION_BLOCKS = 5; // 3 days
    uint256 public constant REVEAL_DURATION_BLOCKS = 5; // 1 day
    address public creator;
    uint256 public guessDeadline;
    uint256 public revealDeadline;
    uint256 public totalPrize;
    uint256 public winnersCount;
    mapping(address => bytes32) public commitments;
    mapping(address => bool) public winners;
    mapping(address => bool) public claimed;

    constructor(bytes32 _commitment) payable {
        creator = msg.sender;
        commitments[creator] = _commitment;
        guessDeadline = block.number + GUESS_DURATION_BLOCKS;
        revealDeadline = guessDeadline + REVEAL_DURATION_BLOCKS;
        totalPrize += msg.value;
        winnersCount = 0;
    }

    function createCommitment(address user, uint256 answer) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(user, answer));
    }

    function guess(bytes32 _commitment) public {
        require(block.number < guessDeadline);
        require(msg.sender != creator);

        commitments[msg.sender] = _commitment;
    }

    function reveal(uint256 answer) public {
        require(block.number > guessDeadline);
        require(block.number < revealDeadline);
        require(createCommitment(msg.sender, answer) == commitments[msg.sender]);
        require(createCommitment(creator, answer) == commitments[creator]);
        require(!isWinner(msg.sender));

        winners[msg.sender] = true;
        winnersCount += 1;
    }

    function claim() public {
        require(block.number > revealDeadline);
        require(claimed[msg.sender] == false);
        require(isWinner(msg.sender));

        uint256 payout = totalPrize / winnersCount;
        claimed[msg.sender] = true;
        (bool success,) = payable(msg.sender).call{ value: payout }("");

        require(success, "Transfer failed");
    }

    function isWinner(address user) public view returns (bool) {
        return winners[user];
    }

    receive() external payable {
        totalPrize += msg.value;
    }
}
