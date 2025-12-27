import Foundation

// ❌ VIOLATION: This class is NOT closed for modification.
// Every time we add a new login type (e.g., Apple, FaceID), we must modify this file.
class LegacyAuthService {
    
    func login(type: String, credentials: [String: String]) {
        if type == "email" {
            print("Authenticating with Email API...")
            // Complex email logic...
        } else if type == "google" {
            print("Authenticating with Google SDK...")
            // Complex Google logic...
        } else if type == "apple" {
            print("Authenticating with Apple ID...")
            // Complex Apple logic...
        }
    }
}
