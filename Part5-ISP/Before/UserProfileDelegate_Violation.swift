
import UIKit

// ❌ VIOLATION: The "Fat" Interface
// This protocol has grown too large. It forces any delegate to know about
// names, passwords, photos, and even deletion.
protocol UserProfileDelegate: AnyObject {
    func didUpdateName(_ name: String)
    func didUpdateBio(_ bio: String)
    func didChangePassword()
    func didUploadProfilePicture(url: URL)
    func didRequestAccountDeletion()
}

// ⚠️ The Victim Client
// This ViewController ONLY handles the Name.
// Yet, it is forced to implement 4 other empty methods to satisfy the compiler.
class NameEditorViewController: UIViewController, UserProfileDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    
    func didUpdateName(_ name: String) {
        print("✅ Name updated to: \(name)")
        nameLabel.text = name
    }
    
    // 🗑️ POLLUTION: Empty methods required by the protocol
    func didUpdateBio(_ bio: String) {
        // Not used here
    }
    
    func didChangePassword() {
        // Not used here
    }
    
    func didUploadProfilePicture(url: URL) {
        // Not used here
    }
    
    func didRequestAccountDeletion() {
        // Not used here
    }
}
