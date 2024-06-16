// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Election {
    address public owner;
    uint public candidateCount;
    uint public voterCount;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        address id;
        string name;
        uint age;
        bool isRegistered;
        bool hasVoted;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;

    event CandidateAdded(uint indexed candidateID, string name);
    event VoterRegistered(address indexed voterAddress, string name, uint age, bool eligible);
    event VoteCast(address indexed voter, uint indexed candidateID);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier isEligible(uint age) {
        require(age >= 18, "You are not eligible to vote");
        _;
    }

    modifier isRegisteredVoter() {
        require(voters[msg.sender].isRegistered, "You are not a registered voter");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        emit CandidateAdded(candidateCount, _name);
    }

    function registerVoter(string memory _name, uint _age) public isEligible(_age) {
        require(!voters[msg.sender].isRegistered, "You are already registered");
        voterCount++;
        voters[msg.sender] = Voter(msg.sender, _name, _age, true, false);
        emit VoterRegistered(msg.sender, _name, _age, true);
    }

    function vote(uint _candidateId) public isRegisteredVoter hasNotVoted {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");
        voters[msg.sender].hasVoted = true;
        candidates[_candidateId].voteCount++;
        emit VoteCast(msg.sender, _candidateId);
    }

    function getCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory allCandidates = new Candidate[](candidateCount);
        for (uint i = 1; i <= candidateCount; i++) {
            allCandidates[i - 1] = candidates[i];
        }
        return allCandidates;
    }

    function getVoters() public view returns (Voter[] memory) {
        Voter[] memory allVoters = new Voter[](voterCount);
        uint index = 0;
        for (uint i = 0; i < voterCount; i++) {
            allVoters[index] = voters[msg.sender];
            index++;
        }
        return allVoters;
    }

    function getResults() public view returns (Candidate[] memory) {
        return getCandidates();
    }

    function getWinner() public view onlyOwner returns (string memory) {
        uint winningVoteCount = 0;
        uint winningCandidateId = 0;
        for (uint i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }
        return candidates[winningCandidateId].name;
    }
}
