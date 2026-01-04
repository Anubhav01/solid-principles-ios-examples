import UIKit

// ✅ 3. Another Simple Screen
// This VC only cares about profile pictures
class AvatarEditorViewController: UIViewController, ProfileImageUploadDelegate {
    
    func didUploadProfilePicture(url: URL) {
        print("✅ Profile picture uploaded: \(url)")
        // Load image from URL
    }
}
