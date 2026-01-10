import XCTest

// 1. The Mock (Fake Service)
class MockUserService: UserService {
    func fetchUsers() -> [String] {
        return ["Mock User 1", "Mock User 2"]
    }
}

// 2. The Test
class UserListViewModelTests: XCTestCase {
    
    func testDataLoading() {
        // Given
        let mock = MockUserService()
        let viewModel = UserListViewModel(service: mock)
        
        // When
        viewModel.loadData()
        
        // Then
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users.first, "Mock User 1")
    }
}
