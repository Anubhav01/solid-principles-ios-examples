import Foundation

// 3. The Client (The code that crashes)
class DataManager {
    let stores: [DataStore]
    
    init(stores: [DataStore]) {
        self.stores = stores
    }
    
    func saveAll() {
        // The compiler lets us do this, but the runtime will crash.
        // We cannot "Substitute" BundleHandler for DataStore safely.
        for store in stores {
            store.save(data: "Backup", key: "backup_key")
        }
    }
}
