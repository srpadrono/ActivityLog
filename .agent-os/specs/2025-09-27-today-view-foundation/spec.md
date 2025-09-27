# Spec Requirements Document

> Spec: Today View Foundation
> Created: 2025-09-27

## Overview

Establish the Today dashboard experience so users can start, switch, and review timers from a polished SwiftUI surface. This phase focuses on building reusable UI components that unlock future wiring to domain logic.

## User Stories

### Start tracking from favorites

As a time-tracking user, I want to launch a timer with one tap from the favorites grid so that I can quickly capture my current activity without configuration friction.

A two-column grid of favorite activity cards is visible on load, each card shows icon, title, and today's total. Tapping a card animates the selection and routes intent to the dummy controller which simulates timer start feedback.

### Monitor current activity in context

As a time-tracking user, I want a persistent banner that displays my active timer so that I always see elapsed time and can stop or switch without leaving the Today view.

A running timer banner stays pinned above the tab bar, reflecting the dummy controller's active state, with controls to stop or switch that feed mocked responses back into the UI.

### Peek at daily progress

As a time-tracking user, I want to slide up a summary sheet to review today's totals so that I can confirm time allocation before the end of the day.

A collapsible summary component anchors to the bottom of the screen, exposing total logged time and top activities. Pulling it upward expands a modal with the full summary list, all driven by placeholder data until real repositories connect.

## Spec Scope

1. **UI Component Library** - Build SwiftUI components for activity cards, recents row, timer banner, and summary blocks with mocked data bindings.
2. **Today View Composition** - Assemble the Today dashboard using the new components, aligned with layout and animation guidance from UI representation.
3. **Dummy Controller Harness** - Provide a lightweight view controller and view model scaffolding that simulate timer state transitions for component testing.
4. **Coordinator Integration Hooks** - Stub navigation routes for search sheet and summary modal so coordinators can attach real flows later.
5. **Mock Repository Interfaces** - Define placeholder protocols and in-memory data providers that mirror future repository signatures for the Today view.

## Out of Scope

- Implementing real timer persistence, Core Data writes, or synchronization logic.
- Building History, Manage Activities, or Settings tabs beyond navigation stubs.
- Finalizing visual assets, haptic tuning, or accessibility copy beyond baseline labels.

## Expected Deliverable

1. Running Today tab in the app that exercises the new components with dummy data and controller logic.
2. SwiftUI previews or snapshots demonstrating the favorites grid, timer banner, and summary interactions in isolation.
3. Coordinator and repository interfaces ready for subsequent wiring to real use cases without refactoring the newly created views.
