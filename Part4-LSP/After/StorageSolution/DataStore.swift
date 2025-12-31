import Foundation

// ✅ 1. Segregate the Responsibilities
protocol Readable {
    func load(key: String) -> String?
}

protocol Writable {
    func save(data: String, key: String)
}

// A helper for things that can do BOTH
typealias FullDataStore = Readable & Writable
