# Product Roadmap

## Phase 1: MVP

**Goal:** Ship a fast, reliable iOS app for one-tap activity tracking with on-device summaries.
**Success Criteria:** Track time across at least 10 activities/day; <1s tap-to-run; zero overlapping timers; 

### Features

- [ ] One-tap timers with automatic stop/switching `M`
- [ ] Activity groups with custom activities (create/rename/reorder) `M`
- [ ] Favorites and drag-to-reorder on Activities tab `S`
- [ ] History views: Day, Week, Month with per-activity totals `M`
- [ ] Edit entries (start/stop, reassign, delete) `M`
- [ ] Search activities `S`
- [ ] On-device storage via Core Data (SQLite) with migrations `M`

### Dependencies

- iOS 17+, Swift 5.10+, SwiftUI, Core Data, SF Symbols

## Phase 2: Differentiators

**Goal:** Make reporting and weekly review effortless for managers and ICs.
**Success Criteria:** Weekly report created in <2 minutes; 90%+ sessions use built-in analytics.

### Features

- [ ] Group rollups and saved reporting presets `M`
- [ ] Advanced analytics: custom ranges, top activities, streaks `M`
- [ ] Widgets and Quick Actions for faster starts `S`

## Phase 3: Scale & Polish

**Goal:** Broaden utility and reliability across devices; reduce friction further.
**Success Criteria:** Optional sync enabled; Watch shortcut flow <3 seconds; accessibility passes audits.

### Features

- [ ] iCloud sync for activities and entries (optional) `L`
- [ ] watchOS companion with start/stop + complications `L`
- [ ] Siri Shortcuts / App Intents for voice start/stop `M`
- [ ] Performance tuning for large histories `S`
- [ ] Accessibility audit and improvements `S`

### Dependencies

- CloudKit, watchOS, App Intents, performance tooling

