// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "ds-test/test.sol";
import 'src/SimpleNameRegister.sol';

import {Vm} from "forge-std/Vm.sol";


interface CheatCodes {
    function prank(address) external;
    function expectRevert(bytes calldata) external;
    function startPrank(address) external;
    function stopPrank() external;
}

contract SimpleNameRegisterTest is DSTest {
        
    SimpleNameRegister simpleNameRegister;
    CheatCodes cheats;
    address adversary;
    Vm internal constant vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    string name;

    function setUp() public virtual {
        simpleNameRegister = new SimpleNameRegister();
        name = "test";
    }


    function testAdversaryRegister_CHEATS() public {
        cheats.startPrank(adversary);
        simpleNameRegister.register(name);
        cheats.stopPrank();
        bool success = (adversary == simpleNameRegister.holder(name));
        assertTrue(success);
    }
    
    function testAdversaryRegister_VM() public {
        vm.startPrank(adversary);
        simpleNameRegister.register(name);
        vm.stopPrank();
        bool success = (adversary == simpleNameRegister.holder(name));
        assertTrue(success);
    }
}
