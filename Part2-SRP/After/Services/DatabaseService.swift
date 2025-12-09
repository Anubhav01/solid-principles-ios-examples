import UIKit
import CoreData

// MARK: - Persistence Responsibility
protocol DatabaseServiceProtocol {
    func saveUser(json: [String: Any])
}

class DatabaseService: DatabaseServiceProtocol {
    func saveUser(json: [String: Any]) {
        // Note: In a real app, inject the Context, don't use AppDelegate directly
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "UserProfile", in: context) else { return }
        let userObj = NSManagedObject(entity: entity, insertInto: context)
        
        userObj.setValue(json["full_name"], forKey: "name")
        userObj.setValue(json["email"], forKey: "email")
        
        do {
            try context.save()
            print("Saved to Core Data")
        } catch {
            print("Failed to save")
        }
    }
}
