// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Election {

	struct Voter { //VOTER STRUCTURE
		bool registered; // if true, then eligible else false
		bool voted; // if true, then voted else false
		uint256 vote; //voted candidate index
	}
	struct Candidate { //CANDIDATE STRUCTURE
		string name; //name 
		uint256 votes; //total votes 
	}

	address public leader; //ELECTION CREATOR

	
	mapping(address => Voter) public voters; //MAPS VOTER TO ADDRESS

	Candidate[] public candidates; //ARRAY TO STORE CANDIDATE NAMES 

	// Create a new election to choose one of `_candidateNames`.
	constructor(string[] memory _candidateNames) {
		leader = msg.sender; //msg is a global variable that provides access to the metadata of the current call to the contract... 
      //msg.sender is the address of the account (or contract) that sent the current transaction or message.
		voters[leader].registered = true;

		for (uint256 i = 0; i < _candidateNames.length; i++) { // For each provided candidate name, create a new `Candidate` and add it to the end of the `voters` array.
			// appends it to the end of `candidates`.
			candidates.push(Candidate({name: _candidateNames[i], votes: 0}));
		}
	}

	function VoterRegistration(address voter) external { //LEADER WILL REGISTER VOTER 
		require(
			msg.sender == leader,
			"The Creator can only give voting rights !!"
		);
		require(!voters[voter].voted, "voter already voted.");
		require(!voters[voter].registered, "Voter is already registered.");
		voters[voter].registered = true;
	}

	function VoteCasting(uint256 _candidate) external {//CAST VOTE TO DESIRED CANDIDATES
		Voter storage voter = voters[msg.sender];
		require(voter.registered, "Voter is not registered.");
		require(!voter.voted, "Already voted.");
		candidates[_candidate].votes = candidates[_candidate].votes + 1;
		voter.voted = true;
	}

	// Determine the winning candidate.
	function WinningCandidate()
		public
		view
		returns (uint256 winningCandidate_)
	{
		uint256 winner;
		uint256 maxVotes = 0;
		bool votesCasted = false;

		for (uint256 i = 0; i < candidates.length; i++){
			if(candidates[i].votes > 0)
				votesCasted = true;

			if(candidates[i].votes > maxVotes){
				maxVotes = candidates[i].votes;
				winner = i;
			}
		}
		require(votesCasted, "No votes have been cast.");
    //WILL RETUEN INDEX OF THE WINNING CANDIDATE ! ! !
		return winner;
	}

	function WinningCandidateName() //WILL GET CANDIDATE NAME VIA INDEX
		external
		view
		returns (string memory winnerName_)
	{
		return candidates[winningCandidate()].name;
	}
}
