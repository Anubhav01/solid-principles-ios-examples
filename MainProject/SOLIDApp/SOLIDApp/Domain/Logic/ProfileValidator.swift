import Foundation

struct ProfileValidator {
    private let minNameLength = 3
    private let maxNameLength = 50
    private let maxEmailLength = 100
    private let maxBioLength = 500
    
    func validate(name: String) throws {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ValidationError.nameEmpty }
        guard trimmed.count >= minNameLength else {
            throw ValidationError.nameTooShort(min: minNameLength)
        }
        guard trimmed.count <= maxNameLength else {
            throw ValidationError.nameTooLong(max: maxNameLength)
        }
    }
    
    func validate(email: String) throws {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ValidationError.emailEmpty }
        guard trimmed.count <= maxEmailLength else {
            throw ValidationError.emailTooLong(max: maxEmailLength)
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        guard emailPred.evaluate(with: trimmed) else {
            throw ValidationError.invalidEmail
        }
    }
    
    func validate(bio: String) throws {
        guard bio.count <= maxBioLength else {
            throw ValidationError.bioTooLong(max: maxBioLength)
        }
    }
}

enum ValidationError: LocalizedError {
    case nameEmpty
    case nameTooShort(min: Int)
    case nameTooLong(max: Int)
    case emailEmpty
    case invalidEmail
    case emailTooLong(max: Int)
    case bioTooLong(max: Int)
    
    var errorDescription: String? {
        switch self {
        case .nameEmpty: return "Name cannot be empty"
        case .nameTooShort(let min): return "Name must be at least \(min) characters"
        case .nameTooLong(let max): return "Name cannot exceed \(max) characters"
        case .emailEmpty: return "Email cannot be empty"
        case .invalidEmail: return "Please enter a valid email address"
        case .emailTooLong(let max): return "Email cannot exceed \(max) characters"
        case .bioTooLong(let max): return "Bio cannot exceed \(max) characters"
        }
    }
}
