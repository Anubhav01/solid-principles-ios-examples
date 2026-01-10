import Foundation

// 🧠 High-Level Module
class UserProfileManager {
    
    // ✅ The Manager now depends on the Protocol (Abstraction)
    // It has no idea what "CoreData" is.
    private let storage: StorageService
    
    // Dependency Injection: "Give me anything that acts like a StorageService"
    init(storage: StorageService) {
        self.storage = storage
    }
    
    func changeUserName(to newName: String) {
        guard !newName.isEmpty else { return }
        
        storage.save(userName: newName)
        print("✅ UserProfileManager: Request forwarded to storage.")
    }
}
