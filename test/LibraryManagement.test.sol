pragma solidity ^0.8.2;

import "forge-std/Test.sol";
import "../src/LibraryManagement.sol";

contract LibraryTest is Test {
    LibraryManagement libraryInstance;
    address owner = address(this);
    address student1 = address(0x0010); // adding another ETH Account
    address student2 = address(0x00055);

    function setUp() public {
        libraryInstance = new LibraryManagement();
    }

    // Add user test function
    function testAddUser() public {
        assertEq(libraryInstance.userCount(), 0);
        vm.prank(student1);

        libraryInstance.addUser("Ashish", "ashishbhatt0197@gmail.com");
        assertEq(libraryInstance.userCount(), 1);

        (
            string memory userName,
            uint256 userId,
            ,
            ,
            string memory email,
            uint256 numberOfBookIssued
        ) = libraryInstance.users(student1);

        assertEq(userName, "Ashish");
        assertEq(userId, 1);
        assertEq(email, "ashishbhatt0197@gmail.com");
        assertEq(numberOfBookIssued, 0);
    }

    // Add books test function
    function testAddBook() public {
        assertEq(libraryInstance.booksCount(), 0);

        libraryInstance.addBook(
            "The alchemist",
            "paulo coelho",
            "xyz publication",
            "15.nov.2022",
            "reading",
            5
        );

        assertEq(libraryInstance.booksCount(), 1);

        (
            uint256 bookId,
            string memory title,
            string memory authorName,
            string memory publisher,
            string memory publicationDate,
            string memory category,
            uint256 copiesAvailable
        ) = libraryInstance.books(1);

        assertEq(bookId, 1);
        assertEq(title, "The alchemist");
        assertEq(authorName, "paulo coelho");
        assertEq(publisher, "xyz publication");
        assertEq(publicationDate, "15.nov.2022");
        assertEq(category, "reading");
        assertEq(copiesAvailable, 5);

        vm.prank(student2);
        vm.expectRevert("You cannot make these changes!");

        libraryInstance.addBook(
            "The alchemist",
            "paulo coelho",
            "xyz publication",
            "15.nov.2022",
            "reading",
            5
        );
    }
}
