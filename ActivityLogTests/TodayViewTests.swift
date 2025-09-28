@testable import ActivityLog
import SwiftUI
import Testing
#if canImport(UIKit)
import UIKit
#endif

@MainActor
struct TodayViewTests {
    @Test("TodayView renders dashboard sections")
    func todayViewRendersDashboardSections() {
        #if canImport(UIKit)
        let state = TodayView.ViewState(
            title: "Today",
            subtitle: "Friday, Sep 27",
            searchButtonLabel: "Search activities",
            timer: .init(title: "Active Timer", tint: .green, state: .active(activity: "Prototype", elapsed: "18m", remaining: "12m")),
            favoritesTitle: "Favorites",
            favorites: [
                .init(title: "Strategy", subtitle: "Planning", tint: .pink, state: .idle),
                .init(title: "Design", subtitle: "Figma", tint: .teal, state: .active(progress: 0.4, remaining: "18m"))
            ],
            recentsTitle: "Recent Activities",
            recents: .active([
                .init(title: "Customer Call", detail: "Live", status: .active),
                .init(title: "Bug Bash", detail: "35m", status: .idle)
            ]),
            summaryPeek: .active(title: "Today", metrics: [
                .init(title: "Focus", value: "3h 40m", delta: "+20m", trend: .up),
                .init(title: "Sessions", value: "6", delta: "+1", trend: .up)
            ]),
            summaryListTitle: "Highlights",
            summaryList: .idle([
                .init(title: "Deep Work", detail: "Longest session", value: "1h 15m", status: .idle),
                .init(title: "Research", detail: "Most frequent", value: "4", status: .idle)
            ]),
            summaryFooter: "Weekly trends update every 15 minutes."
        )

        let viewModel = StubViewModel(state: state)
        let hosting = UIHostingController(rootView: NavigationStack { TodayView(viewModel: viewModel) })
        hosting.loadViewIfNeeded()
        hosting.view.frame = CGRect(origin: .zero, size: CGSize(width: 390, height: 844))
        hosting.view.setNeedsLayout()
        hosting.view.layoutIfNeeded()

        let root = hosting.view!
        #expect(root.findView(withIdentifier: "today.header") != nil)
        #expect(root.findView(withIdentifier: "today.header.title") != nil)
        #expect(root.findView(withIdentifier: "today.timerBanner") != nil)
        #expect(root.findView(withIdentifier: "today.favorites") != nil)
        #expect(root.findView(withIdentifier: "today.recents") != nil)
        #expect(root.findView(withIdentifier: "today.summaryPeek") != nil)
        #expect(root.findView(withIdentifier: "today.summaryList") != nil)
        #expect(root.findView(withIdentifier: "today.summaryFooter") != nil)
        #else
        #expect(Bool(true), "Skipping TodayView layout test on unsupported platform")
        #endif
    }

    @Test("TodayView omits optional footer when absent")
    func todayViewOmitsOptionalFooter() {
        #if canImport(UIKit)
        let state = TodayView.ViewState(
            title: "Today",
            subtitle: "Friday, Sep 27",
            searchButtonLabel: "Search activities",
            timer: .init(title: "Next Focus", tint: .purple, state: .idle(message: "Start when ready")),
            favoritesTitle: "Favorites",
            favorites: [],
            recentsTitle: "Recents",
            recents: .idle([]),
            summaryPeek: .loading(title: "Summary"),
            summaryListTitle: "Details",
            summaryList: .loading,
            summaryFooter: nil
        )

        let viewModel = StubViewModel(state: state)
        let hosting = UIHostingController(rootView: TodayView(viewModel: viewModel))
        hosting.loadViewIfNeeded()
        hosting.view.frame = CGRect(origin: .zero, size: CGSize(width: 375, height: 812))
        hosting.view.setNeedsLayout()
        hosting.view.layoutIfNeeded()

        let root = hosting.view!
        #expect(root.findView(withIdentifier: "today.summaryFooter") == nil)
        #else
        #expect(Bool(true), "Skipping TodayView layout test on unsupported platform")
        #endif
    }
}

#if canImport(UIKit)
@MainActor
private final class StubViewModel: TodayViewModeling {
    @Published var viewState: TodayView.ViewState

    init(state: TodayView.ViewState) {
        viewState = state
    }
}

private extension UIView {
    func findView(withIdentifier identifier: String) -> UIView? {
        if accessibilityIdentifier == identifier {
            return self
        }
        for subview in subviews {
            if let match = subview.findView(withIdentifier: identifier) {
                return match
            }
        }
        return nil
    }
}
#endif
