import SwiftUI

public enum TodayComponentPreviewData {
    public static let activityCards: [PreviewVariant] = [
        PreviewVariant("ActivityCard Idle") {
            ActivityCard(model: .init(title: "Design Review", subtitle: "Starts in 10m", tint: .blue, state: .idle))
                .padding()
                .previewLayout(.sizeThatFits)
        },
        PreviewVariant("ActivityCard Active") {
            ActivityCard(model: .init(title: "Focus Sprint", subtitle: "Elapsed 18m", tint: .green, state: .active(progress: 0.6, remaining: "12m")))
                .padding()
                .previewLayout(.sizeThatFits)
        },
        PreviewVariant("ActivityCard Disabled") {
            ActivityCard(model: .init(title: "Team Retro", subtitle: "Disabled by admin", tint: .orange, state: .disabled))
                .padding()
                .previewLayout(.sizeThatFits)
        },
        PreviewVariant("ActivityCard Loading") {
            ActivityCard(model: .init(title: "Loading", subtitle: "Fetching", tint: .purple, state: .loading))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    ]

    public static let recentsScroller: [PreviewVariant] = [
        PreviewVariant("Recents Idle", maxWidth: 420) {
            RecentsScroller(state: .idle([
                .init(title: "Synthesis", detail: "45m", status: .idle),
                .init(title: "Testing", detail: "30m", status: .idle),
                .init(title: "Exploration", detail: "20m", status: .idle)
            ]))
            .padding()
        },
        PreviewVariant("Recents Active", maxWidth: 420) {
            RecentsScroller(state: .active([
                .init(title: "Customer Call", detail: "Live", status: .active),
                .init(title: "Bug Bash", detail: "35m", status: .idle)
            ]))
            .padding()
        },
        PreviewVariant("Recents Disabled", maxWidth: 420) {
            RecentsScroller(state: .disabled([
                .init(title: "Planning", detail: "Paused", status: .disabled)
            ]))
            .padding()
        },
        PreviewVariant("Recents Loading", maxWidth: 420) {
            RecentsScroller(state: .loading)
                .padding()
        }
    ]

    public static let timerBanner: [PreviewVariant] = [
        PreviewVariant("Timer Idle", maxWidth: 500) {
            TimerBanner(model: .init(title: "Next Focus Session", tint: .purple, state: .idle(message: "Start whenever you're ready")))
                .padding()
        },
        PreviewVariant("Timer Active", maxWidth: 500) {
            TimerBanner(model: .init(title: "Active Timer", tint: .green, state: .active(activity: "Prototype Build", elapsed: "18m", remaining: "12m")))
                .padding()
        },
        PreviewVariant("Timer Disabled", maxWidth: 500) {
            TimerBanner(model: .init(title: "Timer", tint: .gray, state: .disabled(reason: "Timer disabled while offline")))
                .padding()
        },
        PreviewVariant("Timer Loading", maxWidth: 500) {
            TimerBanner(model: .init(title: "Timer", tint: .orange, state: .loading))
                .padding()
        }
    ]

    public static let summaryPeek: [PreviewVariant] = [
        PreviewVariant("Summary Idle", maxWidth: 520) {
            SummaryPeek(state: .idle(title: "Today", metrics: [
                .init(title: "Focus", value: "3h 40m", delta: "+20m", trend: .up),
                .init(title: "Breaks", value: "40m", delta: "-5m", trend: .down),
                .init(title: "Sessions", value: "6", delta: "+1", trend: .up),
                .init(title: "Resets", value: "2", delta: "=", trend: .flat)
            ]))
            .padding()
        },
        PreviewVariant("Summary Active", maxWidth: 520) {
            SummaryPeek(state: .active(title: "Today", metrics: [
                .init(title: "Focus", value: "2h 15m", delta: "+15m", trend: .up),
                .init(title: "Breaks", value: "25m", delta: "-10m", trend: .down)
            ]))
            .padding()
        },
        PreviewVariant("Summary Disabled", maxWidth: 520) {
            SummaryPeek(state: .disabled(title: "Summary", message: "Enable analytics to view summary."))
                .padding()
        },
        PreviewVariant("Summary Loading", maxWidth: 520) {
            SummaryPeek(state: .loading(title: "Summary"))
                .padding()
        }
    ]

    public static let summaryList: [PreviewVariant] = [
        PreviewVariant("SummaryList Idle", maxWidth: 520) {
            SummaryList(state: .idle([
                .init(title: "Deep Work", detail: "Longest streak", value: "1h 15m", status: .idle),
                .init(title: "User Research", detail: "Sessions completed", value: "4", status: .idle),
                .init(title: "Breaks", detail: "Average per session", value: "6m", status: .idle)
            ]))
            .padding()
        },
        PreviewVariant("SummaryList Active", maxWidth: 520) {
            SummaryList(state: .active([
                .init(title: "Focus Sprint", detail: "Current session", value: "22m", status: .active),
                .init(title: "Testing", detail: "Last session", value: "35m", status: .idle)
            ]))
            .padding()
        },
        PreviewVariant("SummaryList Disabled", maxWidth: 520) {
            SummaryList(state: .disabled([
                .init(title: "Summary", detail: "Awaiting permissions", value: "--", status: .disabled)
            ]))
            .padding()
        },
        PreviewVariant("SummaryList Loading", maxWidth: 520) {
            SummaryList(state: .loading)
                .padding()
        }
    ]

    public static let favoritesGrid: [PreviewVariant] = [
        PreviewVariant("Favorites Grid Default", maxWidth: 520) {
            FavoritesGrid(cards: [
                .init(title: "Strategy", subtitle: "Planning", tint: .pink, state: .idle),
                .init(title: "Design", subtitle: "High fidelity", tint: .teal, state: .active(progress: 0.4, remaining: "18m")),
                .init(title: "Research", subtitle: "Customer calls", tint: .indigo, state: .idle),
                .init(title: "QA", subtitle: "Regression suite", tint: .orange, state: .disabled)
            ])
            .padding()
        },
        PreviewVariant("Favorites Grid Accessibility", maxWidth: 520) {
            FavoritesGrid(cards: [
                .init(title: "Design", subtitle: "Wireframes", tint: .green, state: .active(progress: 0.7, remaining: "9m")),
                .init(title: "Testing", subtitle: "Scenarios", tint: .blue, state: .idle)
            ])
            .padding()
            .environment(\.dynamicTypeSize, .accessibility3)
        }
    ]
}
