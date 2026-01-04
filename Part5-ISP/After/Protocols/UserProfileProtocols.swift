import Foundation

// ✅ SOLUTION: Segregated Interfaces
// Break the large protocol into specific "Roles".

protocol UserNameUpdateDelegate: AnyObject {
    func didUpdateName(_ name: String)
}

protocol UserBioUpdateDelegate: AnyObject {
    func didUpdateBio(_ bio: String)
}

protocol AccountSecurityActionsDelegate: AnyObject {
    func didChangePassword()
    func didRequestAccountDeletion()
}

protocol ProfileImageUploadDelegate: AnyObject {
    func didUploadProfilePicture(url: URL)
}
