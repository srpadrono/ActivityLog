# Spec Requirements Document

> Spec: One-Tap Auto-Switch Timers
> Created: 2025-09-13

## Overview

Implement one-tap timers that auto-switch with zero gap between activities, prevent overlaps at the data level, and provide clear haptic/visual feedback, including background persistence via Core Data.

## User Stories

### Start or Switch with One Tap

As a busy user, I want to start or switch an activity timer with a single tap so that I can capture time with no delay while moving between tasks.

Workflow: From the Activities tab, tapping an activity starts it immediately. If another timer is running, it auto-stops at the same instant and the new activity starts at that timestamp, creating zero gap.

### Stop with Second Tap

As a user, I want a second tap on the currently running activity to stop it so that I can quickly end timing without hunting for extra controls.

Workflow: Tapping the active activity tile/button stops the timer at once. A short haptic and visual state change confirms the stop.

### Background Persistence

As a user, I want timers to keep running when the app is backgrounded or relaunched so that my tracked time remains accurate across sessions.

Workflow: When backgrounded or terminated, the running state and start time persist in Core Data. On next launch, the UI restores the current running activity and elapsed time.

## Spec Scope

1. **Zero-gap auto-switching** - Tapping a new activity while one runs stops the current entry and starts the new one at the exact same timestamp (no gaps, no overlaps).
2. **Second-tap to stop** - Tapping the active activity stops its timer immediately; other activities remain idle.
3. **Overlap prevention (model-level)** - Enforce non-overlapping entries via validation and insertion logic; edits must also respect this rule.
4. **Accidental-tap guard** - Ignore taps that would create entries under 10 seconds unless another action extends them past the threshold.
5. **Feedback and UI affordances** - Provide haptic and visible state change on start/stop/switch; present an always-visible Now Running indicator.

## Out of Scope

- Advanced edge-case handling (e.g., airplane mode effects, clock skew adjustments, DST transitions).
- iCloud sync, watchOS, Siri Shortcuts/App Intents, or widgets.
- Analytics beyond basic Now Running display (e.g., live history rollups).

## Expected Deliverable

1. Starting/switching/stopping via taps behaves as specified, producing contiguous, non-overlapping entries in Core Data.
2. Accidental taps under 10 seconds do not persist as entries unless extended; haptic + visual confirmations occur on transitions.
3. Backgrounding/termination preserves the running timer and restores UI state on next launch.

