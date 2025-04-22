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
pragma solidity ^0.8.24;

contract Counter {
    mapping(address => uint256) public wards;
    uint256 public number;

    event Rely(address indexed usr);
    event Deny(address indexed usr);
    event File(bytes32 indexed what, uint256 data);

    modifier auth() {
        require(wards[msg.sender] == 1, "Counter/not-authorized");
        _;
    }

    constructor(uint256 initial) {
        number = initial;
        wards[msg.sender] = 1;
        emit Rely(msg.sender);
    }

    function rely(address usr) external auth {
        wards[usr] = 1;
        emit Rely(usr);
    }

    function deny(address usr) external auth {
        wards[usr] = 0;
        emit Deny(usr);
    }

    function file(bytes32 what, uint256 data) external auth {
        if (what == "number") {
            number = data;
        } else {
            revert("Counter/file-unrecognized-param");
        }
        emit File(what, data);
    }

    function reset() external auth {
        number = 0;
    }

    function increment() external {
        number++;
    }
}
