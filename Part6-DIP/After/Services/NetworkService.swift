import Foundation

// 🧱 Low-Level Module
// This class now conforms to the protocol.
class NetworkService: UserService {
    
    func fetchUsers() -> [String] {
        print("🌍 Network: Fetching from https://api.example.com/users")
        return ["Alice", "Bob", "Charlie"]
    }
}
