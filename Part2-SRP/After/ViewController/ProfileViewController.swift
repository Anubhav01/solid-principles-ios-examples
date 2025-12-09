import UIKit

// MARK: - ✅ The Refactored Controller (MVVM Version)
// Responsibilities:
// 1. Layout UI
// 2. Bind to ViewModel

class ProfileViewController: UIViewController {
    
    // The ONLY dependency is the ViewModel
    private var viewModel: ProfileViewModel
    
    // UI Elements
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let bioTextView = UITextView()
    
    // Dependency Injection
    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        // Fallback for Storyboards
        self.viewModel = ProfileViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadUserProfile()
    }
    
    func setupBindings() {
        // Bind View to State
        viewModel.onDataLoaded = { [weak self] json in
            DispatchQueue.main.async {
                self?.nameTextField.text = json["full_name"] as? String
                self?.emailTextField.text = json["email"] as? String
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(errorMessage)
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        // ... Layout code
    }
    
    @objc func saveButtonTapped() {
        // Delegate action to ViewModel
        viewModel.validateAndSave(
            name: nameTextField.text,
            email: emailTextField.text,
            bio: bioTextView.text
        )
    }
    
    func showError(_ message: String) {
        // Alert logic
    }
}
