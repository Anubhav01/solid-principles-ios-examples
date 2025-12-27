import Foundation

// 1. The Protocol (Open for Extension)
protocol AuthStrategy {
    func login(credentials: [String: String], completion: @escaping (Result<User, Error>) -> Void)
}

struct User {
    let id: String
    let name: String
}

// 2. Concrete Implementations (We can add infinite strategies without breaking existing code)

class EmailAuthStrategy: AuthStrategy {
    func login(credentials: [String: String], completion: @escaping (Result<User, Error>) -> Void) {
        print("📧 Performing Email Login...")
        // Email specific validation & API call
        completion(.success(User(id: "1", name: "Email User")))
    }
}

class GoogleAuthStrategy: AuthStrategy {
    func login(credentials: [String: String], completion: @escaping (Result<User, Error>) -> Void) {
        print("🌐 Performing Google Login...")
        // Google SDK specific logic
        completion(.success(User(id: "2", name: "Google User")))
    }
}

// ✅ NEW FEATURE: Apple Login (Added without touching EmailAuthStrategy!)
class AppleAuthStrategy: AuthStrategy {
    func login(credentials: [String: String], completion: @escaping (Result<User, Error>) -> Void) {
        print(" Performing Apple Login...")
        completion(.success(User(id: "3", name: "Apple User")))
    }
}
