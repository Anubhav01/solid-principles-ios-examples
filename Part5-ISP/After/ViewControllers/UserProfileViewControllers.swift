import UIKit

// ✅ 2. The Complex Screen
// This VC handles multiple responsibilities (Composition).
// We compose protocols together like LEGO bricks.
class ProfileSettingsViewController: UIViewController, UserNameUpdateDelegate, UserBioUpdateDelegate, AccountSecurityActionsDelegate {
    
    func didUpdateName(_ name: String) {
        print("Name updated")
    }
    
    func didUpdateBio(_ bio: String) {
        print("Bio updated")
    }
    
    func didChangePassword() {
        print("Password changed")
    }
    
    func didRequestAccountDeletion() {
        print("Account deleted")
    }
}
