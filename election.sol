// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Election{

    address public owner=msg.sender;
    uint public candidateCount=0;
    uint public voterCount=0;

    struct Candidate {
        uint candId;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;

    struct Voter{
        uint voterId;
        string name;
        uint age;
        bool isRegistered;
        bool isVoted;
        uint votedCandidate;
    }

    mapping(address => Voter) public voters;

    event candidateAdded(uint indexed candidateID,string name);
    event voterRegistered(uint indexed voterID,string name,address indexed voter);
    event voted(uint indexed voterID,address indexed voter,string name,uint indexed candidateID);

    modifier isOwner(){
        require(msg.sender==owner,"Only Owner is allowed");
        _;
    }

    modifier isEligible(uint _age){
        require(_age>=18,"You are not eligible for voting");
        _;
    }

    modifier isRegisteredVoter(){
        require(voters[msg.sender].isRegistered,"You are not a Registered voter");
        _;
    }

    modifier isNotVoted(){
        require(!voters[msg.sender].isVoted,"You have already Voted");
        _;
    }

    function addCandidate(string memory _name) public isOwner {
        candidateCount++;
        candidates[candidateCount]=Candidate(candidateCount,_name,0);
        emit candidateAdded(candidateCount,_name);
    }

    function registerVoter(string memory _name,uint _age) public isEligible(_age) {
        require(!voters[msg.sender].isRegistered,"You are already Registered");
        voterCount++;
        voters[msg.sender]=Voter(voterCount,_name,_age,true,false,0);
        emit voterRegistered(voterCount,_name,msg.sender);
    }

    function vote(uint _id) public isRegisteredVoter isNotVoted {
        Voter storage _voter= voters[msg.sender];
        require(_id>0 && _id<=candidateCount, "Invalid Candidate");

        _voter.isVoted=true;
        _voter.votedCandidate=_id;
        candidates[_id].voteCount++;
        emit voted(_voter.voterId,msg.sender,_voter.name,_id);
    }

    function candidateVoteCount(uint _id) public view isOwner returns(uint) {
        require(_id>0 && _id<=candidateCount, "Invalid Candidate");

        uint count= candidates[_id].voteCount;
        
        return count;
    }

    function winner() public view isOwner returns(string memory) {
        string memory winnerCandidate=candidates[1].name;
        uint maxVotes=candidates[1].voteCount;
        for(uint i=2;i<=candidateCount;i++)
        {
            if (candidates[i].voteCount>maxVotes)
            {
                winnerCandidate=candidates[i].name;
                maxVotes=candidates[i].voteCount;
            }
        }

        return winnerCandidate;
    }

}