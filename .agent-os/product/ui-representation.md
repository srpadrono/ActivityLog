# ActivityLog UI Representation

## Navigation Overview

```
Root Tab Bar
├─ Today
│  ├─ Activity Stack (Favorites, Recents)
│  ├─ Running Timer Banner
│  └─ Summary Sheet (slide-up)
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

- Tab bar surfaced by `RootCoordinator` with inline titles for each section.
- Each tab hosts a navigation stack to support push or modal presentations when drilling into details.

## Primary Screens

### Today Dashboard
- **Header:** Date selector, quick access to history (chevron button).
- **Favorites Grid:** Two-column card grid highlighting pinned activities with icon, name, and optional total for the day.
- **Recents Row:** Horizontal scroll of recently used activities.
- **Running Timer Banner:** Fixed strip at the bottom showing active activity, elapsed time, stop/switch actions.
- **Summary Peek:** Collapsible sheet at the bottom showing total logged time and top three activities; expands to full summary modal.

### Search & Start Flow
- **Invoke:** Search icon in Today header or pull-down gesture.
- **Search Sheet:** Full-screen modal with search field, segmented control (`All`, `Groups`, `Activities`), and grouped results list.
- **Result Cells:** Display activity name, group, and quick start button (`►`). Selecting a row dismisses the sheet and starts tracking.
- **Empty State:** Illustration with copy "No matches yet" and CTA to create a new activity (routes to Manage Activities).

### History & Summaries
- **Segmented Control:** `Day`, `Week`, `Month` anchored at top.
- **Insight Cards:** Summary of total logged hours, top activity, and variance vs. previous period.
- **Timeline List (Day):** chronological list of entries with start/end, duration, edit button.
- **Group Rollup (Week):** stacked bars per group, expandable to show activities.
- **Trend Chart (Month):** line chart for selected activity with weekly markers and callouts.

### Manage Activities
- **Grouped List:** Section headers per `ActivityGroup` with inline count of activities.
- **Row Actions:** Pin, reorder via drag handle, edit, delete.
- **Add Toolbar:** `+ Group` and `+ Activity` buttons opening modal forms.
- **Favorites Editor:** Modal grid showing pinned activities with drag-to-reorder handles.

### Entry Maintenance Sheet
- **Header:** Activity name with change button.
- **Time Pickers:** Start and end time selectors with validation messages for overlaps.
- **Notes Field:** Optional short text area.
- **Action Row:** `Save`, `Delete`, `Cancel` buttons; destructive action styled inline.

### Settings & Export
- **Sections:** `Data & Export`, `Preferences`, `Help`.
- **Export Card:** Shows selected period, format toggle (CSV/PDF), and `Share` button invoking system sheet.
- **Offline Indicator:** Banner confirming data is on-device with toggle for future sync (disabled until feature ships).

## Component Inventory

| Component | Description | Reused In |
|-----------|-------------|-----------|
| `ActivityCard` | Rounded SwiftUI card showing icon, name, total, start button | Today Favorites, Search Results |
| `TimerBanner` | Persistent sash with active timer controls | Today, History (when active) |
| `SummaryList` | Vertical list summarizing durations with progress bars | Today Summary, History Week View |
| `TrendChart` | SwiftUI chart plotting weekly totals | History Month View |
| `EditableListRow` | Swipe-enabled row with edit/delete actions | Manage Activities, History Day Timeline |
| `FavoritesGrid` | Drag-and-drop reorder grid | Manage Favorites modal |

## Visual Styling Notes

- **Color Palette:** Light theme default using SF Symbols accent colors; dark mode automatically adjusts via semantic colors.
- **Typography:** SF Pro styles: Title2 for headers, Headline for cards, Footnote for metadata.
- **Iconography:** SF Symbols with consistent weight (regular) and monocolor accents.
- **Animations:** Spring animation on timer start/stop, matched geometry for card-to-sheet transitions.

## Interaction Flow Highlights

1. **Start Timer:** Tap `ActivityCard` → shows quick animation → `TimerBanner` updates → summary counts refresh.
2. **Switch Timer:** Tap different card → previous timer auto-stops → snackbar-style toast confirms switch.
3. **Edit Entry:** From History timeline, swipe entry → tap `Edit` → Entry Maintenance sheet → save updates, list refreshes.
4. **Export Data:** Navigate to Settings → tap `Export` → select period → share sheet appears with generated file.

## Accessibility Considerations

- Support Dynamic Type with responsive layouts (favorites grid adapts to single column when large text).
- Ensure tappable targets ≥ 44pt, and provide VoiceOver labels including activity group context.
- Use color and icons together to indicate active timers for better contrast compliance.

## Future UI Enhancements

- Add lock screen widgets displaying active timer and quick actions.
- Provide Apple Watch companion glance to start/stop timers remotely.
- Introduce productivity streak visualizations in History to motivate consistent logging.

This representation outlines the core user interface so designers and engineers can align on layout, component reuse, and interaction patterns before implementation.
