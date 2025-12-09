import UIKit
import CoreData
import CoreLocation
import UserNotifications
import AVFoundation

// MARK: - ❌ THE GOD CLASS
// This file represents a 5,000 line legacy controller.
// It violates SRP by handling:
// 1. UI Layout (Code-based constraints)
// 2. Network Requests (Raw URLSession)
// 3. Data Parsing (Manual JSON handling)
// 4. Persistence (CoreData Stack)
// 5. Image Caching (Manual implementation)
// 6. Form Validation (Complex Regex)
// 7. Analytics (Direct API calls)
// 8. Location Services
// 9. Push Notification handling

class MassiveProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    // MARK: - Properties (Lines 20 - 150)
    // There are 50+ UI properties here in a real legacy app
    let scrollView = UIScrollView()
    let contentView = UIView()
    let profileImageView = UIImageView()
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let bioTextView = UITextView()
    let saveButton = UIButton()
    let logoutButton = UIButton()
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    
    // State Properties
    var userId: String?
    var userToken: String?
    var isLoggedIn: Bool = false
    var lastLoginDate: Date?
    var profileData: [String: Any]?
    var purchaseHistory: [[String: Any]] = []
    
    // Dependencies (Tightly Coupled)
    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MIXING CONCERNS: UI, Auth, Analytics, Data Fetching all in viewDidLoad
        setupUI()
        checkUserStatus()
        setupLocation()
        registerForNotifications()
        logAnalytics(event: "screen_view", params: ["screen": "profile"])
        
        // ... Imagine 50 more lines of initializers
    }
    
    // MARK: - 1. UI SETUP (Lines 200 - 1200)
    func setupUI() {
        view.backgroundColor = .white
        
        // Imagine 1,000 lines of manual AutoLayout code here...
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Hardcoded constraints (Maintenance Nightmare)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // ... 500 more lines of constraints for every label, button, and view
        ])
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // ... More configuration
    }

    // MARK: - 2. NETWORKING (Lines 1200 - 1600)
    func fetchUserProfile() {
        guard let token = UserDefaults.standard.string(forKey: "auth_token") else { return }
        
        // Raw URL String (Hardcoded)
        let urlString = "https://api.legacyapp.com/v1/user/profile"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        activityIndicator.startAnimating()
        
        // Nested Closures Hell
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            // 3. PARSING LOGIC (Manual Parsing)
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    // Direct UI Updates from Network Response
                    DispatchQueue.main.async {
                        self.userId = json["id"] as? String
                        self.nameTextField.text = json["full_name"] as? String
                        self.emailTextField.text = json["email"] as? String
                        
                        if let history = json["orders"] as? [[String: Any]] {
                            self.purchaseHistory = history
                            self.tableView.reloadData()
                        }
                        
                        // Saving to CoreData inside Network Callback inside VC 😱
                        self.saveToLocalDatabase(json: json)
                    }
                }
            } catch {
                self.showError(message: "JSON Error")
            }
        }.resume()
    }
    
    // MARK: - 4. PERSISTENCE (Lines 1600 - 1900)
    func saveToLocalDatabase(json: [String: Any]) {
        // Direct dependency on AppDelegate (Tightly Coupled)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "UserProfile", in: context)!
        let userObj = NSManagedObject(entity: entity, insertInto: context)
        
        userObj.setValue(json["full_name"], forKey: "name")
        userObj.setValue(json["email"], forKey: "email")
        
        do {
            try context.save()
            print("Saved to Core Data")
        } catch {
            print("Failed to save")
        }
    }
    
    // MARK: - 5. IMAGE CACHING (Lines 1900 - 2100)
    func downloadImage(from urlString: String) {
        // Manual caching logic instead of using Kingfisher/SDWebImage
        let cacheKey = NSString(string: urlString)
        if let image = ImageCache.shared.object(forKey: cacheKey) {
            self.profileImageView.image = image
            return
        }
        
        // ... Another URLSession task just for images
    }

    // MARK: - 6. FORM VALIDATION (Lines 2100 - 2500)
    @objc func saveButtonTapped() {
        guard let name = nameTextField.text, let email = emailTextField.text else { return }
        
        // Complex Business Logic inside View Controller
        if name.count < 3 {
            showError(message: "Name too short")
            return
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            showError(message: "Invalid Email")
            return
        }
        
        if bioTextView.text.contains("swear_word") {
            showError(message: "Please be polite")
            return
        }
        
        updateUserProfile()
    }
    
    func updateUserProfile() {
        // ... Another massive networking call (POST request)
    }

    // MARK: - 7. TABLEVIEW DELEGATE (Lines 2500 - 3000)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let order = purchaseHistory[indexPath.row]
        
        // Formatting Logic inside Cell Configuration
        if let price = order["amount"] as? Double, let currency = order["currency"] as? String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = currency
            cell.textLabel?.text = "Order: \(formatter.string(from: NSNumber(value: price)) ?? "$0")"
        }
        
        // Date Formatting logic inside cellForRow
        if let dateString = order["date"] as? String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = inputFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateStyle = .medium
                cell.detailTextLabel?.text = outputFormatter.string(from: date)
            }
        }
        
        return cell
    }
    
    // MARK: - 8. LOCATION DELEGATE (Lines 3000 - 3500)
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        // Sending location to analytics every time user moves 😱
        logAnalytics(event: "location_update", params: ["lat": loc.coordinate.latitude, "lon": loc.coordinate.longitude])
    }
    
    // MARK: - 9. ANALYTICS (Lines 3500 - 3800)
    func logAnalytics(event: String, params: [String: Any]) {
        // Manual API call to analytics server
        // ... boilerplate networking code repeated again
    }
    
    // MARK: - HELPER METHODS (Lines 3800 - 5000)
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func checkUserStatus() {
        // check user status here
    }
    
    func registerForNotifications() {
        // handle notification registration code here
    }
    
    // ... Imagine 1000 more lines of various delegate implementations,
    // ... unused helper functions, and commented-out legacy code.
}

// Helper for image cache mock
class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
