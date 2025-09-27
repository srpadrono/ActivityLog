import SwiftUI

enum TodayDashboardPreviewData {
    static let dashboard: [PreviewVariant] = [
        PreviewVariant("Dashboard Default", maxWidth: 840) {
            TodayDashboardView(model: SampleModels.dashboardDefault)
        },
        PreviewVariant("Dashboard Accessibility", maxWidth: 840) {
            TodayDashboardView(
                model: SampleModels.dashboardDefault,
                featureFlags: .init(enableSummaryMatchedGeometry: true)
            )
            .environment(\.dynamicTypeSize, .accessibility2)
            .preferredColorScheme(.dark)
        }
    ]

    static let summaryModal: [PreviewVariant] = [
        PreviewVariant("Summary Modal Idle", maxWidth: 720) {
            SummaryModalView(
                title: "Today",
                subtitle: "Weekly trends update every 15 minutes.",
                peekState: SampleModels.summaryPeek,
                listState: SampleModels.summaryList
            )
        },
        PreviewVariant("Summary Modal Loading", maxWidth: 720) {
            SummaryModalView(
                title: "Today",
                peekState: .loading(title: "Today"),
                listState: .loading
            )
            .environment(\.dynamicTypeSize, .accessibility3)
        }
    ]

    private enum SampleModels {
        static let favorites: [ActivityCard.Model] = [
            .init(title: "Strategy", subtitle: "Planning", tint: .pink, state: .idle),
            .init(title: "Design", subtitle: "High fidelity", tint: .teal, state: .active(progress: 0.4, remaining: "18m")),
            .init(title: "Research", subtitle: "Customer calls", tint: .indigo, state: .idle),
            .init(title: "QA", subtitle: "Regression suite", tint: .orange, state: .disabled)
        ]

        static let recents: RecentsScroller.State = .active([
            .init(title: "Bug Bash", detail: "35m", status: .idle),
            .init(title: "Customer Call", detail: "Live", status: .active),
            .init(title: "Planning", detail: "Paused", status: .disabled)
        ])

        static let timer = TimerBanner.Model(
            title: "Active Timer",
            tint: .green,
            state: .active(activity: "Prototype Build", elapsed: "18m", remaining: "12m")
        )

        static let summaryPeek: SummaryPeek.State = .active(
            title: "Today",
            metrics: [
                .init(title: "Focus", value: "3h 40m", delta: "+20m", trend: .up),
                .init(title: "Meetings", value: "1h 10m", delta: "-15m", trend: .down),
                .init(title: "Sessions", value: "6", delta: "+1", trend: .up)
            ]
        )

        static let summaryList: SummaryList.State = .idle([
            .init(title: "Deep Work", detail: "Longest streak", value: "1h 15m", status: .idle),
            .init(title: "Research", detail: "Sessions completed", value: "4", status: .active),
            .init(title: "Breaks", detail: "Average per session", value: "6m", status: .idle)
        ])

        static let dashboardDefault = TodayDashboardView.Model(
            title: "Today",
            subtitle: "Friday, Sep 27",
            favorites: favorites,
            recents: recents,
            timer: timer,
            summaryPeek: summaryPeek,
            summaryList: summaryList,
            summaryFooter: "Weekly trends update every 15 minutes."
        )
    }
}

#if DEBUG
struct TodayDashboardPreviewData_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Array(TodayDashboardPreviewData.dashboard.enumerated()), id: \.offset) { _, variant in
            variant.view
                .previewDisplayName(variant.name)
        }
        ForEach(Array(TodayDashboardPreviewData.summaryModal.enumerated()), id: \.offset) { _, variant in
            variant.view
                .previewDisplayName(variant.name)
        }
    }
}
#endif
