// SPDX-FileCopyrightText: 2025 Dai Foundation <www.daifoundation.org>
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

methods {
    function increment() external envfree;
    function number() external returns(uint256) envfree;
    function wards(address usr) external returns(uint256) envfree;
}

definition b32_number() returns bytes32 = to_bytes32(0x6e756d6265720000000000000000000000000000000000000000000000000000);

rule entrypoints(method f) {
    assert f.selector == sig:rely(address).selector ||
        f.selector == sig:deny(address).selector ||
        f.selector == sig:file(bytes32, uint256).selector ||
        f.selector == sig:reset().selector ||
        f.selector == sig:increment().selector ||
        f.selector == sig:wards(address).selector ||
        f.selector == sig:number().selector,
        "Invalid entrypoint";
}

// Verify that each storage variable is only modified in the expected functions
rule storage_affected(method f) {
    env e;
    address anyAddr;

    mathint wardsBefore = wards(anyAddr);
    mathint numberBefore = number();

    calldataarg args;
    f(e, args);

    mathint wardsAfter = wards(anyAddr);
    mathint numberAfter = number();

    assert wardsAfter != wardsBefore => f.selector == sig:rely(address).selector || f.selector == sig:deny(address).selector,
        "wards[x] changed in an unexpected function";

    assert numberAfter != numberBefore => f.selector == sig:file(bytes32, uint256).selector ||
        f.selector == sig:reset().selector ||
        f.selector == sig:increment().selector,
        "number changed in an unexpected function";
}

// Verify that the correct storage changes for non-reverting rely
rule rely(address usr) {
    env e;

    address other;
    require other != usr;

    mathint wardsOtherBefore = wards(other);

    rely(e, usr);

    mathint wardsOtherAfter = wards(other);
    mathint wardsUsrAfter = wards(usr);

    assert wardsUsrAfter == 1, "rely did not set wards[usr]";
    assert wardsOtherAfter == wardsOtherBefore, "rely unexpectedly changed other wards[x]";
}

// Verify revert rules on rely
rule rely_revert(address usr) {
    env e;

    mathint wardsSender = wards(e.msg.sender);

    bool revert1 = e.msg.value > 0;
    bool revert2 = wardsSender != 1;

    rely@withrevert(e, usr);

    assert lastReverted <=> revert1 || revert2, "rely revert rules failed";
}

// Verify that the correct storage changes for non-reverting deny
rule deny(address usr) {
    env e;

    address other;
    require other != usr;

    mathint wardsOtherBefore = wards(other);

    deny(e, usr);

    mathint wardsOtherAfter = wards(other);
    mathint wardsUsrAfter = wards(usr);

    assert wardsUsrAfter == 0, "deny did not set wards[usr]";
    assert wardsOtherAfter == wardsOtherBefore, "deny unexpectedly changed other wards[x]";
}

// Verify revert rules on deny
rule deny_revert(address usr) {
    env e;

    mathint wardsSender = wards(e.msg.sender);

    bool revert1 = e.msg.value > 0;
    bool revert2 = wardsSender != 1;

    deny@withrevert(e, usr);

    assert lastReverted <=> revert1 || revert2, "deny revert rules failed";
}


rule increment_always_by_one() {
    mathint numberBefore = number();

    increment();

    mathint numberAfter = number();

    assert numberAfter == numberBefore + 1, "increment did not increment number by 1";
}

rule increment_reverts() {
    env e;
    mathint numberBefore = number();

    // `increment` is declared as `envfree`, the check for e.msg.value > 0 is not needed,
    // since the environment is ignored by the prover.
    bool revert1 = numberBefore == max_uint256;

    increment@withrevert();

    assert lastReverted <=> revert1, "increment revert rules failed";
}

rule reset() {
    env e;

    reset(e);

    assert number() == 0, "reset did not reset number to 0";
}

rule reset_reverts() {
    env e;

    bool revert1 = e.msg.value > 0;
    bool revert2 = wards(e.msg.sender) != 1;

    reset@withrevert(e);

    assert lastReverted <=> revert1 || revert2, "reset revert rules failed";
}

rule file(uint256 val) {
    env e;

    file(e, b32_number(), val);

    assert number() == val, "file did not reset number to 0";
}

rule file_reverts(bytes32 what, uint256 val) {
    env e;

    bool revert1 = e.msg.value > 0;
    bool revert2 = wards(e.msg.sender) != 1;
    bool revert3 = what != b32_number();

    file@withrevert(e, what, val);

    assert lastReverted <=> revert1 || revert2 || revert3, "file revert rules failed";
}
