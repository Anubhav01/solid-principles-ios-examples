import Foundation

// 🧪 Test Double (Mock)
// We use this for Unit Tests to avoid hitting the real database.
class MockStorageService: StorageService {
    
    var savedUserName: String?
    var isSaved = false
    
    func save(userName: String) {
        isSaved = true
        savedUserName = userName
        print("🧪 Mock: Recorded save for '\(userName)'")
    }
}
