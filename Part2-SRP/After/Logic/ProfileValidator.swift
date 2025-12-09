import Foundation

// MARK: - Validation Responsibility
struct ProfileValidator {
    
    func validate(name: String) throws {
        if name.count < 3 {
            throw ValidationError.nameTooShort
        }
    }
    
    func validate(email: String) throws {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            throw ValidationError.invalidEmail
        }
    }
    
    func validate(bio: String) throws {
        if bio.contains("swear_word") {
            throw ValidationError.politenessError
        }
    }
}

enum ValidationError: LocalizedError {
    case nameTooShort
    case invalidEmail
    case politenessError
    
    var errorDescription: String? {
        switch self {
        case .nameTooShort: return "Name is too short"
        case .invalidEmail: return "Email is invalid"
        case .politenessError: return "Please be polite"
        }
    }
}
