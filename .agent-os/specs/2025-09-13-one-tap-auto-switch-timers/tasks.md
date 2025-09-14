# Spec Tasks

## Tasks

- [ ] 1. Implement zero-gap auto-switching and second-tap stop
  - [x] 1.1 Write tests for Activities timing controller (start/switch/stop)
  - [x] 1.2 Implement one-tap start on activity tiles/buttons
  - [x] 1.3 Auto-stop current entry and start new at identical timestamp (no gap)
  - [x] 1.4 Second tap on active activity stops timer immediately
  - [x] 1.5 Ensure UI state reflects running/idle correctly in Activities tab
  - [ ] 1.6 Verify all tests pass
        ⚠️ Blocking issue: Local environment lacks Xcode to run tests here

- [ ] 2. Enforce non-overlapping entries at the model layer
  - [x] 2.1 Write tests for Core Data validation and insertion rules
        Note: Implemented at controller layer with insertion API for this sample
  - [x] 2.2 Add model-level constraints/logic to prevent overlap on insert
        Implemented `insert(_:)` with strict non-overlap check
  - [ ] 2.3 Update edit/update flows to maintain non-overlap invariants
  - [x] 2.4 Add guardrails for boundary equality (end == next start)
  - [ ] 2.5 Verify all tests pass
        ⚠️ Blocking issue: Local environment lacks Xcode to run tests here

- [ ] 3. Add accidental-tap guard (10s minimum duration)
  - [x] 3.1 Write tests for short-entry suppression and extension behavior
  - [x] 3.2 Suppress persisting entries < 10s unless extended past threshold
  - [x] 3.3 Integrate guard with start/stop/switch flows (no user friction)
  - [ ] 3.4 Verify all tests pass
        ⚠️ Blocking issue: Local environment lacks Xcode to run tests here

- [ ] 4. Provide feedback and Now Running indicator
  - [ ] 4.1 Write UI tests for haptic + visual state changes
        ⚠️ Blocking issue: UI tests require Xcode/iOS runtime
  - [x] 4.2 Trigger haptic feedback on start/stop/switch
  - [x] 4.3 Add visible Now Running indicator that’s always present
  - [x] 4.4 Ensure indicator updates instantly on switches and stops
  - [ ] 4.5 Verify all tests pass
        ⚠️ Blocking issue: Local environment lacks Xcode to run tests here

- [ ] 5. Background persistence and restore
  - [x] 5.1 Write tests for backgrounding/termination and state restoration
        Implemented via injectable store and unit tests
  - [ ] 5.2 Persist running state and start time in Core Data on background/terminate
        ⚠️ Blocking issue: Core Data not integrated in this sample; used UserDefaults MVP
  - [x] 5.3 Restore running activity + elapsed time on next launch
  - [x] 5.4 Ensure timers remain accurate across sessions
  - [ ] 5.5 Verify all tests pass
        ⚠️ Blocking issue: Local environment lacks Xcode to run tests here
