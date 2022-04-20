// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import 'src/SimpleNameRegister.sol';

interface CheatCodes {
    function prank(address) external;
    function expectRevert(bytes calldata) external;
    function startPrank(address) external;
    function stopPrank() external;
}

contract SimpleNameRegisterTest is DSTest {
    
    // declare state var.
    SimpleNameRegister simpleNameRegister;
    CheatCodes cheats;
    address adversary;

    function setUp() public {
        simpleNameRegister = new SimpleNameRegister();
        cheats = CheatCodes(HEVM_ADDRESS);
        adversary = 0xE6A2e85916802210147e366D4431f5ca4dD51a78;
    }

    // user can register an available name
    function testRegisterName(string memory _testString) public {
        simpleNameRegister.registerName(_testString);
        bool success = (address(this) == simpleNameRegister.nameOwner(_testString));
        assertTrue(success);
    }
    
    // user can register an available name and relinquish it
    function testRelinquishName(string memory _testString) public {
        simpleNameRegister.registerName(_testString);   
        simpleNameRegister.relinquishName(_testString);
        bool success = (simpleNameRegister.nameOwner(_testString) == address(0));
        assertTrue(success);
    }

    // user cannot relinquish a name that does not belong to them
    function testRelinquishAsNotOwner(string memory _testString) public {
        simpleNameRegister.registerName(_testString);   
        cheats.startPrank(adversary);
        cheats.expectRevert(bytes("The provided name does not belong to you!"));
        simpleNameRegister.relinquishName(_testString);        
        cheats.stopPrank();
    }
    
    // user cannot register a name that already has an owner
    function testRegisterUnavailableName(string memory _testString) public {
        simpleNameRegister.registerName(_testString);   
        cheats.startPrank(adversary);
        cheats.expectRevert(bytes("The provided name has already been registered!"));
        simpleNameRegister.registerName(_testString);   
        cheats.stopPrank();

    }
}
