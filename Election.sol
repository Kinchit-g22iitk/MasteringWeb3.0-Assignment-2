// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Election {
   /**
   * @dev Election Contract
   */

    // variable to store the contract deployer
    address public owner;

    // store the owner when deployed
    constructor() { 
      owner = msg.sender;
    }

    struct Candidate {
      uint ID;
      string Name;
      uint Vote_count;
      uint Age;
    }
    struct Voter {
      address ID;
      string Name;
      uint8 Age;
      bool Eligible;
    }

    Candidate[] public candidate_list; //Dynamic list to store candidates
    Voter[] public registered_voter_list; // candidate list to store voters
    mapping(address => bool) public has_voted; // Mapping to track if a voter has voted

    // Define events
    event CandidateRegistered(uint indexed id, string name, uint age);
    event VoterRegistered(address indexed voterAddress, string name, uint8 age, bool eligible);
    event VoteCast(address indexed voter, uint indexed candidateId);

    modifier onlyOwner {
      require(msg.sender == owner,"You are not authorized to call this function");
      _; // rest of the function starts here
    }

   // Create a candidate(only owner can add candidate)
   function register_candidate(uint id, string memory name, uint age) public onlyOwner {
      Candidate memory new_candidate = Candidate({ // memory keyword for temporary storage
            ID: id,
            Name: name,
            Vote_count: 0,
            Age: age
        });

      candidate_list.push(new_candidate);

      // Emit event
      emit CandidateRegistered(id, name, age);
   }

   // Display All candidates 
   function display_candidates() public view returns(Candidate[] memory) {
      return candidate_list;
   }

   // register voter (which will be the contract caller) 
   function register_voter(string memory name, uint8 age) public returns(bool) {
    Voter memory new_voter = Voter({
      ID : msg.sender,
      Name : name,
      Age : age,
      Eligible : false
    });

    if(new_voter.Age>=18){
      new_voter.Eligible = true;
    }

    registered_voter_list.push(new_voter);

    // Emit event
    emit VoterRegistered(msg.sender, name, age, new_voter.Eligible);

    return new_voter.Eligible;
   }

   //display voters
   function display_voters() public view returns(Voter[] memory){
     return registered_voter_list;
   }

   // cast vote
   function cast_vote(uint candidate_id) public {
    require(!has_voted[msg.sender], "You have already voted.");

        bool voter_found = false;
        for (uint i = 0; i < registered_voter_list.length; i++) {
            if (registered_voter_list[i].ID == msg.sender) {
                require(registered_voter_list[i].Eligible, "You are not eligible to vote.");
                require(!has_voted[registered_voter_list[i].ID], "You have already voted.");
                has_voted[registered_voter_list[i].ID] = true;
                voter_found = true;
                break;
            }
        }
        require(voter_found, "You are not registered as a voter.");

        bool candidateFound = false;
        for (uint i = 0; i < candidate_list.length; i++) {
            if (candidate_list[i].ID == candidate_id) {
                candidate_list[i].Vote_count += 1;
                has_voted[msg.sender] = true;
                candidateFound = true;

                // Emit event
                emit VoteCast(msg.sender, candidate_id);
                break;
            }
        }
        require(candidateFound, "Candidate not found.");
   }

   //display results
   function results() public view returns(Candidate[] memory){
      return candidate_list;
   }
}
