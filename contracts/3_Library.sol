// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./1_BookStorage.sol";
import "./2_Ownable.sol";

contract Library is Ownable {

    BookStorage private bookStorage;

    struct User {
        address id;
        bool exists;
        mapping(uint => bool) borrowed;
    }

    mapping(address => User) private users;
    mapping(uint => address[]) private bookBorrowers;

    event BookAdded(uint _bookId);
    event BookAvailabilityUpdated(uint _bookId, uint _availableCount);

    constructor () {
        bookStorage = new BookStorage();
    }

    /**
     * @dev Add book to the library
     * @param _title address to which vote is delegated
     * @param _count address to which vote is delegated
     * @return uint index of the added book
     */
    function addBook(string memory _title, uint _count) public isOwner returns (uint) {
        uint bookId = bookStorage.add(_title, _count);
        emit BookAdded(bookId);
        return bookId;
    }

    /**
     * @dev User borrows a book
     * @param _bookId id of the book to borrow
     */
    function borrowBook(uint _bookId) public {
        if (!users[msg.sender].exists) {
            users[msg.sender].id = msg.sender;
            users[msg.sender].exists = true;
        }
        require(!users[msg.sender].borrowed[_bookId], "You already borrowed the book.");
        uint count = bookStorage.decAvailability(_bookId);
        users[msg.sender].borrowed[_bookId] = true;
        bookBorrowers[_bookId].push(msg.sender);
        emit BookAvailabilityUpdated(_bookId, count);
    }

    /**
     * @dev User returns a borrowed book
     * @param _bookId id of the book to return
     */
    function returnBook(uint _bookId) public {
        require(users[msg.sender].exists, "User not exists.");
        require(users[msg.sender].borrowed[_bookId], "You haven't borrow the book.");
        uint count = bookStorage.incAvailability(_bookId);
        users[msg.sender].borrowed[_bookId] = false;
        emit BookAvailabilityUpdated(_bookId, count);
    }

    /**
     * @dev Return books availability
     * @return value of 'uint[]'
     */
    function getBooksAvailability() public view returns (uint[] memory) {
        return bookStorage.getAvailability();
    }

    /**
     * @dev Return addresses of all people that have ever borrowed a given book
     * @return value of 'address[]'
     */
    function getBookBorrowers(uint _bookId) public view returns (address[] memory) {
        return bookBorrowers[_bookId];
    }
}
