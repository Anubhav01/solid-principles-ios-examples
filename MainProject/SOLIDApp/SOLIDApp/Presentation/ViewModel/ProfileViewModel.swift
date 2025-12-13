import Foundation
 
enum ViewState {
    case idle
    case loading
    case loaded
    case saved
    case error(String)
}

class ProfileViewModel {
    private let apiService: APIServiceProtocol
    private let dbService: DatabaseServiceProtocol
    private let validator: ProfileValidator
    
    private(set) var state: ViewState = .idle {
        didSet { onStateChanged?(state) }
    }
    
    private(set) var profileData: UserProfileDTO? {
        didSet {
            onDataLoaded?(profileData) 
        }
    }
    
    // Bindings
    var onStateChanged: ((ViewState) -> Void)?
    var onDataLoaded: ((UserProfileDTO?) -> Void)?
    
    init(apiService: APIServiceProtocol,
         dbService: DatabaseServiceProtocol,
         validator: ProfileValidator = ProfileValidator()) {
        self.apiService = apiService
        self.dbService = dbService
        self.validator = validator
    }
    
    func loadUserProfile() {
        state = .loading
        
        apiService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let json):
                self.profileData = json
                
                // Save to database
                self.dbService.saveUser(json: json) { dbResult in
                    if case .failure(let error) = dbResult {
                        print("⚠️ Cache save failed: \(error)")
                    }
                }
                
                self.state = .loaded
                
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    func validateAndSave(name: String?, email: String?, bio: String?) {
        guard let name = name?.trimmingCharacters(in: .whitespacesAndNewlines),
              let email = email?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            state = .error("Please fill in all required fields")
            return
        }
        
        let bio = bio?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Validate
        do {
            try validator.validate(name: name)
            try validator.validate(email: email)
            if !bio.isEmpty {
                try validator.validate(bio: bio)
            }
        } catch {
            state = .error(error.localizedDescription)
            return
        }
        
        state = .loading
     
        let updateData = UserProfileDTO(fullName: name, email: email, bio: bio)
        
        apiService.updateProfile(data: updateData) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let json):
                self.profileData = json
                self.state = .saved
                
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
}
