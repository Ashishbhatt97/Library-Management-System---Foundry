pragma solidity ^0.8.2;

import "forge-std/Script.sol";
import "../src/LibraryManagement.sol";

contract LibraryScript is Script {
    function setUp() public {}

    function run() external {
        string memory seedPhrase = vm.readFile(".secret");

        uint256 privateKey = vm.deriveKey(seedPhrase, 0);

        vm.startBroadcast(privateKey);

        LibraryManagement libraryManagement = new LibraryManagement();

        vm.stopBroadcast();
    }
}
// forge create --rpc-url https://rpc-amoy.polygon.technology --private-key <Private-key> src/LibraryManagement.sol:LibraryManagement --verify
// https://amoy.polygonscan.com/address/0xc7cfc9add6afa06ee855202e35445145b5af4e6f
