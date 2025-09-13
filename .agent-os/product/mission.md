# Product Mission

## Pitch

ActivityLog is a mobile time-tracking app that helps knowledge workers, engineers, and managers capture daily activity time with one tap by providing auto-switching timers, organized activity groups, and clear day/week/month summaries.

## Users

### Primary Customers

- Individual Contributors (Engineers, Designers): Need lightweight, low-friction tracking to understand where time goes across tasks.
- People Managers (Engineering/Operations): Need accurate line management time (1:1s, reviews, hiring) for reporting and planning.

### User Personas

**Engineering Manager** (30–45 years old)
- **Role:** Line Manager for a 6–12 person team
- **Context:** Balances 1:1s, performance reviews, staffing, project reviews, and leadership meetings while being accountable for reporting time allocations.
- **Pain Points:** Manual time logs, context switching, inconsistent categories, and end-of-week reconstruction.
- **Goals:** Capture accurate time as it happens; export summaries for reporting.

**Software Engineer** (25–40 years old)
- **Role:** Individual Contributor in a product team
- **Context:** Juggles coding, code reviews, standups, bug triage, and ad-hoc help.
- **Pain Points:** Forgetting to start/stop timers, too many taps, and messy categories.
- **Goals:** One-tap start/stop with auto-switch; clear personal analytics by day/week/month.

## The Problem

### Time capture friction leads to low accuracy

Manual time tracking requires multiple taps and remembering to stop/start timers. Accuracy drops 15–30% when entries are reconstructed later, reducing trust in reports.

**Our Solution:** One-tap start with automatic stop/switch ensures exactly one active timer and immediate capture.

### Unstructured categories make reporting inconsistent

Ad-hoc labels and duplicate names across apps make summaries noisy and hard to roll up for reporting.

**Our Solution:** Activities organized into groups (e.g., “Line Management” → “1:1”, “Performance Review”) with reusable templates.

### Summaries are hard to query on-device

Many tools require exporting to analyze totals over time windows, slowing weekly reviews.

**Our Solution:** Built-in analytics with day/week/month views and per-activity totals on-device.

## Differentiators

### One-tap with auto-switching

Unlike manual start/stop tools, ActivityLog auto-stops the current timer when another activity is tapped, minimizing friction and preventing overlapping entries. This increases capture accuracy and reduces missed switches.

### Opinionated activity grouping for managers

Unlike generic timers, ActivityLog ships with structured activity groups tailored to line management and engineering workflows, improving consistency and making reports directly usable.

### Privacy-first, local-first

Unlike SaaS time trackers requiring accounts, ActivityLog stores data on-device (Core Data/SQLite) with optional export. No account required; fast, offline-by-default.

## Key Features

### Core Features

- **One-tap timers with auto-stop:** Start a new activity with a tap; previous timer stops automatically.
- **Custom activities and groups:** Organize tasks (e.g., “Line Management” → “1:1”, “Performance Review”).
- **History by day/week/month:** Built-in summaries with per-activity totals.
- **Favorites and reorder:** Pin most-used activities and drag to reorder.
- **Search:** Quickly find activities by name or group.
- **Edit entries:** Fix start/stop times, reassign activity, or delete.
- **On-device storage:** Core Data with lightweight migrations.

### Reporting & Sharing

- **Per-activity totals:** Rollups for day/week/month and custom ranges.
- **Group rollups:** Aggregate time by activity groups to match reporting needs.

