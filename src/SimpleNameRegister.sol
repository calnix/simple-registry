// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

///@title An on-chain name registry
///@author Calnix
contract SimpleNameRegister {
    
    /// @notice map a name to an address to identify current holder 
    mapping (string => address) public holder;    

    /// @notice emit an event when a name is registered or released
    event Register(address indexed holder, string name);
    event Release(address indexed holder, string name);

    /// @notice user can register an available name
    function register(string memory name) public {
        require(holder[name] == address(0), "Already registered!");
        holder[name] = msg.sender;
        emit Register(msg.sender, name);
    }

    /// @notice holder can release a name, making it available
    function release(string memory name) public {
        require(holder[name] == msg.sender, "Not your name!");
        delete holder[name];
        emit Release(msg.sender, name);
    }
}