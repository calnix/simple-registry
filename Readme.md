# Objectives
We want to create a smart contract that serves as a name registry, recording the holders of each name.

1. Users(addresses) can register a name, which is recorded on-chain.
2. Only a single holder of a name (1-to-1 relationship)
3. A single user can register multiple names (1-to-many relationship)
4. Users are able to release a name registered to them, therefore, making it available for registration again.

# Design considerations

### Problem:
A single address could be the owner of multiple names.
It would be useful if the end-user could simply supply their address to check which are the names registered to them.
Achieving this one to many structure on-chain would not be gas efficient.

### Solution:
Use of events to announce when a user has registered or released a name.
Run a background task that subscribes to events into a database, to track the list of addresses registered by each user.
Website front-end can read from this database and reflect accordingly. 

# State inheritance testing approach
State Zero: 
(No names are registered at inception)

* Negative tests: 
	User cannot release any names, since none are registered to him (testCannotRelease)
* Positive test:
	User can register any name of choice (testRegister)

StateRegistered: 
(User has registered a name)

State transition: let name = 'whale', registered by user.

* Negative tests: 
	Adversary cannot register name  (testAdversaryCannotRegisterName)
	Adversary cannot release name   (testAdversaryCannotReleaseName)
	User cannot register name       (testUserCannotRegisterOwnedName)
* Positive test:
	User can release name		    (testUserRelease)


# Deployment
Kovan testnet, verified in etherscan.
> Note: Windows machines seem to face issues with verification. Solution: spin up a linux VM, else use brownie to verify.

# Submission
Contract should be fully tested.
Include the link to the deployed and verified contract in your pull request.

# Full breakdown
https://calnix.gitbook.io/solidity-lr/yield-mentorship-2022/simple-registry-1
