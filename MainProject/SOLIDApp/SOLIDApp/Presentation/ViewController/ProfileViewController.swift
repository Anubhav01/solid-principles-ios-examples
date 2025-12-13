import UIKit

class ProfileViewController: UIViewController {
    private var viewModel: ProfileViewModel
    
    // UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let bioTextView = UITextView()
    private let saveButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(viewModel:) instead")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadUserProfile()
    }
    
    private func setupBindings() {
        viewModel.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.updateUI(for: state)
            }
        }
        
        viewModel.onDataLoaded = { [weak self] data in
            DispatchQueue.main.async {
                if let data = data,
                   let self = self {
                    self.populateFields(with: data)
                }
            }
        }
    }
    
    private func setupUI() {
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        // Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Name Field
        nameTextField.placeholder = "Full Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameTextField)
        
        // Email Field
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailTextField)
        
        // Bio Field
        bioTextView.layer.borderColor = UIColor.systemGray4.cgColor
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.cornerRadius = 8
        bioTextView.font = .systemFont(ofSize: 16)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bioTextView)
        
        // Save Button
        saveButton.setTitle("Save Profile", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveButton)
        
        // Loading Indicator
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        // Layout
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            bioTextView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            bioTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bioTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bioTextView.heightAnchor.constraint(equalToConstant: 120),
            
            saveButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Keyboard handling
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func updateUI(for state: ViewState) {
        switch state {
        case .idle:
            loadingIndicator.stopAnimating()
            saveButton.isEnabled = true
            
        case .loading:
            loadingIndicator.startAnimating()
            saveButton.isEnabled = false
            
        case .loaded:
            loadingIndicator.stopAnimating()
            saveButton.isEnabled = true
            
        case .saved:
            loadingIndicator.stopAnimating()
            saveButton.isEnabled = true
            showSuccess() // ✅ only after save/update
            
        case .error(let message):
            loadingIndicator.stopAnimating()
            saveButton.isEnabled = true
            showError(message)
        }
    }
    
    private func populateFields(with data: UserProfileDTO) {
        nameTextField.text = data.fullName
        emailTextField.text = data.email
        bioTextView.text = data.bio
    }
    
    @objc private func saveButtonTapped() {
        view.endEditing(true)
        viewModel.validateAndSave(
            name: nameTextField.text,
            email: emailTextField.text,
            bio: bioTextView.text
        )
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccess() {
        let alert = UIAlertController(
            title: "Success",
            message: "Profile updated successfully",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = keyboardFrame.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
