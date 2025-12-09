import Foundation

// MARK: - Business Logic & State Responsibility
class ProfileViewModel {
    
    // Dependencies
    private let apiService: APIServiceProtocol
    private let dbService: DatabaseServiceProtocol
    private let validator: ProfileValidator
    
    // Data Binding (Closures for simplicity, could be Combine/Rx)
    var onDataLoaded: (([String: Any]) -> Void)?
    var onError: ((String) -> Void)?
    
    init(apiService: APIServiceProtocol = APIService(),
         dbService: DatabaseServiceProtocol = DatabaseService(),
         validator: ProfileValidator = ProfileValidator()) {
        self.apiService = apiService
        self.dbService = dbService
        self.validator = validator
    }
    
    func loadUserProfile() {
        apiService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let json):
                // 1. Persist Data
                self.dbService.saveUser(json: json)
                
                // 2. Notify View
                self.onDataLoaded?(json)
                
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func validateAndSave(name: String?, email: String?, bio: String?) {
        guard let name = name, let email = email, let bio = bio else {
            onError?("Missing fields")
            return
        }
        
        do {
            try validator.validate(name: name)
            try validator.validate(email: email)
            try validator.validate(bio: bio)
            // Proceed with API call to update profile...
        } catch {
            onError?(error.localizedDescription)
        }
    }
}
