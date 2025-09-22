# ActivityLog Use Case Scenarios

These BDD-style scenarios capture key user flows for ActivityLog so they can be translated directly into automated or manual tests.

## Timer Management

### Scenario: Start tracking from the Today view
- **Given** the user is on the Today view with no active timers
- **And** the favorites section lists an activity named "Code Implementation"
- **When** the user taps the "Code Implementation" card
- **Then** ActivityLog creates a new timer entry for "Code Implementation" with the current timestamp
- **And** the UI shows the timer counting up from 00:00
- **And** the activity card displays that it is the active timer

### Scenario: Switch between activities without overlap
- **Given** the "Code Review" timer has been running for at least one minute
- **And** the user can see an activity named "Weekly 1:1" in the favorites list
- **When** the user taps the "Weekly 1:1" card
- **Then** the "Code Review" timer stops at the tap timestamp
- **And** a new timer starts for "Weekly 1:1" with no overlapping duration
- **And** the Today summary splits the captured time between the two activities

### Scenario: Start an activity from search results
- **Given** the "Design Review" activity is currently active
- **And** the user opens the search sheet and types "Bug"
- **When** the user taps the "Bug Triage" result
- **Then** the "Design Review" timer stops automatically
- **And** a new "Bug Triage" timer starts immediately from the tap time
- **And** the search sheet dismisses so the user returns to the Today view with the new timer running

### Scenario: Continue tracking while the app is backgrounded
- **Given** the "On-call Support" timer is running
- **When** the user locks the device for ten minutes and later unlocks it
- **Then** the timer continues accumulating time during the background period
- **And** the elapsed time reflects the additional ten minutes when the app foregrounds
- **And** no overlapping or duplicate entries are created

## Activity Catalog Management

### Scenario: Create a custom activity inside a new group
- **Given** the user opens the Manage Activities screen
- **And** there is no existing group named "Hiring"
- **When** the user creates the "Hiring" group and adds an activity called "Candidate Interview"
- **Then** the new group appears in the catalog with "Candidate Interview" nested inside
- **And** the activity is available to pin or search for future tracking

### Scenario: Pin an activity to favorites and reorder it
- **Given** the activity "Performance Review" exists in the catalog
- **And** it is not currently favorited
- **When** the user pins "Performance Review" and drags it above "Weekly 1:1" in the favorites list
- **Then** "Performance Review" appears in favorites ahead of "Weekly 1:1"
- **And** the ordering persists after relaunching the app

### Scenario: Locate an activity with search
- **Given** the catalog contains activities named "Bug Triage" and "Incident Review"
- **When** the user types "bug" in the search field
- **Then** only activities whose names or groups match "bug" are shown
- **And** selecting a result immediately starts that activity's timer if another timer is active

## History and Summaries

### Scenario: Review the daily summary totals
- **Given** the user tracked time for "Code Implementation" (2h) and "Code Review" (1h) today
- **When** the user opens the Today summary panel
- **Then** the panel displays each activity with the correct durations
- **And** the total time logged today equals 3h
- **And** tapping an activity row expands recent entries for that activity

### Scenario: Inspect weekly rollups by group
- **Given** the user tracked time this week for activities under "Line Management" and "Project Work"
- **When** the user switches to the Week view
- **Then** the summary aggregates time by activity group (e.g., "Line Management" → 5h)
- **And** tapping a group reveals the individual activity contributions
- **And** the week total matches the sum of all displayed groups

### Scenario: Compare activity trends over a month
- **Given** the user has four weeks of data for "Hiring" and "Bug Triage"
- **When** the user opens the Month view and selects "Hiring"
- **Then** the Month view displays the total hours for "Hiring" across the selected month
- **And** the weekly breakdown shows each week's contribution to the monthly total
- **And** the user can switch to "Bug Triage" without leaving the Month view

## Entry Maintenance

### Scenario: Adjust a captured entry's time window
- **Given** a "Code Review" entry exists from 14:00 to 15:00 today
- **When** the user edits the entry to change the start time to 13:45
- **Then** the entry updates to 13:45–15:00 without creating duplicates
- **And** the daily summary reflects the additional 15 minutes for "Code Review"

### Scenario: Reassign an entry to a different activity
- **Given** a timer entry is incorrectly assigned to "Standup"
- **And** the correct activity should be "Bug Triage"
- **When** the user edits the entry and selects "Bug Triage"
- **Then** the entry moves to "Bug Triage" with its original duration intact
- **And** both the activity and group rollups update to reflect the change

### Scenario: Delete an incorrect entry
- **Given** an entry for "Performance Review" was started by mistake
- **When** the user deletes the entry from the edit screen
- **Then** the entry no longer appears in history or summaries
- **And** the total time for "Performance Review" decreases accordingly

## Data Ownership and Sharing

### Scenario: Access history while offline
- **Given** the device is in airplane mode
- **When** the user launches ActivityLog
- **Then** the user can view existing activity history without any login prompt
- **And** timers can still be started and stopped normally
- **And** all data changes remain on-device
