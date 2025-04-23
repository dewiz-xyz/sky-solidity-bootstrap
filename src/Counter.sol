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

/// @title Counter
/// @notice A simple counter
/// @author amusingaxl
contract Counter {
    /// @notice Authorized users
    mapping(address => uint256) public wards;

    /// @notice The current number
    uint256 public number;

    /// @notice Emitted when a user is authorized
    /// @param usr The authorized user
    event Rely(address indexed usr);

    /// @notice Emitted when a user is de-authorized
    /// @param usr The de-authorized user
    event Deny(address indexed usr);

    /// @notice Emitted when a contract parameter is updated
    /// @param what The parameter name
    /// @param data The parameter value
    event File(bytes32 indexed what, uint256 data);

    /// @dev Requires the caller to be authorized
    modifier auth() {
        require(wards[msg.sender] == 1, "Counter/not-authorized");
        _;
    }

    /// @param initial The initial value
    constructor(uint256 initial) {
        number = initial;
        wards[msg.sender] = 1;
        emit Rely(msg.sender);
    }

    /// @notice Authorizes a user
    /// @param usr The user to be authorized
    function rely(address usr) external auth {
        wards[usr] = 1;
        emit Rely(usr);
    }

    /// @notice De-authorizes a user
    /// @param usr The user to be de-authorized
    function deny(address usr) external auth {
        wards[usr] = 0;
        emit Deny(usr);
    }

    /// @notice Updates a contract parameter
    /// @param what The parameter name. ["number"]
    /// @param data The parameter value
    function file(bytes32 what, uint256 data) external auth {
        if (what == "number") {
            number = data;
        } else {
            revert("Counter/file-unrecognized-param");
        }
        emit File(what, data);
    }

    /// @notice Resets the counter to zero
    function reset() external auth {
        number = 0;
    }

    /// @notice Increments the counter by one
    function increment() external {
        number++;
    }
}
