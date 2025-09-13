# Spec Tasks

## Tasks

- [ ] 1. Implement zero-gap auto-switching and second-tap stop
  - [ ] 1.1 Write tests for Activities timing controller (start/switch/stop)
  - [ ] 1.2 Implement one-tap start on activity tiles/buttons
  - [ ] 1.3 Auto-stop current entry and start new at identical timestamp (no gap)
  - [ ] 1.4 Second tap on active activity stops timer immediately
  - [ ] 1.5 Ensure UI state reflects running/idle correctly in Activities tab
  - [ ] 1.6 Verify all tests pass

- [ ] 2. Enforce non-overlapping entries at the model layer
  - [ ] 2.1 Write tests for Core Data validation and insertion rules
  - [ ] 2.2 Add model-level constraints/logic to prevent overlap on insert
  - [ ] 2.3 Update edit/update flows to maintain non-overlap invariants
  - [ ] 2.4 Add guardrails for boundary equality (end == next start)
  - [ ] 2.5 Verify all tests pass

- [ ] 3. Add accidental-tap guard (10s minimum duration)
  - [ ] 3.1 Write tests for short-entry suppression and extension behavior
  - [ ] 3.2 Suppress persisting entries < 10s unless extended past threshold
  - [ ] 3.3 Integrate guard with start/stop/switch flows (no user friction)
  - [ ] 3.4 Verify all tests pass

- [ ] 4. Provide feedback and Now Running indicator
  - [ ] 4.1 Write UI tests for haptic + visual state changes
  - [ ] 4.2 Trigger haptic feedback on start/stop/switch
  - [ ] 4.3 Add visible Now Running indicator that’s always present
  - [ ] 4.4 Ensure indicator updates instantly on switches and stops
  - [ ] 4.5 Verify all tests pass

- [ ] 5. Background persistence and restore
  - [ ] 5.1 Write tests for backgrounding/termination and state restoration
  - [ ] 5.2 Persist running state and start time in Core Data on background/terminate
  - [ ] 5.3 Restore running activity + elapsed time on next launch
  - [ ] 5.4 Ensure timers remain accurate across sessions
  - [ ] 5.5 Verify all tests pass

