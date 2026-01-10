import Foundation

// 🧠 High-Level Module
class UserListViewModel {
    
    // ✅ DEPENDENCY INVERSION:
    // We depend on the Protocol (Abstraction), not the concrete class.
    private let service: UserService
    
    var users: [String] = []
    
    // ✅ DEPENDENCY INJECTION:
    // We ask for the dependency in the init.
    // We don't create it ourselves.
    init(service: UserService) {
        self.service = service
    }
    
    func loadData() {
        self.users = service.fetchUsers()
        print("✅ ViewModel: Data loaded -> \(users)")
    }
}
