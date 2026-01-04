import Foundation

// Example ViewModel for testing demonstration
class NameEditorViewModel {
    weak var delegate: UserNameUpdateDelegate?
    private var currentName = ""
    
    func saveName(_ name: String) {
        // Validation logic here...
        guard !name.isEmpty else { return }
        
        currentName = name
        delegate?.didUpdateName(name)
    }
}
