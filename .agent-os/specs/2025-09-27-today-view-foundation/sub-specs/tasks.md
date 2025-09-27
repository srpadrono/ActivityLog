# Spec Tasks

- [x] 1. Build Today view UI components
  - [x] 1.1 Write snapshot tests or preview assertions for ActivityCard, RecentsScroller, TimerBanner, SummaryPeek, and SummaryList states
  - [x] 1.2 Implement the SwiftUI component views with idle, active, disabled, and loading variants plus preview data
  - [x] 1.3 Ensure layouts respect Dynamic Type adjustments and collapse the favorites grid gracefully at large sizes
  - [x] 1.4 Verify all tests pass

- [ ] 2. Compose TodayDashboardView and Summary modal
  - [ ] 2.1 Write layout tests or preview assertions covering TodayDashboardView and SummaryModalView arrangements
  - [ ] 2.2 Implement TodayDashboardView with header, favorites grid, recents scroller, timer banner, and summary trigger placement
  - [ ] 2.3 Integrate SummaryModalView via sheet presentation with feature-flagged animation wrappers for selection and sheet snapping
  - [ ] 2.4 Verify all tests pass

- [ ] 3. Implement TodayViewModel and dummy controller harness
  - [ ] 3.1 Write unit tests for TodayViewModel intent methods and state publishing using mock repositories
  - [ ] 3.2 Model TodayViewState and implement TodayViewModel with published properties for favorites, recents, activeTimer, and summary
  - [ ] 3.3 Implement intent methods (`didSelectFavorite`, `didTapStop`, `didOpenSummary`) using Task delays to simulate async flows
  - [ ] 3.4 Build TodayController or NavigationStack host that injects TimerPreviewRepository for previews and demo builds
  - [ ] 3.5 Verify all tests pass

- [ ] 4. Define navigation hooks and data interfaces
  - [ ] 4.1 Write tests validating TodayRoute publisher emissions and repository interface expectations via mocks
  - [ ] 4.2 Define TodayRoute enum for search, summaryFull, and manageFavorites plus expose routePublisher from the view model
  - [ ] 4.3 Stub TodayRoute handling in the dummy controller with logging placeholders
  - [ ] 4.4 Sketch protocols for TimerRepository, ActivityCatalogRepository, and SummaryService aligned with architecture layering
  - [ ] 4.5 Provide in-memory mock implementations under a MockData namespace using Combine/async publishers
  - [ ] 4.6 Verify all tests pass

- [ ] 5. Finalize previews, tooling, and documentation
  - [ ] 5.1 Write tests validating feature toggle defaults and logging enablement behavior
  - [ ] 5.2 Add SwiftUI preview configurations for light/dark, Dynamic Type variants, and no-active-timer state across key views
  - [ ] 5.3 Gate logging through an injected os.Logger instance within the view model
  - [ ] 5.4 Update project structure and Xcode groups to match architecture guidance
  - [ ] 5.5 Document component APIs and integration guidance in Presentation/Timer/README.md and introduce TodayFeatureToggles struct
  - [ ] 5.6 Verify all tests pass
