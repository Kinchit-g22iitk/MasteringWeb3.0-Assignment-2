# Election Smart Contract Documentation

This documentation provides a comprehensive overview of the implementation of `Election` smart contract written in Solidity. The contract manages various aspects of an election process, including candidate registration, voter registration, voting, and declaring the winner(s).

## Contract Overview

The `Election` contract allows for:
- Registration of candidates and voters.
- Voting by eligible voters.
- Starting and ending the election.
- Retrieving details about candidates and voters.
- Determining the winner(s) of the election based on vote counts.

## Contract Structure

### State Variables

- `owner`: Address of the contract owner.
- `candidates_count`: Total number of candidates.
- `voters_count`: Total number of voters.
- `minimum_voting_age`: Minimum age required to vote which is 18 in India.
- `election_started`: Boolean which specify if the election has begun.
- `election_ended`: Boolean which specify if the election has ended.
- `candidates`: Mapping of candidate IDs to `Candidate` structs.
- `voters`: Mapping of voter addresses to `Voter` structs.
- `eligible_voters`: Mapping of voter addresses to their status of eligibility.

### Structs

#### `Candidate`
Represents a candidate in the election.
- `id`: Unique ID for the candidate.
- `name`: Name of the candidate.
- `vote_count`: Number of votes received by the candidate.
- `party`: Political party of the candidate.
- `age`: Age of the candidate.

#### `Voter`
Represents a voter in the election.
- `id`: Unique ID for the voter.
- `isEligible`: Boolean which specify if the voter is eligible to vote.
- `has_voted`: Boolean which specify if the voter has voted.
- `voted_candidate_id`: ID of the candidate for which the voter has voted.
- `age`: Age of the voter.
- `location`: Location of the voter.
- `name`: Name of the voter.

### Events

- `candidate_added`: Triggered when a new candidate is added.
- `voter_registered`: Triggered when a new voter is registered.
- `vote_casted`: Triggered when a vote is casted.
- `Election_started`: Triggered when the election has started.
- `Election_ended`: Triggered when the election has ended.

### Modifiers

- `only_owner`: Restricts function access to the contract owner.
- `only_eligible_voter`: Restricts function access to eligible voters who haven't voted yet.
- `when_election_not_started`: Ensures the election hasn't started.
- `when_election_started`: Ensures the election has started.
- `when_election_not_ended`: Ensures the election hasn't ended.

## Functions

#### `constructor()`
Sets the contract deployer as the owner.

#### `start_election()`
Starts the election. Only callable by the owner when the election hasn't started.

#### `end_election()`
Ends the election. Only callable by the owner when the election has started but hasn't ended.

#### `add_candidate(string memory _name, string memory _party, uint _age)`
Adds a new candidate. Only callable by the owner.
- `_name`: Name of the candidate.
- `_party`: Political party of the candidate.
- `_age`: Age of the candidate.

#### `voter_register(address _voterAddress, uint _age, string memory _location, string memory _name)`
Registers a new voter. Only callable by the owner.
- `_voterAddress`: Address of the voter.
- `_age`: Age of the voter.
- `_location`: Location of the voter.
- `_name`: Name of the voter.

#### `vote(uint _candidate_id)`
Allows an eligible voter to cast a vote for a candidate.
- `_candidate_id`: ID of the candidate to vote for.

#### `get_candidate(uint _candidate_id) public view returns (uint, string memory, uint, string memory, uint)`
Returns the details of a candidate.
- `_candidate_id`: ID of the candidate.

#### `get_voter(address _voter_address) public view returns (uint, bool, bool, uint, uint, string memory, string memory)`
Returns the details of a voter.
- `_voter_address`: Address of the voter.

#### `getWinners() public view whenElectionNotEnded returns (Candidate[] memory)`
Returns an array of candidates who have the highest vote count.Firstly it iterates through each candidate using a for loop, starting from candidate ID 1 up to candidates_count. Then checks if the current candidate's vote_count (stored in the candidates mapping) is greater than max_vote_count.
If true, updates max_vote_count to the current candidate's vote_count and sets winner_count to 1 (indicating one winner so far).If the current candidate's vote_count equals max_vote_count, increments winner_count by 1 to account for ties.

## Design Decisions

1. **Modifiers for Access Control**: Modifiers are used to make sure that some actions are performed only by specific roles for eg, only eligible voters can cast a vote, or a candidate can be added only by owner ,and that functions are called at appropriate times (e.g., election started or ended).

2. **Event Emission**: Events are fired for significant activities (e.g., adding candidates, registering voters, casting votes) to provide transparency to external entities and facilitate tracking.

3. **Mapping for Storage**: Mappings are used to efficiently store and retrieve candidate and voter information using unique identifiers (IDs and addresses).They allow for access to elements based on their keys (IDs or addresses in this case) in O(1) time regardless of the size of the map and also minimises gas costs.

4. **Age Verification**: A minimum voting age i.e. 18 is enforced to determine if a voter is eligible or not.

5. **Winner Determination**: The function `getWinners` identifies the candidate(s) with the highest vote count.

By implementing these design choices, the `Election` contract ensures a secure, transparent, and efficient election process.
