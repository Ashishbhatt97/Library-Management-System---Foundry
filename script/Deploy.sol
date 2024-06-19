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
