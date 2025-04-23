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

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {MCD, DssInstance} from "dss-test/MCD.sol";
import {ScriptTools} from "dss-test/ScriptTools.sol";
import {CounterDeploy, CounterDeployParams} from "src/deployment/CounterDeploy.sol";
import {CounterInstance} from "src/deployment/CounterInstance.sol";

contract CounterDeployScript is Script {
    using stdJson for string;
    using ScriptTools for string;

    string constant NAME = "counter-deploy";
    string config;

    address constant CHAINLOG = 0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F;
    DssInstance dss = MCD.loadFromChainlog(CHAINLOG);
    address pauseProxy = dss.chainlog.getAddress("MCD_PAUSE_PROXY");

    CounterInstance inst;

    function run() external {
        config = ScriptTools.loadConfig();

        uint256 initial = config.readUint(".initial");

        vm.startBroadcast();

        inst = CounterDeploy.deploy(CounterDeployParams({deployer: msg.sender, onwer: pauseProxy, initial: initial}));

        vm.stopBroadcast();

        ScriptTools.exportContract(NAME, "counter", address(inst.counter));
    }
}
