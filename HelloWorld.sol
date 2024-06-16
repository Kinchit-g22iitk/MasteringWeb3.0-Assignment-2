// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Election {
    // Contract owner
    address public owner;

    // Candidate struct
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Voter struct
    struct Voter {
        bool eligible;
        bool voted;
        uint vote;
    }

    // Mapping to store candidates
    mapping(uint => Candidate) public candidates;
    // Mapping to store voters
    mapping(address => Voter) public voters;

    // Number of candidates
    uint public candidatesCount;

    // Events
    event CandidateAdded(uint id, string name);
    event VoterRegistered(address voter);
    event VoteCast(address voter, uint candidateId);

    // Modifier to restrict access to contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Constructor
    constructor() {
        owner = msg.sender;
    }

    // Function to add a candidate
    function addCandidate(string memory _name) public onlyOwner {
        require(bytes(_name).length > 0, "Candidate name cannot be empty");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateAdded(candidatesCount, _name);
    }

    // Function to register a voter
    function registerVoter(address _voter) public onlyOwner {
        require(_voter != address(0), "Invalid voter address");
        require(!voters[_voter].eligible, "Voter is already registered");
        voters[_voter] = Voter(true, false, 0);
        emit VoterRegistered(_voter);
    }

    // Function to cast a vote
    function vote(uint _candidateId) public {
        // Check if voter is eligible and has not voted before
        require(voters[msg.sender].eligible, "You are not eligible to vote");
        require(!voters[msg.sender].voted, "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");

        // Record the vote
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = _candidateId;

        // Update candidate vote count
        candidates[_candidateId].voteCount++;

        emit VoteCast(msg.sender, _candidateId);
    }

    // Function to get the vote count of a candidate
    function getCandidateVoteCount(uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        return candidates[_candidateId].voteCount;
    }

    // Function to check if a voter has voted
    function hasVoted(address _voter) public view returns (bool) {
        return voters[_voter].voted;
    }
}
