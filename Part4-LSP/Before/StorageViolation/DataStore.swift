import Foundation

// ❌ THE CONTRACT (Promising too much)
protocol DataStore {
    func save(data: String, key: String)
    func load(key: String) -> String?
}
