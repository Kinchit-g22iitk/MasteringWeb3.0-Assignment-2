pragma solidity >=0.7.0 <0.9.0;

contract Election{
    struct Candidate{
        uint ID;
        string name;
        uint voteCount;
        address addr;
    }
    struct Voter{
        uint ID;
        bool eligible;
        address addr;
    }
    address moderator;
    mapping(uint=>Voter)voterList;
    mapping(uint=>Candidate)candidateList;
    uint[] voterID;
    uint[] candidateID;
    constructor(){
        moderator = msg.sender;
    }
    modifier isMod(){
        require(msg.sender == moderator);
        _;
    }
    function registerVoter(uint ID, address addr) public{
        bool k=true;
        for(uint i = 0; i<voterID.length;i++){
            if(voterID[i]==ID){
                k=false;break;
            }
        }
        require(k);
        voterList[ID] = Voter({ID:ID, eligible:true, addr:addr});
        voterID.push(ID);
    }
    function registerCandidate(uint ID, string memory name) public isMod{
        bool k=true;
        for(uint i = 0; i<candidateID.length;i++){
            if(candidateID[i]==ID){
                k=false;break;
            }
        }
        require(k);
        candidateList[ID] = Candidate({ID:ID, name:name, voteCount: 0,addr:msg.sender});
        candidateID.push(ID);
    }
    function castVote(uint vID, uint candidID) public{
        bool k=true;
        for(uint i = 0; i<voterID.length;i++){
            if(voterID[i]==vID){
                k=false;break;
            }
        }
        require(!k);
        k=true;
        for(uint i = 0; i<candidateID.length;i++){
            if(candidateID[i]==candidID){
                k=false;break;
            }
        }
        require(!k);
        require(msg.sender==voterList[vID].addr);
        if(voterList[vID].eligible){
             candidateList[candidID].voteCount = candidateList[candidID].voteCount+1;
             voterList[vID].eligible = false;
        } 
    }
    function seeVotes(uint ID) public view returns(uint votes){
        bool k=true;
        for(uint i = 0; i<candidateID.length;i++){
            if(candidateID[i]==ID){
                k=false;break;
            }
        }
        require(!k);
        votes = candidateList[ID].voteCount;
    }
    function getName(uint ID) public view returns(string memory name){
        bool k=true;
        for(uint i = 0; i<candidateID.length;i++){
            if(candidateID[i]==ID){
                k=false;break;
            }
        }
        require(!k);
        name = candidateList[ID].name;
    }
    function getWinner() public view returns(uint){
        require(candidateID.length>0);
        uint max =0;
        for(uint i =0; i<candidateID.length;i++){
            if(candidateList[max].voteCount<candidateList[candidateID[i]].voteCount){
                max = candidateID[i];
            }
        }
        return max;
    }

}