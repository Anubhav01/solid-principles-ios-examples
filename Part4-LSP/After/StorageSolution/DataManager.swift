import Foundation

// ✅ 3. The Client is Safe
class DataManager {
    // We explicitly ask for Storage that is WRITABLE
    let writableStores: [Writable]
    let allStores: [Readable]
    
    init(writableStores: [Writable], allStores: [Readable]) {
        self.writableStores = writableStores
        self.allStores = allStores
    }
    
    func saveAll() {
        // Safe: The compiler prevents us from adding BundleHandler here.
        for store in writableStores {
            store.save(data: "Backup", key: "backup_key")
        }
    }
}
