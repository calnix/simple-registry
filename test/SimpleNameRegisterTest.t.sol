// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import 'src/SimpleNameRegister.sol';

import "forge-std/console2.sol";

interface CheatCodes {
    function prank(address) external;
    function expectRevert(bytes calldata) external;
    function label(address addr, string calldata label) external;
}

abstract contract StateZero is DSTest {
    SimpleNameRegister public simpleNameRegister;
    CheatCodes cheats;
    address user;
    
    function setUp() public virtual {
        simpleNameRegister = new SimpleNameRegister();
        cheats = CheatCodes(HEVM_ADDRESS);
        user = 0x0000000000000000000000000000000000000001;
        cheats.label(user, "user");
    }
}

contract StateZeroTest is StateZero {

    function testCannotRelease(string memory testString) public {  
        console2.log("Cannot release a name that you do not hold");
        cheats.prank(user);
        cheats.expectRevert(bytes("Not your name!"));
        simpleNameRegister.release(testString);
    }

    function testRegister(string memory testString) public {
        console2.log("User registers a name");
        cheats.prank(user);
        simpleNameRegister.register(testString);
        bool success = (user == simpleNameRegister.holder(testString));
        assertTrue(success);
    }
}

abstract contract StateRegistered is StateZero {
    address adversary;
    string name;

    function setUp() public override {
        super.setUp();
        adversary = 0xE6A2e85916802210147e366D4431f5ca4dD51a78;
        cheats.label(adversary, "adversary");
        
        // state transition
        name = 'whale';
        cheats.prank(user);
        simpleNameRegister.register(name);
    }
}

contract StateRegisteredTest is StateRegistered {

    function testAdversaryCannotRegisterName() public {
        console2.log("Adversary cannot register name belonging to User");
        cheats.prank(adversary);
        cheats.expectRevert(bytes("Already registered!"));
        simpleNameRegister.register(name);   
    }

    function testAdversaryCannotReleaseName() public {
        console2.log("Adversary cannot release name belonging to User");
        cheats.prank(adversary);
        cheats.expectRevert(bytes("Not your name!"));
        simpleNameRegister.release(name);   
    }

    function testUserCannotRegisterOwnedName() public {
        console2.log("User cannot register a name that he already holds");
        cheats.prank(user);
        cheats.expectRevert(bytes("Already registered!"));
        simpleNameRegister.register(name);
    }

    function testUserRelease() public {
        console2.log("User releases name that he holds");
        cheats.prank(user);
        simpleNameRegister.release(name);
        bool success = (address(0) == simpleNameRegister.holder(name));
        assertTrue(success);
    }
}