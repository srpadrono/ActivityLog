# Spec Tasks

## Tasks

- [ ] 1. Stand up TodayView layout layer in Presentation/Timer
  - [x] 1.1 Write layout tests for TodayView rendering core sections with stub view model
  - [x] 1.2 Implement TodayView SwiftUI screen composing TimerBanner, FavoritesGrid, RecentsScroller, Summary tiles
  - [x] 1.3 Replace ContentView body to host TodayView and inject preview/sample dependencies
  - [ ] 1.4 Verify all tests pass
    ⚠️ Blocking issue: Xcode command line tools lack full xcodebuild and the project is not a Swift Package, preventing local test execution.

- [ ] 2. Implement TodayViewModel with published state and intents
  - [ ] 2.1 Write view model tests covering start/switch timer and summary refresh flows
  - [ ] 2.2 Define TodayViewModel, state structs, and intent methods bridging to timer/summary use cases
  - [ ] 2.3 Connect TodayView to TodayViewModel via @StateObject and mockable protocol interfaces
  - [ ] 2.4 Verify all tests pass

- [ ] 3. Build timer control use cases and protocols
  - [ ] 3.1 Write unit tests for StartTimer, StopTimer, and SwitchTimer use cases enforcing single active timer rule
  - [ ] 3.2 Implement use case structs and timer coordinator protocol abstractions
  - [ ] 3.3 Provide in-memory stub implementations for previews/tests and integrate with TodayViewModel
  - [ ] 3.4 Verify all tests pass

- [ ] 4. Establish Core Data repositories for activities and entries
  - [ ] 4.1 Write repository tests using an in-memory NSPersistentContainer
  - [ ] 4.2 Model Core Data entities (ActivityEntity, TimeEntryEntity) and mapping layer to domain structs
  - [ ] 4.3 Implement ActivityRepository and TimeEntryRepository conforming to domain protocols
  - [ ] 4.4 Verify all tests pass

- [ ] 5. Surface live summaries and dependency injection scaffolding
  - [ ] 5.1 Write summary calculator tests ensuring totals/deltas match repository data
  - [ ] 5.2 Implement FetchTodaySummary and ObserveRecents use cases with publisher outputs
  - [ ] 5.3 Assemble dependency graph (Environment/DI container) and wire into ActivityLogApp for runtime
  - [ ] 5.4 Verify all tests pass
