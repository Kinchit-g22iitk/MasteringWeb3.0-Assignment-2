This is the application of solidity language using OOPs concepts in which, I made a simple Election program, which have functions like adding candidates, adding voters, casting votes, give vote counts of candidates and winner.
It also has modifiers which allows only owner to add candidates , retrieving vote counts and winner to make it safe, a modifier which checks whether the voter is eligible for casting votes by checking their age.
For ensuring that the voters can't do multiple voting I add a modifier which checks the isVoted property of the voter to check whether he/she voted or not.
The user who deploys the code becomes the owner and the track of owner is done by its address.
The voters are mapped with their address which helps in retrieving voters data easily because every user has its unique address and also it ensures that their is only one voter registered from a given address.

