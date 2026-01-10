import Foundation

// 🧱 Low-Level Module (The Detail)
// This class handles the specific implementation of saving to a database.
class CoreDataService {
    func save(userName: String) {
        print("💾 CoreData: Saving '\(userName)' to disk...")
        // Actual CoreData boilerplate would go here
    }
}

// 🧠 High-Level Module (The Business Logic)
class UserProfileManager {
    
    // ❌ VIOLATION: Hard Dependency
    // The Manager creates the dependency itself.
    // It is impossible to replace CoreDataService without changing this class.
    // It is impossible to test this class without writing to the real database.
    let database = CoreDataService()
    
    func changeUserName(to newName: String) {
        // Validation logic
        guard !newName.isEmpty else { return }
        
        // Direct call to the low-level module
        database.save(userName: newName)
    }
}
