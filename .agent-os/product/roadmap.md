# Product Roadmap

## Phase 0: UI Foundations

**Goal:** Establish reusable SwiftUI components for the Today dashboard.
**Success Criteria:** Core tiles render in previews with dynamic type and accessibility support.

### Features

- [x] Build ActivityCard component covering idle/active/disabled/loading states `S`
- [x] Implement FavoritesGrid with adaptive column behavior `S`
- [x] Create RecentsScroller with state-driven styling `S`
- [x] Add SummaryPeek and SummaryList tiles with skeleton loaders `M`
- [x] Provide TimerBanner hero module with responsive layout `S`
- [x] Supply TodayComponentsPreview aggregation screen for design reviews `S`

### Dependencies

- SwiftUI previews and sample data stubs

## Phase 1: Core Timer MVP

**Goal:** Wire the Today dashboard to live timer state and persistence.
**Success Criteria:** Users can start/switch timers and see accurate summaries without leaving the Today tab.

### Features

- [ ] Introduce Today view model managing active timer state and intents `M`
- [ ] Implement start/stop/switch timer use cases with overlap prevention `L`
- [ ] Persist activities and entries via Core Data repositories `L`
- [ ] Display live summaries sourced from recorded entries `M`
- [ ] Integrate search & quick start modal across activity catalog `M`
- [ ] Hook SwiftUI views to view models with dependency injection scaffolding `M`

### Dependencies

- Core Data stack, timer repository interfaces, unit tests for state transitions

## Phase 2: History & Export

**Goal:** Deliver historical insights and data ownership features for weekly reporting.
**Success Criteria:** Day/Week/Month views and export flows run end-to-end with validated totals.

### Features

- [ ] Build history view models and data sources for time-based rollups `M`
- [ ] Implement entry maintenance sheet (edit, reassign, delete) with validation `M`
- [ ] Generate summary analytics (totals, deltas, trend calculations) `M`
- [ ] Add CSV export service and Settings flow integration `M`
- [ ] Introduce integration/unit test coverage for repositories and exports `M`
- [ ] Evaluate optional iCloud sync toggle architecture `L`

### Dependencies

- Completed Phase 1 data layer, analytics utility services, export formatting library

## Phase 3: Automation & Platform Extensions

**Goal:** Differentiate with automation hooks and multi-surface experiences.
**Success Criteria:** Users extend ActivityLog via widgets, Shortcuts, or companion apps while staying in sync.

### Features

- [ ] Ship App Intents & Shortcuts for quick activity start/switch `M`
- [ ] Provide Lock Screen and Home Screen widgets for timers and summaries `M`
- [ ] Launch Apple Watch companion app with active timer control `L`
- [ ] Add optional analytics instrumentation behind privacy toggles `S`
- [ ] Harden CI/CD with UI automation and TestFlight distribution playbooks `M`

### Dependencies

- Stable API surface from Phases 1-2, watch connectivity services, widget timeline providers

