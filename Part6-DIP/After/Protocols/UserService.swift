import Foundation

// ✅ SOLUTION: The Abstraction
// The ViewModel defines ONLY what it needs: "I need to fetch users."
// It doesn't care if it comes from Network, Database, or a JSON file.
protocol UserService {
    func fetchUsers() -> [String]
}
