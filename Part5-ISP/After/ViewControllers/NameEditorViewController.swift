import UIKit

// ✅ 1. The Simple Screen
// This VC only needs to listen to Name updates. It knows nothing about passwords or photos.
class NameEditorViewController: UIViewController, UserNameUpdateDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func didUpdateName(_ name: String) {
        print("✅ Name updated to: \(name)")
        nameLabel.text = name
    }
}

