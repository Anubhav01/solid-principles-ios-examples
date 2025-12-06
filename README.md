# SOLID Principles in iOS — The Blueprint for Scalable Apps 📱

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

**Welcome to the official companion repository for the "SOLID Principles in iOS" blog series.**

This repository contains real-world Swift examples demonstrating the transition from "Spaghetti Code" (Massive View Controllers, tight coupling) to clean, scalable, and testable **SOLID Architecture**.

> **"If you want to grow from a coder to a software engineer, SOLID is your foundation."**

---

## 🎯 What You'll Learn

Transform this 👇

```swift
// ❌ BEFORE: 4,000-line Massive View Controller
class HomeViewController: UIViewController {
    func fetchUser() { URLSession.shared.dataTask(...) }  // Networking
    func saveUserToDB() { CoreData.save(...) }            // Database
    func trackEvent() { Analytics.log(...) }              // Analytics
    // ... 3,950 more lines of chaos
}
```

Into this 👇

```swift
// ✅ AFTER: Clean, Testable, Modular
class HomeViewController: UIViewController {
    private let userService: UserService
    private let dbService: PersistenceService
    
    func loadUser() {
        userService.fetchUser { [weak self] user in
            self?.dbService.save(user)
            self?.updateUI(with: user)
        }
    }
}
```

**Each part includes:**
- 📝 Before/After comparisons
- ✅ Working unit tests
- 🎓 Career growth insights
- 🧪 Testability demonstrations

---

## 🛠️ Prerequisites

- **Xcode:** 15.0+ (latest stable version recommended)
- **Swift:** 5.9+
- **iOS:** 15.0+ deployment target
- **Experience Level:** Intermediate iOS developers (comfortable with UIKit/SwiftUI basics)

**No prior SOLID knowledge required** — that's what this series teaches!

---

## 📚 The Series Roadmap

Each folder in this repository corresponds to a part of the blog series.

| Part | Principle | Description | Code Status |
| :--- | :--- | :--- | :--- |
| **01** | [**Introduction**](LINK_TO_YOUR_BLOG_POST_HERE) | Why SOLID matters & The "Jenga" Analogy | ✅ Ready |
| **02** | **Single Responsibility (SRP)** | Killing the Massive View Controller | 🚧 Coming Soon |
| **03** | **Open/Closed (OCP)** | Feature Flags & Plugin Architecture | ⏳ Pending |
| **04** | **Liskov Substitution (LSP)** | Protocol-Oriented Swift done right | ⏳ Pending |
| **05** | **Interface Segregation (ISP)** | Lean Protocols vs. Fat Delegates | ⏳ Pending |
| **06** | **Dependency Inversion (DIP)** | Building for Testability | ⏳ Pending |
| **07** | **Bonus** | SOLID in SwiftUI + Combine | ⏳ Pending |

---

## 📂 Repository Structure

```
SOLID-iOS-Examples/
│
├── Part01-Introduction/
│   └── README.md (blog link + overview)
│
├── Part02-SingleResponsibility/
│   ├── Before/
│   │   └── MassiveViewController.swift (the 4,000-line monster)
│   ├── After/
│   │   ├── HomeViewController.swift (clean coordinator)
│   │   ├── UserService.swift (networking layer)
│   │   └── PersistenceService.swift (data layer)
│   └── Tests/
│       └── HomeViewControllerTests.swift (proof it works!)
│
├── Part03-OpenClosed/
│   ├── Before/ (rigid, modification-heavy code)
│   ├── After/ (extensible plugin architecture)
│   └── Tests/
│
├── Part04-LiskovSubstitution/
│   ├── Before/
│   ├── After/
│   └── Tests/
│
├── Part05-InterfaceSegregation/
│   ├── Before/
│   ├── After/
│   └── Tests/
│
├── Part06-DependencyInversion/
│   ├── Before/
│   ├── After/
│   └── Tests/
│
└── Part07-SwiftUI-Combine/
    ├── Before/
    ├── After/
    └── Tests/
```

**Each part follows the same pattern:**
- **Before/** → The problematic code
- **After/** → The SOLID refactor
- **Tests/** → Unit tests demonstrating testability

---

## 🚀 How to Use This Repo

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Anubhav01/solid-principles-ios-examples.git
   cd solid-principles-ios-examples
   ```

2. **Navigate to a specific part:**
   ```bash
   cd Part02-SingleResponsibility
   open MassiveViewController-Refactor.xcodeproj
   ```

3. **Explore the Before/After examples:**
   - Open files in `Before/` to see the problematic code
   - Open files in `After/` to see the SOLID refactor
   - Compare side-by-side to understand the transformation

4. **Run the tests:**
   - Press `Cmd + U` in Xcode
   - Watch the SOLID magic happen ✨
   - See how testability improves dramatically

---

## ⭐ Found This Helpful?

If this repository helps you write better iOS code:

1. **⭐ Star this repo** (helps others discover it)
2. **🔔 Watch** for updates (new parts added weekly)
3. **🍴 Fork** to experiment with the examples
4. **💬 Share** with your iOS team

**New to SOLID?** Start with [Part 1: Introduction](LINK_TO_YOUR_BLOG_POST_HERE) to understand why these principles matter.

---

## 🤝 Contributing

Found a bug? Have a better refactoring approach? Contributions are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/better-example`)
3. Commit your changes (`git commit -m 'Improve X example'`)
4. Push to the branch (`git push origin feature/better-example`)
5. Open a Pull Request

**Please maintain the Before/After/Tests structure for consistency.**

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 💬 Questions or Feedback?

- **📝 Blog Comments:** [Leave feedback on the blog series](LINK_TO_YOUR_BLOG_POST_HERE)
- **🐛 GitHub Issues:** [Open an issue](https://github.com/Anubhav01/solid-principles-ios-examples/issues) for bugs or suggestions
- **💼 LinkedIn:** Connect with me for iOS architecture discussions
- **🐦 Twitter/X:** Follow for updates on the series

---

## 🎓 About This Series

This repository is maintained as part of a comprehensive 7-week blog series on SOLID principles for iOS development. Each week, a new part is published with detailed explanations, real-world examples, and career growth insights.

**Topics Covered:**
- Killing Massive View Controllers
- Protocol-Oriented Design
- Dependency Injection
- Testable Architecture
- SwiftUI + Combine Integration
- Career advancement from coder to software engineer

---

**Built with ❤️ by [Anubhav](https://github.com/Anubhav01) for the iOS community**

*Last Updated: December 2024 | Swift 5.9 | iOS 15.0+*
