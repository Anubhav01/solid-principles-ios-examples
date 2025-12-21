import XCTest
@testable import SOLIDApp

class ProfileViewModelTests: XCTestCase {
    var viewModel: ProfileViewModel!
    var mockAPI: MockAPIService!
    var mockDB: MockDatabaseService!
    
    override func setUp() {
        super.setUp()
        mockAPI = MockAPIService()
        mockDB = MockDatabaseService()
        viewModel = ProfileViewModel(apiService: mockAPI, dbService: mockDB)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        mockDB = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_init_setsIdleState() {
        if case .idle = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Initial state should be .idle, got \(viewModel.state)")
        }
    }
    
    func test_init_profileDataIsNil() {
        XCTAssertNil(viewModel.profileData)
    }
    
    // MARK: - Load Profile Success Tests
    
    func test_loadUserProfile_success_transitionsToLoadedState() {
        let expectation = expectation(description: "State transitions")
        var stateChanges: [String] = []
        
        viewModel.onStateChanged = { state in
            switch state {
            case .loading: stateChanges.append("loading")
            case .loaded:
                stateChanges.append("loaded")
                expectation.fulfill()
            default: break
            }
        }
        
        mockAPI.mockProfileDTO = UserProfileDTO(fullName: "Alice", email: "alice@test.com", bio: "Dev")
        viewModel.loadUserProfile()
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(stateChanges, ["loading", "loaded"])
    }
    
    func test_loadUserProfile_success_updatesProfileData() {
        let expectation = expectation(description: "Load profile")
        
        viewModel.onStateChanged = { state in
            if case .loaded = state { expectation.fulfill() }
        }
        
        mockAPI.mockProfileDTO = UserProfileDTO(fullName: "Alice", email: "alice@test.com", bio: "Developer")
        viewModel.loadUserProfile()
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(viewModel.profileData?.fullName, "Alice")
        XCTAssertEqual(viewModel.profileData?.email, "alice@test.com")
        XCTAssertEqual(viewModel.profileData?.bio, "Developer")
    }
    
    func test_loadUserProfile_success_savesToDatabase() {
        let expectation = expectation(description: "Load profile")
        
        viewModel.onStateChanged = { state in
            if case .loaded = state { expectation.fulfill() }
        }
        
        mockAPI.mockProfileDTO = UserProfileDTO(fullName: "Bob", email: "bob@test.com", bio: "Designer")
        viewModel.loadUserProfile()
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertTrue(mockDB.saveUserCallCount > 0)
        XCTAssertEqual(mockDB.lastSavedUser?.fullName, "Bob")
        XCTAssertEqual(mockDB.lastSavedUser?.email, "bob@test.com")
    }
    
    func test_loadUserProfile_success_triggersOnDataLoadedCallback() {
        let loadExpectation = expectation(description: "Load")
        let dataExpectation = expectation(description: "Data callback")
        
        var callbackData: UserProfileDTO?
        viewModel.onDataLoaded = { data in
            callbackData = data
            dataExpectation.fulfill()
        }
        
        viewModel.onStateChanged = { state in
            if case .loaded = state { loadExpectation.fulfill() }
        }
        
        mockAPI.mockProfileDTO = UserProfileDTO(fullName: "Charlie", email: "charlie@test.com", bio: nil)
        viewModel.loadUserProfile()
        
        wait(for: [loadExpectation, dataExpectation], timeout: 1.0)
        
        XCTAssertNotNil(callbackData)
        XCTAssertEqual(callbackData?.fullName, "Charlie")
    }
    
    func test_loadUserProfile_databaseFailure_doesNotAffectSuccessState() {
        let expectation = expectation(description: "Load profile")
        
        viewModel.onStateChanged = { state in
            if case .loaded = state { expectation.fulfill() }
        }
        
        mockAPI.mockProfileDTO = UserProfileDTO(fullName: "Dave", email: "dave@test.com", bio: "Manager")
        mockDB.errorToReturn = .saveFailed(NSError(domain: "DB", code: -1))
        
        viewModel.loadUserProfile()
        waitForExpectations(timeout: 1.0)
        
        if case .loaded = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("State should be .loaded despite DB failure")
        }
        XCTAssertEqual(viewModel.profileData?.fullName, "Dave")
    }
    
    // MARK: - Load Profile Failure Tests
    
    func test_loadUserProfile_networkError_setsErrorState() {
        let expectation = expectation(description: "Network error")
        
        viewModel.onStateChanged = { state in
            if case .error = state { expectation.fulfill() }
        }
        
        mockAPI.errorToReturn = .networkError(NSError(domain: "Network", code: -1009))
        viewModel.loadUserProfile()
        
        waitForExpectations(timeout: 1.0)
        
        guard case .error(let message) = viewModel.state else {
            XCTFail("State should be .error")
            return
        }
        XCTAssertFalse(message.isEmpty)
    }
    
    func test_loadUserProfile_failure_doesNotUpdateProfileData() {
        let expectation = expectation(description: "API failure")
        
        viewModel.onStateChanged = { state in
            if case .error = state { expectation.fulfill() }
        }
        
        mockAPI.errorToReturn = .missingToken
        viewModel.loadUserProfile()
        
        waitForExpectations(timeout: 1.0)
        XCTAssertNil(viewModel.profileData)
    }
    
    func test_loadUserProfile_failure_doesNotSaveToDatabase() {
        let expectation = expectation(description: "API failure")
        
        viewModel.onStateChanged = { state in
            if case .error = state { expectation.fulfill() }
        }
        
        mockAPI.errorToReturn = .httpError(statusCode: 500)
        viewModel.loadUserProfile()
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockDB.saveUserCallCount, 0)
    }
    
    // MARK: - Validate and Save - Validation Failures
    
    func test_validateAndSave_emptyName_setsErrorState() {
        viewModel.validateAndSave(name: "", email: "test@test.com", bio: "Bio")
        
        guard case .error(let message) = viewModel.state else {
            XCTFail("State should be .error")
            return
        }
        XCTAssertTrue(message.contains("required") || message.contains("empty") || message.contains("fill"))
    }
    
    func test_validateAndSave_nilName_setsErrorState() {
        viewModel.validateAndSave(name: nil, email: "test@test.com", bio: "Bio")
        
        guard case .error = viewModel.state else {
            XCTFail("State should be .error")
            return
        }
    }
    
    func test_validateAndSave_whitespaceOnlyName_setsErrorState() {
        viewModel.validateAndSave(name: "   ", email: "test@test.com", bio: "Bio")
        
        guard case .error = viewModel.state else {
            XCTFail("State should be .error")
            return
        }
    }
    
    func test_validateAndSave_nameTooShort_setsErrorState() {
        viewModel.validateAndSave(name: "AB", email: "test@test.com", bio: "Bio")
        
        guard case .error(let message) = viewModel.state else {
            XCTFail("State should be .error")
            return
        }
        XCTAssertTrue(message.contains("3") || message.contains("short"))
    }
    
    func test_validateAndSave_nameTooLong_setsErrorState() {
        let longName = String(repeating: "a", count: 51)
        viewModel.validateAndSave(name: longName, email: "test@test.com", bio: "Bio")
        
        guard case .error(let message) = viewModel.state else {
            XCTFail("State should be .error")
            return
        }
        XCTAssertTrue(message.contains("50") || message.contains("long") || message.contains("exceed"))
    }
    
    func test_validateAndSave_invalidEmailFormat_setsErrorState() {
        viewModel.validateAndSave(name: "Valid Name", email: "not-an-email", bio: "Bio")
        
        guard case .error(let message) = viewModel.state else {
            XCTFail("State should be .error")
            return
        }
        XCTAssertTrue(message.contains("email") || message.contains("valid"))
    }
    
    func test_validateAndSave_bioTooLong_setsErrorState() {
        let longBio = String(repeating: "a", count: 501)
        viewModel.validateAndSave(name: "Valid Name", email: "valid@test.com", bio: longBio)
        
        guard case .error(let message) = viewModel.state else {
            XCTFail("State should be .error")
            return
        }
        XCTAssertTrue(message.contains("500") || message.contains("long") || message.contains("exceed"))
    }
    
    func test_validateAndSave_validationError_doesNotCallAPI() {
        viewModel.validateAndSave(name: "", email: "test@test.com", bio: "Bio")
        XCTAssertEqual(mockAPI.updateProfileCallCount, 0)
    }
    
    // MARK: - Validate and Save - Success Cases
    
    func test_validateAndSave_validInput_transitionsToSavedState() {
        let expectation = expectation(description: "Save profile")
        
        viewModel.onStateChanged = { state in
            if case .saved = state { expectation.fulfill() }
        }
        
        viewModel.validateAndSave(name: "John Doe", email: "john@test.com", bio: "Engineer")
        
        waitForExpectations(timeout: 1.0)
        
        guard case .saved = viewModel.state else {
            XCTFail("State should be .saved")
            return
        }
    }
    
    func test_validateAndSave_validInput_callsAPIWithCorrectData() {
        let expectation = expectation(description: "Save profile")
        
        viewModel.onStateChanged = { state in
            if case .saved = state { expectation.fulfill() }
        }
        
        viewModel.validateAndSave(name: "Jane Smith", email: "jane@test.com", bio: "PM")
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(mockAPI.updateProfileCallCount, 1)
        XCTAssertEqual(mockAPI.lastUpdateData?.fullName, "Jane Smith")
        XCTAssertEqual(mockAPI.lastUpdateData?.email, "jane@test.com")
        XCTAssertEqual(mockAPI.lastUpdateData?.bio, "PM")
    }
    
    func test_validateAndSave_validInput_updatesProfileData() {
        let expectation = expectation(description: "Save profile")
        
        viewModel.onStateChanged = { state in
            if case .saved = state { expectation.fulfill() }
        }
        
        viewModel.validateAndSave(name: "Bob Builder", email: "bob@test.com", bio: "Can we fix it?")
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(viewModel.profileData?.fullName, "Bob Builder")
        XCTAssertEqual(viewModel.profileData?.email, "bob@test.com")
        XCTAssertEqual(viewModel.profileData?.bio, "Can we fix it?")
    }
    
    func test_validateAndSave_nilBio_usesEmptyString() {
        let expectation = expectation(description: "Save profile")
        
        viewModel.onStateChanged = { state in
            if case .saved = state { expectation.fulfill() }
        }
        
        viewModel.validateAndSave(name: "No Bio", email: "nobio@test.com", bio: nil)
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockAPI.lastUpdateData?.bio, "")
    }
    
    func test_validateAndSave_emptyBio_isAllowed() {
        let expectation = expectation(description: "Save profile")
        
        viewModel.onStateChanged = { state in
            if case .saved = state { expectation.fulfill() }
        }
        
        viewModel.validateAndSave(name: "Empty Bio", email: "empty@test.com", bio: "")
        
        waitForExpectations(timeout: 1.0)
        
        guard case .saved = viewModel.state else {
            XCTFail("Empty bio should be allowed")
            return
        }
    }
    
    func test_validateAndSave_trimsWhitespace() {
        let expectation = expectation(description: "Save profile")
        
        viewModel.onStateChanged = { state in
            if case .saved = state { expectation.fulfill() }
        }
        
        viewModel.validateAndSave(name: "  Padded  ", email: "  pad@test.com  ", bio: "  Bio  ")
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(mockAPI.lastUpdateData?.fullName, "Padded")
        XCTAssertEqual(mockAPI.lastUpdateData?.email, "pad@test.com")
        XCTAssertEqual(mockAPI.lastUpdateData?.bio, "Bio")
    }
    
    // MARK: - Validate and Save - API Failures
    
    func test_validateAndSave_apiFailure_setsErrorState() {
        let expectation = expectation(description: "API failure")
        
        viewModel.onStateChanged = { state in
            if case .error = state { expectation.fulfill() }
        }
        
        mockAPI.errorToReturn = .networkError(NSError(domain: "Test", code: -1))
        viewModel.validateAndSave(name: "Test", email: "test@test.com", bio: "Bio")
        
        waitForExpectations(timeout: 1.0)
        
        guard case .error = viewModel.state else {
            XCTFail("State should be .error")
            return
        }
    }
    
    func test_validateAndSave_apiFailure_doesNotUpdateProfileData() {
        let expectation = expectation(description: "API failure")
        let originalData = viewModel.profileData
        
        viewModel.onStateChanged = { state in
            if case .error = state { expectation.fulfill() }
        }
        
        mockAPI.errorToReturn = .httpError(statusCode: 500)
        viewModel.validateAndSave(name: "Test", email: "test@test.com", bio: "Bio")
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(viewModel.profileData?.fullName, originalData?.fullName)
    }
}
