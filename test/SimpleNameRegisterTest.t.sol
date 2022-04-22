// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import 'src/SimpleNameRegister.sol';

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

interface CheatCodes {
    function prank(address) external;
    function expectRevert(bytes calldata) external;
    function startPrank(address) external;
    function stopPrank() external;
}

contract StateZero is DSTest {
    SimpleNameRegister public simpleNameRegister;
    CheatCodes cheats;
    
    function setUp() public virtual {
        simpleNameRegister = new SimpleNameRegister();
        cheats = CheatCodes(HEVM_ADDRESS);
    }

    function testCannotRelease(string memory testString) public {  
        cheats.expectRevert(bytes("Not your name!"));
        simpleNameRegister.release(testString);
    }

    function testRegister(string memory testString) public {
        simpleNameRegister.register(testString);
        bool success = (address(this) == simpleNameRegister.holder(testString));
        assertTrue(success);
    }
}

contract StateRegistered is StateZero {
    address adversary;
    string name;

    function setUp() public override {
        super.setUp();
        adversary = 0xE6A2e85916802210147e366D4431f5ca4dD51a78;
        
        // state transition
        name = 'whale';
        simpleNameRegister.register(name);
    }

    function testAdversaryCannotRegisterName() public {
        cheats.startPrank(adversary);
        cheats.expectRevert(bytes("Already registered!"));
        simpleNameRegister.register(name);   
        cheats.stopPrank();
    }

    function testAdversaryCannotReleaseName() public {
        cheats.startPrank(adversary);
        cheats.expectRevert(bytes("Not your name!"));
        simpleNameRegister.release(name);   
        cheats.stopPrank();
    }

    function testUserCannotRegisterOwnedName() public {
        cheats.expectRevert(bytes("Already registered!"));
        simpleNameRegister.register(name);
    }

    function testUserRelease() public {
        simpleNameRegister.release(name);
        bool success = (address(0) == simpleNameRegister.holder(name));
        assertTrue(success);
    }
}
