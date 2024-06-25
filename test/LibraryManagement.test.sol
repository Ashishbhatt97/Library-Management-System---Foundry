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
            "Paulo Coelho",
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
        assertEq(authorName, "Paulo Coelho");
        assertEq(publisher, "xyz publication");
        assertEq(publicationDate, "15.nov.2022");
        assertEq(category, "reading");
        assertEq(copiesAvailable, 5);

        vm.prank(student2);
        vm.expectRevert("You cannot make these changes!");

        libraryInstance.addBook(
            "The alchemist",
            "Paulo Coelho",
            "xyz publication",
            "15.nov.2022",
            "reading",
            5
        );
    }

    function testBookIssue() public {
        vm.prank(student1);
        libraryInstance.addUser("Ashish", "ashishbhatt0197@gmail.com");

        vm.prank(owner);
        libraryInstance.addBook(
            "The alchemist",
            "Paulo Coelho",
            "xyz publication",
            "15.nov.2022",
            "reading",
            5
        );

        assertEq(libraryInstance.booksCount(), 1);
        assertEq(libraryInstance.userCount(), 1);

        libraryInstance.bookIssue(1, student1);
        (, , , , , , uint256 copiesAvailable) = libraryInstance.books(1);
        (, , , , , uint256 numberOfBookIssued) = libraryInstance.users(
            student1
        );

        assertEq(copiesAvailable, 4);
        assertEq(numberOfBookIssued, 1);

        vm.prank(student2);
        vm.expectRevert("You cannot make these changes!");

        libraryInstance.bookIssue(1, student1);
    }

    function testBookIssuesByUser() public {
        vm.prank(student1);
        libraryInstance.addUser("Ashish", "ashishbhatt0197@gmail.com");

        vm.prank(owner);
        libraryInstance.addBook(
            "The alchemist",
            "Paulo Coelho",
            "xyz publication",
            "15.nov.2022",
            "reading",
            5
        );

        libraryInstance.addBook(
            "IKIGAI",
            "hector garcia & francesc miralles",
            "Ediciones Urano",
            "2016",
            "General Guidance",
            5
        );

        assertEq(libraryInstance.booksCount(), 2);
        assertEq(libraryInstance.userCount(), 1);

        libraryInstance.bookIssue(1, student1);
        libraryInstance.bookIssue(2, student1);

        uint256[] memory totalBookIssued = libraryInstance.booksIssuedByUser(
            student1
        );
        assertEq(totalBookIssued.length, 2);
        assertEq(totalBookIssued[0], 1);
        assertEq(totalBookIssued[1], 2);
    }

    function testReturnBook() public {
        libraryInstance.addUser("Ashish", "ashishbhatt0197@gmail.com");
        libraryInstance.addBook(
            "The alchemist",
            "Paulo Coelho",
            "xyz publication",
            "15.nov.2022",
            "reading",
            5
        );

        libraryInstance.addBook(
            "IKIGAI",
            "hector garcia & francesc miralles",
            "Ediciones Urano",
            "2016",
            "General Guidance",
            5
        );

        libraryInstance.bookIssue(1, student1);
        libraryInstance.bookIssue(2, student1);

        assertEq(libraryInstance.booksCount(), 2);
        assertEq(libraryInstance.userCount(), 1);

        assertEq(libraryInstance.booksIssuedByUser(student1)[0], 1);
        assertEq(libraryInstance.booksIssuedByUser(student1)[1], 2);

        libraryInstance.booksReturnedByUser(student1, 1);

        uint256[] memory totalBookIssued = libraryInstance.booksIssuedByUser(
            student1
        );

        require(totalBookIssued.length == 1, "Something went wrong!");
        assertEq(libraryInstance.booksIssuedByUser(student1)[0], 2);
    }
}
