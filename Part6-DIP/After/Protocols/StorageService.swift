import Foundation

// ✅ SOLUTION: The Abstraction
// The High-Level module defines the interface it needs.
protocol StorageService {
    func save(userName: String)
}
