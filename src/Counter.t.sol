// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {DssTest} from "dss-test/DssTest.sol";
import {Counter} from "src/Counter.sol";

contract CounterTest is DssTest {
    Counter counter;
    uint256 constant INITIAL = 42;
    address owner = address(0x1337);

    function setUp() public {
        counter = new Counter(INITIAL);
        counter.rely(owner);
        counter.deny(address(this));
    }

    function testConstructor() public view {
        assertEq(counter.number(), INITIAL);
    }

    function testAuth() public {
        checkAuth(address(counter), "Counter");
    }

    function testFile() public {
        checkFileUint(address(counter), "Counter", ["number"]);
    }

    function testAuthMethods() public {
        checkModifier(address(counter), "Counter/not-authorized", [counter.reset.selector]);
    }

    function testReset() public {
        vm.prank(owner);
        counter.reset();

        assertEq(counter.number(), 0);
    }

    function testIncrement() public {
        address other = address(0x123);
        uint256 pnumber = counter.number();

        vm.prank(other);
        counter.increment();

        assertEq(counter.number(), pnumber + 1);
    }
}
