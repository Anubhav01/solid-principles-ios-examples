import Foundation

// 1. Working Implementation (Satisfies LSP)
class UserDefaultsStore: DataStore {
    func save(data: String, key: String) {
        UserDefaults.standard.set(data, forKey: key)
        print("✅ Saved to UserDefaults")
    }
    
    func load(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
