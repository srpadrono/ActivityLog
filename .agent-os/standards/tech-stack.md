# Tech Stack

## Context

Global tech stack defaults for Agent OS projects, overridable in project-specific `.agent-os/product/tech-stack.md`.

- App Framework: SwiftUI (latest stable)
- Language: Swift 5.10+
- Minimum iOS: iOS 17+ (adopt iOS 18 features opportunistically, guard with availability)
- Architecture: MVVM with Observable/@StateObject/@Environment
- Concurrency: Structured Concurrency (async/await, Task, Actors)
- Navigation: SwiftUI NavigationStack + deep links (Universal Links)
- Networking: URLSession + Codable (Alamofire optional per project)
- Persistence (Local): Core Data with lightweight migrations
- Key-Value Storage: AppStorage/UserDefaults
- Secure Storage: Keychain (via simple wrapper)
- Caching: URLCache + on-disk JSON caches
- Package Manager: Swift Package Manager (SPM) only
- Icons: SF Symbols
- Fonts: Apple Native
- Accessibility: VoiceOver, Dynamic Type, high-contrast, reduced motion baked into components
- Secrets Management: .xcconfig + Encrypted CI vars; no secrets in repo
- In-App Logs: OSLog (Logger) with unified categories
- Testing: XCTest/XCUITest (unit + UI)
- Branching Model: main (production), staging (pre-prod), feature branches via PRs
- Documentation: DocC for modules; architecture README in /Docs