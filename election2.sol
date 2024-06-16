// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Election{

    struct Candidate {
        uint id;
        string name;
        uint vote_count;
        string party;
        uint age;
    }

    struct Voter {
        uint id;
        bool is_eligible;
        bool has_voted;
        uint voted_candidate_id;
        uint age;
        string location;
        string name;
    }

    address public owner;
    uint public candidates_count;
    uint public voters_count;
    uint public minimum_voting_age = 18;
    bool public election_started;
    bool public election_ended;
    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;
    mapping(address => bool) public eligible_voters;

    event candidate_added(uint indexed id, string name, string party, uint age);
    event voter_registered(address indexed voter_address, string name, uint age, string location);
    event vote_casted(address indexed voter, uint indexed candidate_id);
    event Election_started();
    event Election_ended();

    modifier only_owner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier only_eligible_voter() {
        require(voters[msg.sender].is_eligible, "You are not eligible to vote");
        require(!voters[msg.sender].has_voted, "You have already voted");
        _;
    }

    modifier when_election_not_started() {
        require(!election_started, "Election already started");
        _;
    }

    modifier when_election_started() {
        require(election_started, "Election has not started");
        _;
    }

    modifier when_election_not_ended() {
        require(!election_ended, "Election already ended");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function start_election() public only_owner when_election_not_started {
        election_started = true;
        emit Election_started();
    }

    function end_election() public only_owner when_election_started when_election_not_ended {
        election_ended = true;
        emit Election_ended();
    }

    function add_candidate(string memory _name, string memory _party, uint _age) public only_owner {
        candidates_count++;
        candidates[candidates_count] = Candidate(candidates_count, _name, 0, _party, _age);
        emit candidate_added(candidates_count, _name, _party, _age);
    }


    function voter_register(address _voter_address, uint _age, string memory _location, string memory _name) public only_owner {
        voters_count++;
        bool is_eligible = _age >= minimum_voting_age;
        voters[_voter_address] = Voter(voters_count, is_eligible, false, 0, _age, _location, _name);
        eligible_voters[_voter_address] = is_eligible;
        emit voter_registered(msg.sender, _name, _age, _location);
    }


    function vote(uint _candidate_id) public only_eligible_voter {
        require(_candidate_id > 0 && _candidate_id <= candidates_count, "Invalid candidate ID");
        voters[msg.sender].has_voted = true;
        voters[msg.sender].voted_candidate_id = _candidate_id;
        candidates[_candidate_id].vote_count++;
        emit vote_casted(msg.sender, _candidate_id);
    }

    function get_candidate(uint _candidate_id) public view returns (uint, string memory, uint, string memory,uint) {
        Candidate memory candidate = candidates[_candidate_id];
        return (candidate.id, candidate.name, candidate.vote_count, candidate.party, candidate.age);
    }

    function get_voter(address _voter_address) public view returns (uint, bool, bool, uint, uint, string memory, string memory) {
        Voter memory voter = voters[_voter_address];
        return (voter.id, voter.is_eligible, voter.has_voted, voter.voted_candidate_id, voter.age, voter.location, voter.name);
    }

    function getWinners() public view when_election_not_ended returns (Candidate[] memory) {
        uint max_vote_count = 0;
        uint winner_count = 0;

        for (uint i = 1; i <= candidates_count; i++) {
            if (candidates[i].vote_count > max_vote_count) {
                max_vote_count = candidates[i].vote_count;
                winner_count = 1;
            } else if (candidates[i].vote_count == max_vote_count) {
                winner_count += 1;
            }
        }

        Candidate[] memory winners = new Candidate[](winner_count);
        uint index = 0;
        for (uint i = 1; i <= candidates_count; i++) {
            if (candidates[i].vote_count == max_vote_count) {
                winners[index] = candidates[i];
                index++;
            }
        }

        return winners;
    }
}
