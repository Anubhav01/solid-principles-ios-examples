import Foundation

// ✅ 2. Implementations only promise what they can deliver

class UserDefaultsStore: FullDataStore {
    func save(data: String, key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func load(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}

