import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct TodayComponentsPreview: View {
    private let activityCards = SampleData.activityCards
    private let favoriteCards = SampleData.favoriteCards
    private let recents = SampleData.recents
    private let summaryMetrics = SampleData.summaryMetrics
    private let summaryItems = SampleData.summaryItems
    private let timerModel = SampleData.timerModel
    private let dashboardModel = SampleData.dashboardModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                header
                showcaseSection("Activity Cards") {
                    VStack(spacing: 16) {
                        ForEach(activityCards) { card in
                            ActivityCard(model: card)
                        }
                    }
                }
                showcaseSection("Favorites Grid") {
                    FavoritesGrid(cards: favoriteCards)
                }
                showcaseSection("Recents Scroller") {
                    RecentsScroller(state: .active(recents))
                }
                showcaseSection("Timer Banner") {
                    TimerBanner(model: timerModel)
                }
                showcaseSection("Summary Peek") {
                    SummaryPeek(state: .active(title: "Today", metrics: summaryMetrics))
                }
                showcaseSection("Summary List") {
                    SummaryList(state: .idle(summaryItems))
                }
                showcaseSection("Today Dashboard") {
                    TodayDashboardView(model: dashboardModel)
                }
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 24)
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .background(backgroundColor.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today Components Showcase")
                .font(.largeTitle.bold())
            Text("Preview the foundational building blocks for the Today dashboard in a single scrollable layout.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func showcaseSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3.weight(.semibold))
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var backgroundColor: Color {
#if canImport(UIKit)
        Color(uiColor: .systemGroupedBackground)
#else
        Color.secondary.opacity(0.1)
#endif
    }
}

private enum SampleData {
    static let activityCards: [ActivityCard.Model] = [
        .init(title: "Design Review", subtitle: "Starts in 10m", tint: .blue, state: .idle),
        .init(title: "Focus Sprint", subtitle: "Elapsed 18m", tint: .green, state: .active(progress: 0.6, remaining: "12m")),
        .init(title: "Team Retro", subtitle: "Disabled by admin", tint: .orange, state: .disabled),
        .init(title: "Loading", subtitle: "Fetching data", tint: .purple, state: .loading)
    ]

    static let favoriteCards: [ActivityCard.Model] = [
        .init(title: "Strategy", subtitle: "Planning", tint: .pink, state: .idle),
        .init(title: "Design", subtitle: "High fidelity", tint: .teal, state: .active(progress: 0.4, remaining: "18m")),
        .init(title: "Research", subtitle: "Customer calls", tint: .indigo, state: .idle),
        .init(title: "QA", subtitle: "Regression suite", tint: .orange, state: .disabled)
    ]

    static let recents: [RecentsScroller.Item] = [
        .init(title: "Customer Call", detail: "Live", status: .active),
        .init(title: "Bug Bash", detail: "35m", status: .idle),
        .init(title: "Planning", detail: "Paused", status: .disabled)
    ]

    static let summaryMetrics: [SummaryPeek.Metric] = [
        .init(title: "Focus", value: "3h 40m", delta: "+20m", trend: .up),
        .init(title: "Breaks", value: "40m", delta: "-5m", trend: .down),
        .init(title: "Sessions", value: "6", delta: "+1", trend: .up),
        .init(title: "Resets", value: "2", delta: "=", trend: .flat)
    ]

    static let summaryItems: [SummaryList.Item] = [
        .init(title: "Deep Work", detail: "Longest streak", value: "1h 15m", status: .idle),
        .init(title: "User Research", detail: "Sessions completed", value: "4", status: .idle),
        .init(title: "Breaks", detail: "Average per session", value: "6m", status: .idle),
        .init(title: "Focus Sprint", detail: "Current session", value: "22m", status: .active)
    ]

    static let timerModel = TimerBanner.Model(
        title: "Active Timer",
        tint: .green,
        state: .active(activity: "Prototype Build", elapsed: "18m", remaining: "12m")
    )

    static let dashboardModel = TodayDashboardView.Model(
        title: "Today",
        subtitle: "Friday, Sep 27",
        favorites: favoriteCards,
        recents: .active(recents),
        timer: timerModel,
        summaryPeek: .active(title: "Today", metrics: summaryMetrics),
        summaryList: .idle(summaryItems),
        summaryFooter: "Weekly trends update every 15 minutes."
    )
}

#if DEBUG
struct TodayComponentsPreview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodayComponentsPreview()
                .previewDisplayName("Default")
            TodayComponentsPreview()
                .environment(\.dynamicTypeSize, .accessibility3)
                .preferredColorScheme(.dark)
                .previewDisplayName("Accessibility • Dark")
        }
    }
}
#endif
