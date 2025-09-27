# Technical Specification

This is the technical specification for the spec detailed in @.agent-os/specs/2025-09-27-today-view-foundation/spec.md

## Technical Requirements

- **Component Stage (Phase 1)**
  - Implement `ActivityCard`, `RecentsScroller`, `TimerBanner`, `SummaryPeek`, and `SummaryList` as standalone SwiftUI views under `Presentation/Timer/Components` with preview data.
  - Provide visual states for idle, active, disabled, and loading variants using simple enum-driven props so view logic stays declarative.
  - Use `ViewThatFits`/`GeometryReader` sparingly to honor Dynamic Type adjustments; ensure grid gracefully collapses to one column for extra-large sizes.

- **Today View Composition (Phase 2)**
  - Create `TodayDashboardView` under `Presentation/Timer/Today` that arranges the components per the UI representation: header, favorites grid, recents scroller, spacer, timer banner, and summary sheet trigger.
  - Integrate a `SummaryModalView` presented via `.sheet` using a custom binding supplied by the dummy controller.
  - Add animation wrappers (`.matchedGeometryEffect` for card selection, `.spring` for sheet snap points) behind feature flags to enable tuning without code churn.

- **Dummy Controller & View Model (Phase 3)**
  - Introduce `TodayViewModel` conforming to `ObservableObject` that publishes `TodayViewState` (favorites, recents, activeTimer, summary).
  - Provide intent methods (`didSelectFavorite`, `didTapStop`, `didOpenSummary`) that mutate in-memory state using `Task` delays to simulate asynchronous use cases.
  - Supply `TodayController` (UIKit wrapper) or `NavigationStack` host that injects a `TimerPreviewRepository` returning deterministic sample data for previews and the in-app demo build.

- **Coordinator & Navigation Hooks**
  - Define a `TodayRoute` enum covering `search`, `summaryFull`, and `manageFavorites` so the future `RootCoordinator` can transition without recompiling the view layer.
  - Expose `routePublisher` from the view model that the coordinator can observe; stub handling in the dummy controller to log actions for now.

- **Repository & Service Interfaces**
  - Sketch protocols for `TimerRepository`, `ActivityCatalogRepository`, and `SummaryService` scoped to the Today flows, matching the architecture file's layering rules.
  - Provide in-memory mock implementations that live in a `MockData` namespace and use Combine/async publishers to drive the view model.

- **Testing & Instrumentation**
  - Add SwiftUI preview configurations for light/dark mode, small/large Dynamic Type, and no-active-timer state.
  - Supply unit tests for the view model verifying that selecting a favorite stops the previous timer and updates summary totals using the mock repositories.
  - Gate optional logging through an `os.Logger` instance injected into the view model so telemetry can be enabled later without modifying view code.

- **Project Structure & Tooling**
  - Ensure new files are grouped according to the proposed folder structure in architecture.md; update Xcode project groups accordingly.
  - Document component APIs in `Presentation/Timer/README.md` (to be created in this phase) to guide developers when wiring real use cases.
  - Include feature flag configuration via a `TodayFeatureToggles` struct so future experiments (e.g., alternate summary layouts) can co-exist.
