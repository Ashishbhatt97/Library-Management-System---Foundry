// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract LibraryManagement {
    uint256 public userCount = 0;
    address public owner;
    uint256 public booksCount = 0;

    constructor() {
        owner = msg.sender; 
    }

    enum Role {
        Admin,
        Member,
        Librarian
    }

    enum Gender {
        Male,
        Female,
        Other
    }

    struct Book {
        uint256 bookId;
        string title;
        string authorName;
        string publisher;
        string publicationDate;
        string category;
        uint256 copiesAvailable;
    }

    struct User {
        string userName;
        uint256 userId;
        Role userRole;
        Gender userGender;
        string email;
        uint256 numberOfBookIssued;
        mapping(uint256 => Book) bookIssued;
    }

    mapping(address => User) public users;
    mapping(uint256 => Book) public books;

    event UserAdded(uint256 userId, string name, string email);
    event BookAdded(string title, string authorName, uint256 copiesAvailable);
    event BookIssued(address userAddress, uint256 bookId, string title);
    event issuedBooksByUser(uint256 userId, uint256[] bookIds);

    modifier onlyOwner() {
        require(owner == msg.sender, "You cannot make these changes!");
        _;
    }

    function addUser(string memory _userName, string memory _email) public {
        userCount++;

        User storage newUser = users[msg.sender];
        newUser.userName = _userName;
        newUser.userId = userCount;
        newUser.userRole = Role.Member;
        newUser.userGender = Gender.Male;
        newUser.email = _email;
        newUser.numberOfBookIssued = 0;

        emit UserAdded(userCount, _userName, _email);
    }

    function addBook(
        string memory _title,
        string memory _authorName,
        string memory _publisher,
        string memory _publicationDate,
        string memory _category,
        uint256 _copiesAvailable
    ) public onlyOwner {
        booksCount++;

        books[booksCount] = Book({
            bookId: booksCount,
            title: _title,
            authorName: _authorName,
            publisher: _publisher,
            publicationDate: _publicationDate,
            category: _category,
            copiesAvailable: _copiesAvailable
        });

        emit BookAdded(_title, _authorName, _copiesAvailable);
    }

    function bookIssue(uint256 _bookId, address userAddress) public onlyOwner {
        require(books[_bookId].copiesAvailable > 0, "No more copies available");

        User storage user = users[userAddress];
        require(user.numberOfBookIssued < 5, "You cannot take more than 5 books");

        uint256 booksIssuedIndex = user.numberOfBookIssued;
        user.bookIssued[booksIssuedIndex] = books[_bookId];

        user.numberOfBookIssued++;
        books[_bookId].copiesAvailable--;

        emit BookIssued(userAddress, _bookId, books[_bookId].title);
    }

    function booksIssuedByUser(address _userAddress) public onlyOwner returns (uint256[] memory) {
        User storage user = users[_userAddress];
        uint256[] memory issuedBooks = new uint256[](user.numberOfBookIssued);

        for (uint256 i = 0; i < user.numberOfBookIssued; i++) {
            issuedBooks[i] = user.bookIssued[i].bookId;
        }
        emit issuedBooksByUser(user.userId, issuedBooks);
        return issuedBooks;
    }
}
