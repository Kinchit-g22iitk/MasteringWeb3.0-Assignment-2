// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Election {

    struct Candidate {
        string name;
        uint votecount;
    }

    struct Voter {
        uint age;
        address id;
        bool voted;
    }

    Candidate[] public candidates;
    mapping(address => Voter) public voters;

    event voterVerified(address voter);
    event voteCast(address voter, string candidate);

    constructor(string[] memory candidateNames) {
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({name: candidateNames[i], votecount: 0}));
        }
    }

    function getCandidates() external view returns (string[] memory, uint[] memory) {
        string[] memory names = new string[](candidates.length);
        uint[] memory votecounts = new uint[](candidates.length);

        for (uint i = 0; i < candidates.length; i++) {
            names[i] = candidates[i].name;
            votecounts[i] = candidates[i].votecount;
        }

        return (names, votecounts);
    }

    function verifyVoter(uint age) external returns (string memory) {
        require(voters[msg.sender].id == address(0), "Voter already verified");

        if (age >= 18) {
            voters[msg.sender] = Voter(age, msg.sender, false);
            emit voterVerified(msg.sender); 
            return "You are eligible to vote.";
        } else {
            return "You are not eligible to vote.";
        }
    }

    function vote(uint candidateIndex) external returns (string memory) {
        require(voters[msg.sender].age >= 18, "You are not eligible to vote");
        require(!voters[msg.sender].voted, "You have already voted");
        require(candidateIndex < candidates.length, "Invalid candidate index");

        voters[msg.sender].voted = true;
        candidates[candidateIndex].votecount += 1;

        emit voteCast(msg.sender, candidates[candidateIndex].name); 

        return "Vote cast successfully.";
    }

    function getWinner() external view returns (string memory) {
        require(candidates.length > 0, "No candidates available");

        uint winningVoteCount = 0;
        uint winningCandidateIndex = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].votecount > winningVoteCount) {
                winningVoteCount = candidates[i].votecount;
                winningCandidateIndex = i;
            }
        }

        return candidates[winningCandidateIndex].name;
    }
}
