import Foundation

// 3. The Context (Closed for Modification)
// This class NEVER needs to change, even if we add 50 new login methods.
class AuthenticationService {
    
    private let strategy: AuthStrategy
    
    // We inject the behavior we want!
    init(strategy: AuthStrategy) {
        self.strategy = strategy
    }
    
    func authenticate(credentials: [String: String]) {
        strategy.login(credentials: credentials) { result in
            switch result {
            case .success(let user):
                print("✅ Login Successful: \(user.name)")
            case .failure(let error):
                print("❌ Login Failed: \(error.localizedDescription)")
            }
        }
    }
}
