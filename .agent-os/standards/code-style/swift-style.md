# Agent OS Swift & SwiftUI Code Style

> **Purpose**: Ensure consistent, readable, and high‑quality Swift/SwiftUI across AgentOS.

---

## 1) Principles

* **Clarity over cleverness**
* **Safety first** (optionals, concurrency, errors)
* **Single responsibility** per type/file
* **Testable architecture** (MVVM + DI)
* **Accessibility & performance** are requirements, not extras

---

## 2) Tooling & Baseline

* **Swift**: latest stable (pin in `README`)
* **Xcode**: latest stable
* **Format**: SwiftFormat (CI‑enforced)

  * line length: 120
  * commas: trailing
  * if/guard wrap: enabled
* **Lint**: SwiftLint (CI‑enforced)

  * opt‑in rules: `closure_spacing`, `empty_count`, `explicit_init`, `unowned_variable_capture`, `fatal_error_message`
* **Static analysis**: Treat warnings as errors in CI.

Example `.swiftformat` excerpt:

```ini
--maxwidth 120 --wraparguments after-first --wrapcollections before-first --commas inline --self remove
```

Example `.swiftlint.yml` excerpt:

```yaml
line_length: 120
opt_in_rules:
  - closure_spacing
  - empty_count
  - explicit_init
  - unowned_variable_capture
  - fatal_error_message
```

---

## 4) Naming

* Types: `PascalCase`, functions/vars: `camelCase`, constants: `camelCase`.
* Protocols describe **capability**: `...Providing`, `...Servicing`, `...Coordinating`.
* Async funcs start with a verb: `fetchUser()`, `loadCache()`.
* Boolean: positive phrasing `isEnabled`, `hasAccess`.
* Views end with `View`: `SettingsView`.

---

## 5) Formatting Essentials

* **Imports**: one per line; group `Foundation`/`SwiftUI` first, local modules next, then third‑party.
* **Spacing**: 1 empty line between type members groups; no trailing spaces.
* **Visibility** keywords before attributes: `public final class`.
* Prefer `let` over `var`.
* Use `// MARK:` to group: Lifecycle, Properties, Body, Methods.

---

## 6) Access Control & Immutability

* Default to `internal`. Use `private` to hide implementation details; `fileprivate` rarely.
* Prefer value types (`struct`, `enum`) over classes. Mark classes `final` unless subclassing.

---

## 7) Optionals & Early Exits

* Prefer `guard` for preconditions, `if let` for local branching.

```swift
func configure(with user: User?) {
    guard let user else { return }
    name = user.displayName
}
```

* Avoid force‑unwraps. Use `preconditionFailure("reason")` if truly impossible.

---

## 8) Errors

* Use typed `Error` enums per domain.

```swift
enum AuthError: Error { case invalidCredentials, network(URLError) }
```

* Throwing over callbacks; wrap underlying errors.
* For user‑visible errors provide `var message: String` mapping in Presentation layer.

---

## 9) Concurrency

* Prefer **async/await**. Use `Task {}` only at boundaries (UI events) and cancel on disappear.
* Actor isolation for shared mutable state; mark UI-facing APIs `@MainActor`.

```swift
@MainActor final class SessionViewModel: ObservableObject { /* ... */ }
```

* Use `TaskGroup` for fan‑out/fan‑in; propagate cancellation.

---

## 10) Dependency Injection

* Use initializer injection; avoid singletons. For global, use lightweight container via environment.

```swift
protocol UserServicing { func user() async throws -> User }
struct UserService: UserServicing { /* ... */ }

@MainActor
final class ProfileViewModel: ObservableObject {
    private let userService: UserServicing
    init(userService: UserServicing) { self.userService = userService }
}
```

---

## 11) SwiftUI Conventions

### 11.1 File Layout for Views

```swift
struct ProfileView: View {
    // MARK: - State
    @StateObject private var viewModel: ProfileViewModel

    // MARK: - Init
    init(viewModel: @autoclosure @escaping () -> ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    // MARK: - Body
    var body: some View {
        content
            .navigationTitle("Profile")
            .task { await viewModel.load() }
            .onDisappear { viewModel.onDisappear() }
    }

    private var content: some View {
        Group {
            switch viewModel.state {
            case .loading: ProgressView()
            case .error(let message): ErrorView(message: message, retry: { Task { await viewModel.load() }})
            case .loaded(let user): UserHeader(user: user)
            }
        }
        .padding()
    }
}
```

### 11.2 State Management

* `@State` for local transient state
* `@StateObject` for owning a reference type view model
* `@ObservedObject` for non‑owning references
* `@Binding` for two‑way value flow
* `@Environment`/`@EnvironmentObject` for cross‑cutting concerns (use sparingly)

### 11.3 Modifiers Order

1. Content & layout (`padding`, `frame`, `layoutPriority`)
2. Styling (`foregroundStyle`, `background`, `clipShape`)
3. Interactions (`onTapGesture`, `gesture`)
4. Semantics (`accessibilityLabel`, `accessibilityHint`)

### 11.4 Navigation

* Use `NavigationStack` + typed `enum Route: Hashable`.
* Centralize deep‑link parsing in a coordinator.

### 11.5 Previews

* Always include a `#Preview` with deterministic data and light/dark variants.

```swift
#Preview("Loaded") { ProfileView(viewModel: .mockLoaded) }
#Preview("Error") { ProfileView(viewModel: .mockError) }
```

### 11.6 Lists & IDs

* Use stable IDs (`id: \\ .id`). Avoid `UUID()` in `ForEach` unless data truly ephemeral.

### 11.7 Accessibility

* Provide labels, traits, and dynamic type support. Minimum AA contrast.

```swift
Image(systemName: "person.circle")
    .accessibilityLabel("Profile picture")
```

### 11.8 Theming

* Centralize colors and typography in **DesignSystem**. Do not hardcode hex.

```swift
extension Color { static let brand = Color("Brand") }
```

### 11.9 Animations

* Prefer implicit animations with `.animation(_, value:)` on small state; explicit `withAnimation` for transitions.

---

## 12) ViewModel Pattern (MVVM)

```swift
@MainActor
final class ProfileViewModel: ObservableObject {
    enum State { case loading, loaded(User), error(String) }
    @Published private(set) var state: State = .loading

    private let userService: UserServicing
    private var loadTask: Task<Void, Never>?

    init(userService: UserServicing) { self.userService = userService }

    func load() async {
        loadTask?.cancel()
        do {
            state = .loading
            let user = try await userService.user()
            state = .loaded(user)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func onDisappear() { loadTask?.cancel() }
}
```

---

## 13) Networking

* Use `URLSession` + `async` APIs; wrap in a `NetworkClient` protocol.
* Request/response models are `Codable`; decode with `keyDecodingStrategy = .convertFromSnakeCase` as needed.
* Timeouts and retries explicit; no silent infinite retries.

---

## 14) Persistence

* Prefer `@AppStorage` for tiny settings; use SQLite/Core Data for structured data; `FileManager` for blobs.
* Access on background threads; present on main.

---

## 15) Logging & Telemetry

* Use a lightweight wrapper over `os.Logger`. No `print` in production.

```swift
import os
let log = Logger(subsystem: "com.agentos.app", category: "network")
log.info("Started request: \(url.absoluteString)")
```

---

## 16) Testing

* **Unit tests** for view models, services, mappers.
* **Snapshot tests** for views with stable seeds.
* Use **test doubles** via protocols; avoid `@testable` white‑box testing where possible.

---

## 17) Documentation

* Public API documented with DocC style comments.

```swift
/// Fetches the current user profile from the backend.
/// - Returns: The authenticated `User`.
/// - Throws: `AuthError` when authentication fails.
func fetchUser() async throws -> User { ... }
```

---

## 18) Git Hygiene

* Conventional commits: `feat:`, `fix:`, `refactor:`, `test:`, `build:`, `chore:`
* Small PRs (< 400 LOC diff) with description and screenshots for UI.

---

## 19) Do/Don't Quick Sheet

**Do**

* Prefer composition over inheritance
* Use `Result` or throws, not both
* Keep views small and stateless where possible

**Don’t**

* Hardcode strings/colors in views
* Block the main thread with sync I/O
* Hide side effects in property observers

---

## 20) Ready‑to‑Paste Templates

**Feature View File**

```swift
import SwiftUI

struct <#Feature#>View: View {
    @StateObject private var viewModel: <#Feature#>ViewModel
    init(viewModel: @autoclosure @escaping () -> <#Feature#>ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    var body: some View { content }
    private var content: some View { Text("Hello") }
}

#Preview { <#Feature#>View(viewModel: .mock) }
```

**ViewModel File**

```swift
@MainActor
final class <#Feature#>ViewModel: ObservableObject {
    @Published private(set) var state: State = .loading
    enum State { case loading, ready }
    init() {}
}
```

**Service Protocol**

```swift
protocol <#Name#>Servicing {
    func execute() async throws -> Output
}
```

