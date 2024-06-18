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
}
