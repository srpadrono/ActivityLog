# Technical Specification

This is the technical specification for the spec detailed in @.agent-os/specs/2025-09-13-one-tap-auto-switch-timers/spec.md

## Technical Requirements

- Activity model
  - Use Core Data entities: `Activity` (id, name, group, order), `Entry` (id, activityId, startAt, endAt?).
  - A running timer is represented by an `Entry` with `endAt == nil`.
- Zero-gap auto-switching
  - On tap for Activity B while Activity A runs: set A.endAt = now; insert B entry with startAt = now; ensure no gap and no overlap.
  - Enforce ordering within a single transaction to avoid transient overlap.
- Second-tap stop
  - On tapping the currently active activity: set its endAt = now (if duration < 10s: discard per “accidental-tap guard”).
- Overlap prevention (model-level)
  - Before saving any new or edited entry, validate there is no time intersection with neighboring entries for the same user/device.
  - On creation, auto-close any existing open entry first, then insert the new one at the same timestamp.
  - On edits, clamp/shift or block edits that would create overlaps (MVP: block with user feedback).
- Accidental-tap guard (<10s)
  - Persist start immediately for resilience (background safety).
  - On stop/switch: if `duration < 10s`, delete the short entry instead of saving it, unless it later exceeds 10s.
  - On app termination with a running short entry: upon next launch, if still <10s and then immediately stopped, apply the same discard rule.
- Background persistence and resume
  - Persist running state (`Entry` with `endAt == nil`) and the current activity id.
  - On app resume/launch, compute elapsed time from `startAt`; restore UI state (“Now Running”).
  - Save state on scene transitions to avoid loss; no continuous background timers needed beyond persisted timestamps.
- UI/UX (SwiftUI)
  - Activities view: grid/list of large tap targets; selected (running) tile shows active state (color/blur/overlay) and live elapsed.
  - “Now Running” bar: persistent at top/bottom with activity name and elapsed time; tap to stop.
  - Haptics: light impact on start/switch; notification success on stop via `UIImpactFeedbackGenerator` / `UINotificationFeedbackGenerator`.
  - Visual feedback: brief pulse/scale animation on start/stop; accessibility labels updated accordingly.
- Performance
  - Use `TimelineView`/`Timer` with 1s cadence for elapsed display; avoid redundant Core Data fetches.
  - Index Core Data fetches by `startAt` to speed neighbor lookups; fetch only neighbors when validating overlaps.
- Error handling
  - If overlap validation fails on edit, present a non-blocking alert with guidance; no partial saves.
  - Ensure transactionality when switching to avoid dropped entries.

