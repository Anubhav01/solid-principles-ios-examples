import Foundation
import CoreData

enum DatabaseError: LocalizedError {
    case missingContext
    case missingEntity
    case validationFailed(ValidationError)
    case saveFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .missingContext:
            return "Database context not available"
        case .missingEntity:
            return "Database entity not found"
        case .validationFailed(let error):
            return error.localizedDescription
        case .saveFailed(let error):
            return "Failed to save: \(error.localizedDescription)"
        }
    }
}

protocol DatabaseServiceProtocol {
    func saveUser(json: UserProfileDTO, completion: @escaping (Result<Void, DatabaseError>) -> Void)
}

class DatabaseService: DatabaseServiceProtocol {
    private let context: NSManagedObjectContext
    private let validator = ProfileValidator()
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveUser(json: UserProfileDTO, completion: @escaping (Result<Void, DatabaseError>) -> Void) {
        context.perform {
            let fullName = json.fullName
            let email = json.email
            let bio = json.bio
            
            guard let fullName = fullName else {
                completion(.failure(.validationFailed(.nameEmpty)))
                return
            }
            
            guard let email = email else {
                completion(.failure(.validationFailed(.emailEmpty)))
                return
            }
            
            do {
                try self.validator.validate(name: fullName)
                try self.validator.validate(email: email)
                if let bio = bio {
                    try self.validator.validate(bio: bio)
                }
            } catch let validationError as ValidationError {
                completion(.failure(.validationFailed(validationError)))
                return
            } catch {
                completion(.failure(.saveFailed(error)))
                return
            }
            
            guard let entity = NSEntityDescription.entity(forEntityName: "UserProfile", in: self.context) else {
                completion(.failure(.missingEntity))
                return
            }
            
            // NOTE:
            // This is a simplified persistence example for demonstration.
            // In a production app, this operation should be idempotent (upsert)
            // to avoid duplicate records, typically using a stable identifier
            // such as userId or email.
            
            let userObj = NSManagedObject(entity: entity, insertInto: self.context)
            userObj.setValue(fullName, forKey: "name")
            userObj.setValue(email, forKey: "email")
            if let bio = bio {
                userObj.setValue(bio, forKey: "bio")
            }
            
            do {
                try self.context.save()
                completion(.success(()))
            } catch {
                completion(.failure(.saveFailed(error)))
            }
        }
    }
}
