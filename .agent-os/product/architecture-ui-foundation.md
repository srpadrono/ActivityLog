# ActivityLog Product Foundation

## Purpose
- Provide a single, quick-reference source that unifies architecture, UI surfaces, and behavioral use cases for ActivityLog.
- Ensure engineers, designers, QA, and product partners share the same context when planning or implementing work.

## Goals & Principles
- Instant, offline-first responsiveness; no core flow depends on network availability.
- Single source of truth for time entries and activity metadata through a dedicated data layer.
- Declarative, testable presentation backed by MVVM and lightweight view models.
- Composable modules aligned to feature areas (Timers, Catalog, History) for focused ownership.
- Scalable services and protocols that isolate domain logic from infrastructure and enable future sync/analytics.
- UI surfaces that expose the same mental model as the architecture: quick start, review, manage, and configure.

## System Overview

### Product Blueprint
```
SwiftUI Views ─┬─► View Models (ObservableObject)
               │
               └─► Coordinators / Navigation Drivers
                     │
                     ▼
             Domain Use Cases (Protocols + Implementations)
                     │
                     ▼
                Repositories / Services
                     │
                     ▼
                  Core Data Stack
```

### Navigation Skeleton
```
Root Tab Bar
├─ Today
│  ├─ Navigation Bar (Title, Date, Search Icon)
│  ├─ Segmented Stack
│  │  ├─ Favourites Grid (2-column)
│  │  └─ Recent Activities Grid (2-column, max 10)
│  ├─ Today's Summary Tile
│  └─ Running Timer Banner (pinned above tab bar)
├─ History
│  ├─ Day View
│  ├─ Week View
│  └─ Month View
├─ Manage Activities
│  ├─ Group List
│  ├─ Activity Detail Sheet
│  └─ Favorites Editor
└─ Settings
   ├─ Export & Data
   ├─ Preferences
   └─ About
```

### Folder Structure (Proposed)
```
ActivityLog/
├─ Application/
│  ├─ ActivityLogApp.swift
│  └─ DI/
├─ Presentation/
│  ├─ Timer/
│  ├─ Catalog/
│  ├─ History/
│  ├─ EntryMaintenance/
│  └─ Shared/
├─ Domain/
│  ├─ UseCases/
│  └─ Models/
├─ Data/
│  ├─ Repositories/
│  ├─ Persistence/
│  └─ Mappers/
├─ Services/
│  ├─ Export/
│  └─ Utilities/
└─ Support/
   ├─ Coordinators/
   └─ Testing/
```

## Architecture Layers
- **Presentation:** SwiftUI views bound to `ObservableObject` view models. Views emit intents (tap, search, edit) that map to domain use cases. Coordinators own navigation routes to keep view models pure.
- **Domain:** Use-case structs (`StartTimer`, `FetchSummary`, etc.) encode business rules, accept repositories via protocols, and return domain models ready for presentation.
- **Data:** Repository implementations translate domain requests to Core Data operations, manage batching, and return immutable domain structs.
- **Services:** Cross-cutting utilities (date formatting, CSV export, analytics hooks) live behind service protocols injected into use cases.

## Feature Modules & Surface Mapping
- **Timer Module** `(Presentation/Timer)`: Today dashboard, search sheet, running timer banner. View models manage active timers and quick actions; use cases (`StartTimer`, `SwitchTimer`, `ObserveActiveTimer`) coordinate with the Timer repository to prevent overlaps.
- **Activity Catalog Module** `(Presentation/Catalog)`: Manage Activities tab and detail sheets. Handles `CreateActivityGroup`, `PinFavorite`, `SearchActivity`, and exposes grids for favorites and recents.
- **History & Summaries Module** `(Presentation/History)`: Day/Week/Month views. Summaries use `FetchDailySummary`, `FetchWeeklyGroupRollup`, and `FetchMonthlyTrend`, surfacing insight cards, timelines, rollups, and charts.
- **Entry Maintenance Module** `(Presentation/EntryMaintenance)`: Edit sheet across Today and History flows; use cases (`UpdateEntryWindow`, `ReassignEntry`) enforce validation before writes.
- **Data Ownership & Export Module** `(Settings)`: Export card and share sheet tie into `GenerateExport` and CSV builder services. Future sync toggles plug into the same service layer without touching presentation.

## Primary Screens & Responsibilities
- **Today Dashboard:** Presents favorites/recent grids, summary tile, and running timer banner. Search icon or pull-down opens Search & Start modal leveraging the same activity data sources as the dashboard.
- **Search & Start Flow:** Full-screen modal with segmented search results, quick-start shortcuts, and a path to create new activities.
- **History:** Segmented control across Day/Week/Month with timeline, group rollup, and trend chart views driven by summary calculators.
- **Manage Activities:** Grouped lists, row actions, and favorites editor for organizing catalog metadata.
- **Entry Maintenance Sheet:** Inline editing of entries with validation messaging and destructive actions handled via coordinator alerts.
- **Settings & Export:** Houses export configuration, on-device data messaging, and placeholders for future sync and help surfaces.

## Shared Components Inventory

| Component | Description | Used In |
|-----------|-------------|---------|
| `ActivityCard` | Rounded card with icon, title, quick-start affordance | Today grids, Search results |
| `ActivityGrid` | Responsive two-column container | Favorites, Recent Activities |
| `TimerBanner` | Persistent sash with active timer controls | Today, History (active) |
| `SummaryTile` | Full-width daily totals with progress bars | Today summary |
| `TrendChart` | Weekly line chart for activity trends | History Month |
| `EditableListRow` | Swipe-enabled row with edit/delete | Manage Activities, History Day |
| `FavoritesGrid` | Drag-and-drop reorder grid | Favorites editor |

## State, Data & Background Behavior
- View models publish state structs (e.g., `TimerViewState`) to keep rendering deterministic and testable.
- Intents call use cases asynchronously via Combine or Swift Concurrency; results map to published state updates.
- Core Data stack: lightweight container with main/read context, background write contexts, and swap-in in-memory stores for testing.
- Entities: `ActivityGroup`, `Activity`, `TimerEntry`, `AppSettings`; repositories map them to domain structs before presentation.
- Background refresh reconciles timers on foreground events; significant time change notifications trigger use cases to avoid drift.
- Future sync adapters can observe repository outputs and push externally without presentation changes.

## Interaction Flows
1. **Start Timer:** Tap `ActivityCard` → animation feedback → `TimerBanner` updates → Today summary refreshes.
2. **Switch Timer:** Tap another card → previous timer auto-stops → toast confirms switch → state propagates to history.
3. **Edit Entry:** Swipe entry in History → `Edit` → Entry Maintenance sheet → save routes through `UpdateEntryWindow` use case, refreshing listings.
4. **Export Data:** Settings → `Export` card → choose period/format → `GenerateExport` builds file → share sheet presented.

## Use Case Scenarios

### Timer Management
- **Start tracking from Today:** With no active timer, tapping a favorite begins a new entry, updates the banner, and highlights the active card.
- **Switch without overlap:** Tapping a different favorite stops the current timer, starts the new one, and splits time correctly in the summary.
- **Start from search:** Selecting a search result stops any running timer, starts the selected activity, and dismisses the modal.
- **Background continuity:** A running timer continues while the device is locked, and elapsed time is accurate on return with no duplicates.

### Activity Catalog Management
- **Create group and activity:** Adding a "Hiring" group with "Candidate Interview" surfaces the group immediately and exposes the activity for pinning/search.
- **Pin and reorder favorites:** Favoriting "Performance Review" and dragging it above "Weekly 1:1" persists ordering across launches.
- **Search the catalog:** Typing "bug" filters activities/groups to relevant matches and starting one auto-stops any active timer.

### History & Summaries
- **Review daily totals:** The Today summary panel lists each activity with accurate durations and expandable recent entries.
- **Inspect weekly rollups:** Week view aggregates by group, allows drill-down into activities, and totals align with the displayed groups.
- **Compare monthly trends:** Month view charts weekly contributions for a selected activity and supports switching without leaving the view.

### Entry Maintenance
- **Adjust time window:** Editing a "Code Review" entry shifts the start time while preserving integrity and updating daily totals.
- **Reassign activity:** Changing an entry from "Standup" to "Bug Triage" keeps duration intact and updates all rollups.
- **Delete incorrect entry:** Removing an erroneous entry immediately updates history and summary totals.

### Data Ownership & Sharing
- **Offline access:** In airplane mode, users can view history, manage timers, and keep data on-device without prompts.

## Styling & Accessibility
- Color palette adapts via semantic colors; dark mode supported automatically.
- Typography: SF Pro (Title2 headers, Headline cards, Footnote metadata).
- Icons: SF Symbols (regular weight) with consistent tinting.
- Animations: Spring transitions on timer start/stop; matched geometry for card-to-sheet transitions.
- Accessibility: Dynamic Type support (grids collapse to one column), tap targets ≥ 44pt, VoiceOver labels include activity group context, color cues paired with icons.

## Testing & Quality Strategy
- **Unit tests:** View models and use cases with mocked repositories to check logic (auto-switching, validation).
- **Integration tests:** In-memory Core Data stack validating repository queries and exports.
- **UI tests:** XCTest with SwiftUI accessibility identifiers covering start/switch timer, edit entry, export flows.

## Future Extensions
- **Sync Adapter:** Optional `CloudSyncService` listening to repositories for iCloud integration.
- **Automation Hooks:** Widgets and Shortcuts reuse domain use cases through thin intent handlers.
- **Analytics:** Injectable analytics service for optional usage tracking.
- **UI Enhancements:** Lock screen widgets, Apple Watch companion, productivity streaks within History views.

