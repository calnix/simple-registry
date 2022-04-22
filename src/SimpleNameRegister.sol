// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SimpleNameRegister {
    
    // map a string to an address to identify current owner
    mapping (string => address) public holder;    

    // emit event when name is registered or relinquished
    event Register(address indexed owner, string indexed name);
    event Release(address indexed owner, string indexed name);

    // register an available name
    function register(string memory name) public {
        require(nameOwner[name] == address(0), "Already registered!");
        holder[name] = msg.sender;
        emit Register(msg.sender, name);
    }

    // owner can release a name that they own
    function release(string memory name) public {
        require(nameOwner[name] == msg.sender, "Invalid name!");
        holder[name] = address(0);
        emit Release(msg.sender, name);
    }
}
