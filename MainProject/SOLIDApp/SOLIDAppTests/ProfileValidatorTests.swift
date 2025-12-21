import XCTest
@testable import SOLIDApp


class ProfileValidatorTests: XCTestCase {
    var validator: ProfileValidator!
    
    override func setUp() {
        super.setUp()
        validator = ProfileValidator()
    }
    
    override func tearDown() {
        validator = nil
        super.tearDown()
    }
    
    // MARK: - Name Validation Tests
    
    func test_validateName_validInput_noError() {
        XCTAssertNoThrow(try validator.validate(name: "John Doe"))
    }
    
    func test_validateName_minLengthBoundary_noError() {
        XCTAssertNoThrow(try validator.validate(name: "Bob"))
    }
    
    func test_validateName_maxLengthBoundary_noError() {
        let name = String(repeating: "a", count: 50)
        XCTAssertNoThrow(try validator.validate(name: name))
    }
    
    func test_validateName_tooShort_throwsError() {
        XCTAssertThrowsError(try validator.validate(name: "Jo")) { error in
            XCTAssertEqual(error as? ValidationError, .nameTooShort(min: 3))
        }
    }
    
    func test_validateName_oneCharacter_throwsError() {
        XCTAssertThrowsError(try validator.validate(name: "J")) { error in
            XCTAssertEqual(error as? ValidationError, .nameTooShort(min: 3))
        }
    }
    
    func test_validateName_tooLong_throwsError() {
        let name = String(repeating: "a", count: 51)
        XCTAssertThrowsError(try validator.validate(name: name)) { error in
            XCTAssertEqual(error as? ValidationError, .nameTooLong(max: 50))
        }
    }
    
    func test_validateName_empty_throwsError() {
        XCTAssertThrowsError(try validator.validate(name: "")) { error in
            XCTAssertEqual(error as? ValidationError, .nameEmpty)
        }
    }
    
    func test_validateName_whitespaceOnly_throwsError() {
        XCTAssertThrowsError(try validator.validate(name: "   ")) { error in
            XCTAssertEqual(error as? ValidationError, .nameEmpty)
        }
    }
    
    func test_validateName_tabsAndSpaces_throwsError() {
        XCTAssertThrowsError(try validator.validate(name: "\t  \n  ")) { error in
            XCTAssertEqual(error as? ValidationError, .nameEmpty)
        }
    }
    
    func test_validateName_withLeadingTrailingSpaces_noError() {
        XCTAssertNoThrow(try validator.validate(name: "  John Doe  "))
    }
    
    func test_validateName_withNumbers_noError() {
        XCTAssertNoThrow(try validator.validate(name: "John123"))
    }
    
    func test_validateName_withApostrophe_noError() {
        XCTAssertNoThrow(try validator.validate(name: "O'Brien"))
    }
    
    func test_validateName_withHyphen_noError() {
        XCTAssertNoThrow(try validator.validate(name: "Mary-Jane"))
    }
    
    func test_validateName_withSpecialCharacters_noError() {
        XCTAssertNoThrow(try validator.validate(name: "José María"))
    }
    
    // MARK: - Email Validation Tests
    
    func test_validateEmail_validInput_noError() {
        XCTAssertNoThrow(try validator.validate(email: "john@example.com"))
    }
    
    func test_validateEmail_validWithSubdomain_noError() {
        XCTAssertNoThrow(try validator.validate(email: "user@mail.example.com"))
    }
    
    func test_validateEmail_validWithPlus_noError() {
        XCTAssertNoThrow(try validator.validate(email: "user+tag@example.com"))
    }
    
    func test_validateEmail_validWithDots_noError() {
        XCTAssertNoThrow(try validator.validate(email: "first.last@example.com"))
    }
    
    func test_validateEmail_validWithNumbers_noError() {
        XCTAssertNoThrow(try validator.validate(email: "user123@example.com"))
    }
    
    func test_validateEmail_maxLengthBoundary_noError() {
        let localPart = String(repeating: "a", count: 85)
        let email = "\(localPart)@example.com"
        XCTAssertNoThrow(try validator.validate(email: email))
    }
    
    func test_validateEmail_tooLong_throwsError() {
        // Create email with 101 characters (one over max)
        // Need: localPart + "@example.com" = 101
        // "@example.com" = 12 characters
        // So localPart needs to be 89 characters
        let localPart = String(repeating: "a", count: 89)
        let email = "\(localPart)@example.com" // 89 + 12 = 101 chars
        XCTAssertThrowsError(try validator.validate(email: email)) { error in
            XCTAssertEqual(error as? ValidationError, .emailTooLong(max: 100))
        }
    }
    
    func test_validateEmail_empty_throwsError() {
        XCTAssertThrowsError(try validator.validate(email: "")) { error in
            XCTAssertEqual(error as? ValidationError, .emailEmpty)
        }
    }
    
    func test_validateEmail_whitespaceOnly_throwsError() {
        XCTAssertThrowsError(try validator.validate(email: "   ")) { error in
            XCTAssertEqual(error as? ValidationError, .emailEmpty)
        }
    }
    
    func test_validateEmail_missingAtSymbol_throwsError() {
        XCTAssertThrowsError(try validator.validate(email: "johnexample.com")) { error in
            XCTAssertEqual(error as? ValidationError, .invalidEmail)
        }
    }
    
    func test_validateEmail_multipleAtSymbols_throwsError() {
        XCTAssertThrowsError(try validator.validate(email: "john@@example.com")) { error in
            XCTAssertEqual(error as? ValidationError, .invalidEmail)
        }
    }
    
    func test_validateEmail_missingLocalPart_throwsError() {
        XCTAssertThrowsError(try validator.validate(email: "@example.com")) { error in
            XCTAssertEqual(error as? ValidationError, .invalidEmail)
        }
    }
    
    func test_validateEmail_missingDomain_throwsError() {
        XCTAssertThrowsError(try validator.validate(email: "john@")) { error in
            XCTAssertEqual(error as? ValidationError, .invalidEmail)
        }
    }
    
    func test_validateEmail_missingTLD_throwsError() {
        XCTAssertThrowsError(try validator.validate(email: "john@example")) { error in
            XCTAssertEqual(error as? ValidationError, .invalidEmail)
        }
    }
    
    func test_validateEmail_withSpaces_throwsError() {
        XCTAssertThrowsError(try validator.validate(email: "john @example.com")) { error in
            XCTAssertEqual(error as? ValidationError, .invalidEmail)
        }
    }
    
    func test_validateEmail_withLeadingTrailingSpaces_noError() {
        XCTAssertNoThrow(try validator.validate(email: "  john@example.com  "))
    }
    
    // MARK: - Bio Validation Tests
    
    func test_validateBio_validInput_noError() {
        XCTAssertNoThrow(try validator.validate(bio: "This is my bio"))
    }
    
    func test_validateBio_empty_noError() {
        XCTAssertNoThrow(try validator.validate(bio: ""))
    }
    
    func test_validateBio_maxLengthBoundary_noError() {
        let bio = String(repeating: "a", count: 500)
        XCTAssertNoThrow(try validator.validate(bio: bio))
    }
    
    func test_validateBio_tooLong_throwsError() {
        let bio = String(repeating: "a", count: 501)
        XCTAssertThrowsError(try validator.validate(bio: bio)) { error in
            XCTAssertEqual(error as? ValidationError, .bioTooLong(max: 500))
        }
    }
    
    func test_validateBio_wayTooLong_throwsError() {
        let bio = String(repeating: "a", count: 1000)
        XCTAssertThrowsError(try validator.validate(bio: bio)) { error in
            XCTAssertEqual(error as? ValidationError, .bioTooLong(max: 500))
        }
    }
    
    func test_validateBio_withSpecialCharacters_noError() {
        XCTAssertNoThrow(try validator.validate(bio: "Hello! 👋 I'm a developer 💻"))
    }
    
    func test_validateBio_withNewlines_noError() {
        XCTAssertNoThrow(try validator.validate(bio: "Line 1\nLine 2\nLine 3"))
    }
    
    func test_validateBio_withMultipleSpaces_noError() {
        XCTAssertNoThrow(try validator.validate(bio: "Text    with    spaces"))
    }
}
