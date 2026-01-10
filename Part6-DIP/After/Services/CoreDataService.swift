import Foundation

// 🧱 Low-Level Module
// Now this depends on the abstraction (the protocol).
class CoreDataService: StorageService {
    
    func save(userName: String) {
        print("💾 CoreData: Saving '\(userName)' to persistent store...")
    }
}
