// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script , console} from "forge-std/Script.sol";
// import "forge-std/console2.sol";
import "../src/DAO.sol";

contract Voting is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.broadcast(deployerPrivateKey);
        DAO dao = new DAO();
        console.log("address of dao contract" , address(dao));
    }
}
