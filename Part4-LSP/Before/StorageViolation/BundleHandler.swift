import Foundation

// 2. Broken Implementation (Violates LSP)
class BundleHandler: DataStore {
    func load(key: String) -> String? {
        // Simulate loading from a file in the Bundle
        return "Default Config"
    }
    
    // ⚠️ THE TRAP:
    // This class CANNOT fulfill the contract of "saving",
    // so it forces a crash or does nothing.
    // This breaks the "Substitution" rule.
    func save(data: String, key: String) {
        fatalError("❌ CRITICAL ERROR: Cannot save to Read-Only Bundle!")
    }
}
