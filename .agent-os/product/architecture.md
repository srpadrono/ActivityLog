# ActivityLog Architecture

## Goals and Design Principles

- Prioritize instant responsiveness with on-device, offline-first behavior; no network dependency for core flows.
- Maintain a single source of truth for time entries and activity metadata through a dedicated data layer.
- Keep presentation logic declarative and testable via MVVM with lightweight view models.
- Enable incremental feature growth (e.g., future analytics, sync) by isolating domain services behind protocols.
- Favor composable modules to align with feature teams (Timers, Catalog, History) and simplify testing.

## High-Level Structure

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

- **Presentation layer:** SwiftUI views backed by ObservableObject view models. Views bind to published state and forward user intents.
- **Domain layer:** Use-case structs encapsulate application rules (e.g., `StartTimer`, `StopTimer`, `FetchSummary`). They accept repositories/services via protocols for easy mocking.
- **Data layer:** Repository implementations translate domain requests into Core Data operations, enforcing data consistency and batching writes.
- **Support services:** Shared utilities (date/time formatting, export, analytics) live in a `Services` namespace consumed by use cases.

## Module Breakdown

### Timer Module
- **Views:** Today dashboard, search sheet, running timer status.
- **View Models:** Manage active timer state, favorite ordering, quick actions.
- **Use Cases:** `StartTimer`, `SwitchTimer`, `ResumeTimer`, `ObserveActiveTimer`.
- **Repositories:** Timer repository handles timer entry creation/updates, ensures no overlaps.

### Activity Catalog Module
- **Views:** Manage Activities list, group editor, activity detail sheet.
- **Use Cases:** `CreateActivityGroup`, `AddActivity`, `PinFavorite`, `ReorderFavorites`, `SearchActivity`.
- **Data:** Activity repository manages Activity and ActivityGroup entities, caching favorite orderings.

### History & Summaries Module
- **Views:** Today/Week/Month summaries, detail drill-downs.
- **Use Cases:** `FetchDailySummary`, `FetchWeeklyGroupRollup`, `FetchMonthlyTrend`.
- **Services:** Summary calculator aggregates raw entries into rollups, memoized per period.

### Entry Maintenance Module
- **Views:** Entry edit sheet with time pickers, activity reassignment, delete confirmation.
- **Use Cases:** `UpdateEntryWindow`, `ReassignEntry`, `DeleteEntry`.
- **Repositories:** Entry repository coordinates transactional edits with Core Data context.

### Data Ownership & Export Module
- **Views:** Export options sheet, share sheet bridging to UIKit.
- **Use Cases:** `GenerateExport`, `RequestShare`.
- **Services:** CSV builder converts summary DTOs to shareable files, stored temporarily in app sandbox.

## Navigation and Coordination

- `RootCoordinator` owns the main tab navigation (Today, History, Manage Activities, Settings).
- Coordinators emit `NavigationRoute` enums consumed by SwiftUI navigation stacks, keeping routing decisions out of view models.
- Deep-link handling (e.g., quick actions, widgets) delegates into the relevant coordinator to reuse the same navigation surface.

## State Management Strategy

- View models expose `@Published` state structs (e.g., `TimerViewState`) to keep rendering deterministic.
- Intent methods (`startTimer(activityID:)`, `deleteEntry(id:)`) call domain use cases asynchronously using Combine or Swift Concurrency (`async/await`).
- Core Data changes propagate via fetched results publishers mapped to domain models, ensuring UI updates without manual refresh.

## Persistence and Data Model

- **Core Data Stack:** Lightweight container with background contexts for writes and main context for reads. Unit tests can swap in an in-memory store.
- **Entities:**
  - `ActivityGroup`: name, color/icon, ordering, relationship to `Activity`.
  - `Activity`: name, favoriteFlag, favoriteOrder, group reference.
  - `TimerEntry`: activity reference, startDate, endDate, notes, source (manual/auto).
  - `AppSettings`: preferred view, export defaults, background task configuration.
- Repository layer maps entities to domain structs (`Activity`, `TimerEntry`) before exposing them to use cases.

## Background Behavior

- Background refresh tasks ensure a single active timer by checking for missing end times when the app foregrounds.
- Significant time change notifications trigger a reconciliation use case to avoid drift when crossing midnight or time zones.
- Future enhancement: optional iCloud sync module hooking into the repository via a sync adapter without touching presentation code.

## Testing Approach

- **Unit tests:** Target view models and use cases with mocked repositories to verify logic (e.g., auto-switch behavior).
- **Integration tests:** Exercise Core Data stack in-memory to validate repository queries and export formatting.
- **UI tests:** Cover critical flows (start timer, switch, edit entry) using XCTest + SwiftUI accessibility identifiers derived from use-case scenarios.

## Folder Structure (Proposed)

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

- Dependency direction flows downward (Presentation → Domain → Data). Lower layers avoid importing upper-layer modules.
- Shared utilities (formatters, localization, theming) live under `Presentation/Shared` or `Services/Utilities` depending on responsibility.

## Future Extensions

- **Sync Adapter:** Introduce a `CloudSyncService` that observes repository changes and pushes to iCloud when enabled.
- **Automation Hooks:** Provide background widgets or Shortcuts by reusing domain use cases through a thin intent handler layer.
- **Analytics:** Add an optional analytics service logging anonymized usage, injected via dependency container so it can be disabled.

This architecture balances SwiftUI simplicity with clear separations, enabling ActivityLog to add advanced reporting and synchronization without rewriting core flows.
