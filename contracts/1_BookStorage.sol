// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/**
 * @title Storage
 * @dev Add & retrieve books
 */
contract BookStorage {

    struct Book {
        string title;
        uint copies;
        uint availableCount;
        bool exists;
    }

    Book[] private books;

    mapping(uint => bool) private availability;

    /**
     * @dev Set book availability 
     * @param _bookId the id of the book
     */
    function setIsAvailable(uint _bookId) private {
        availability[_bookId] = books[_bookId].availableCount > 0;
    }

    /**
     * @dev Add a book
     * @param _title book title
     * @param _count book copies
     * @return uint index of the added book
     */
    function add(string memory _title, uint _count) public returns (uint) {
        require(bytes(_title).length > 0, "Missing book title.");
        require(_count > 0, "Missing book copies count.");
        books.push(Book(_title, _count, _count, true));
        uint id = books.length - 1;
        setIsAvailable(id);
        return id;
    }

    /**
     * @dev Increase book availability 
     * @param _bookId the id of the book
     * @return uint book availability count
     */
    function incAvailability(uint _bookId) public returns (uint) {
        require(books[_bookId].exists, "Book not exists.");
        require(books[_bookId].availableCount < books[_bookId].copies, "All copies have been returned.");
        books[_bookId].availableCount++;
        setIsAvailable(_bookId);
        return books[_bookId].availableCount;
    }

    /**
     * @dev Decrease book availability
     * @param _bookId the id of the book
     * @return uint book availability count
     */
    function decAvailability(uint _bookId) public returns (uint) {
        require(books[_bookId].exists, "Book not exists.");
        require(books[_bookId].availableCount > 0, "Book not available.");
        books[_bookId].availableCount--;
        setIsAvailable(_bookId);
        return books[_bookId].availableCount;
    }

    /**
     * @dev Return all available books 
     * @return value of 'uint[]'
     */
    function getAvailability() public view returns (uint[] memory) {
        uint booksCount = books.length;
        require(booksCount > 0, "There are no books.");
        uint[] memory result = new uint[](booksCount);
        for(uint i = 0 ; i < booksCount; i++) {
            result[i] = books[i].availableCount;
        }
        return result;
    }
}