import Foundation

// ✅ 2. Implementations only promise what they can deliver

class BundleHandler: Readable {
    // Only implements load. No 'save' method exists to be misused.
    func load(key: String) -> String? {
        return "Default Config"
    }
}
