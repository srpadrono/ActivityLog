# Technical Specification

This is the technical specification for the spec detailed in @.agent-os/specs/2025-09-27-today-view-foundation/spec.md

## Technical Requirements

- **Component Stage (Phase 1)**
  - Implement `ActivityCard`, `RecentsScroller`, `TimerBanner`, `SummaryPeek`, and `SummaryList` as standalone SwiftUI views under `Presentation/Timer/Components` with preview data.
  - Provide visual states for idle, active, disabled, and loading variants using simple enum-driven props so view logic stays declarative.
  - Use `ViewThatFits`/`GeometryReader` sparingly to honor Dynamic Type adjustments; ensure grid gracefully collapses to one column for extra-large sizes.
