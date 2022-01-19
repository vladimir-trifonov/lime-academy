// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../contracts/3_Library.sol";

contract LibraryTest {
   
    Library libraryToTest;
    function beforeAll () public {
        libraryToTest = new Library();
    }
    
    function testCheckBooksAvailabilityWhenNone () public {
        try libraryToTest.getBooksAvailability() {
            Assert.ok(false, "method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "There are no books.", "failed with unexpected reason");
        } catch (bytes memory) {
            Assert.ok(false, "failed unexpected");
        }
    }
    
    function testCheckAddedBookId () public {
        uint id = libraryToTest.addBook("Book Title", 5);
        Assert.equal(id, uint(0), "the added book id should be 0");
    }

    function testAddBookFailureNoTitle () public {
        try libraryToTest.addBook("", 5) {
            Assert.ok(false, "method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Missing book title.", "failed with unexpected reason");
        } catch (bytes memory) {
            Assert.ok(false, "failed unexpected");
        }
    }

    function testAddBookFailureNoCopiesCount () public {
        try libraryToTest.addBook("Book Title", 0) {
            Assert.ok(false, "method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Missing book copies count.", "failed with unexpected reason");
        } catch (bytes memory) {
            Assert.ok(false, "failed unexpected");
        }
    }
    
    function testCheckBooksAvailability () public {
        uint[] memory availableBooks = libraryToTest.getBooksAvailability();
        Assert.equal(availableBooks.length, 1, "the available books count should be 1");
        Assert.equal(availableBooks[0], 5, "the available book should have availability 5");
    }

    function testCheckBorrowedBookAvailability () public {
        libraryToTest.borrowBook(0); uint[] memory availableBooks = libraryToTest.getBooksAvailability();
        Assert.equal(availableBooks.length, 1, "the available books count should be 1");
        Assert.equal(availableBooks[0], 4, "the available book should have availability 4");
        libraryToTest.returnBook(0);
    }
    
    function testCheckBookBorrowers () public {
        address[] memory bookBorrowers = libraryToTest.getBookBorrowers(0);
        Assert.equal(bookBorrowers.length, 1, "the book borrowers count should be 1");
        Assert.equal(bookBorrowers[0], msg.sender, "the first book borrower should match the address");
    }

    function testBorrowAlreadyBorrowedBook () public {
        libraryToTest.borrowBook(0);
        try libraryToTest.borrowBook(0) {
            Assert.ok(false, "method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "You already borrowed the book.", "failed with unexpected reason");
        } catch (bytes memory) {
            Assert.ok(false, "failed unexpected");
        }
        libraryToTest.returnBook(0);
    }

    function testReturnBookNotBorrowed () public {
        try libraryToTest.returnBook(0) {
            Assert.ok(false, "method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "You haven't borrow the book.", "failed with unexpected reason");
        } catch (bytes memory) {
            Assert.ok(false, "failed unexpected");
        }
    }
}
