import XCTest
@testable import SOLIDApp

class MockAPIService: APIServiceProtocol {
    // Configuration
    var errorToReturn: APIError?
    var mockProfileDTO: UserProfileDTO?
    var simulateDelay: TimeInterval = 0
    
    // Spies
    private(set) var fetchProfileCallCount = 0
    private(set) var updateProfileCallCount = 0
    private(set) var lastUpdateData: UserProfileDTO?
    
    func reset() {
        errorToReturn = nil
        mockProfileDTO = nil
        simulateDelay = 0
        fetchProfileCallCount = 0
        updateProfileCallCount = 0
        lastUpdateData = nil
    }
    
    func fetchProfile(completion: @escaping (Result<UserProfileDTO, APIError>) -> Void) {
        fetchProfileCallCount += 1
        
        executeWithDelay {
            if let error = self.errorToReturn {
                completion(.failure(error))
            } else {
                let dto = self.mockProfileDTO ?? UserProfileDTO(
                    fullName: "Test User",
                    email: "test@example.com",
                    bio: "Test bio"
                )
                completion(.success(dto))
            }
        }
    }
    
    func updateProfile(data: UserProfileDTO, completion: @escaping (Result<UserProfileDTO, APIError>) -> Void) {
        updateProfileCallCount += 1
        lastUpdateData = data
        
        executeWithDelay {
            if let error = self.errorToReturn {
                completion(.failure(error))
            } else {
                completion(.success(data))
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
