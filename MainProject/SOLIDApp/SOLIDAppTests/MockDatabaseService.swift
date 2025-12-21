import XCTest
@testable import SOLIDApp


class MockDatabaseService: DatabaseServiceProtocol {
    // Configuration
    var errorToReturn: DatabaseError?
    var simulateDelay: TimeInterval = 0
    
    // Spies
    private(set) var saveUserCallCount = 0
    private(set) var lastSavedUser: UserProfileDTO?
    private(set) var allSavedUsers: [UserProfileDTO] = []
    
    func reset() {
        errorToReturn = nil
        simulateDelay = 0
        saveUserCallCount = 0
        lastSavedUser = nil
        allSavedUsers.removeAll()
    }
    
    func saveUser(json: UserProfileDTO, completion: @escaping (Result<Void, DatabaseError>) -> Void) {
        saveUserCallCount += 1
        lastSavedUser = json
        allSavedUsers.append(json)
        
        executeWithDelay {
            if let error = self.errorToReturn {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    private func executeWithDelay(_ block: @escaping () -> Void) {
        if simulateDelay > 0 {
            DispatchQueue.global().asyncAfter(deadline: .now() + simulateDelay) {
                block()
            }
        } else {
            block()
        }
    }
}
