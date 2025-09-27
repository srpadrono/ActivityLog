@testable import ActivityLog
import SwiftUI
import Testing
#if canImport(UIKit)
import UIKit
#endif

@MainActor
struct TodayComponentsPreviewTests {
    @Test("ActivityCard renders expected states")
    func activityCardRenders() {
        assertVariantsRender([
            .init(name: "Idle") {
                ActivityCard(model: .init(title: "Design Review", subtitle: "30 min focus", tint: .blue, state: .idle))
            },
            .init(name: "Active") {
                ActivityCard(model: .init(title: "Product Sync", subtitle: "Started 10m ago", tint: .green, state: .active(progress: 0.4, remaining: "20m")))
            },
            .init(name: "Disabled") {
                ActivityCard(model: .init(title: "Deep Work", subtitle: "Blocked", tint: .orange, state: .disabled))
            },
            .init(name: "Loading") {
                ActivityCard(model: .init(title: "Loading", subtitle: "...", tint: .purple, state: .loading))
            }
        ])
    }

    @Test("RecentsScroller renders state permutations")
    func recentsScrollerRenders() {
        assertVariantsRender([
            .init(name: "Idle") {
                RecentsScroller(state: .idle([
                    .init(title: "Design Review", detail: "42m", status: .idle),
                    .init(title: "Card Sorting", detail: "15m", status: .idle)
                ]))
            },
            .init(name: "Active") {
                RecentsScroller(state: .active([
                    .init(title: "Daily Standup", detail: "15m", status: .active),
                    .init(title: "Bug Bash", detail: "30m", status: .idle)
                ]))
            },
            .init(name: "Disabled") {
                RecentsScroller(state: .disabled([
                    .init(title: "Workshop", detail: "Ended", status: .disabled)
                ]))
            },
            .init(name: "Loading") {
                RecentsScroller(state: .loading)
            }
        ])
    }

    @Test("TimerBanner renders state permutations")
    func timerBannerRenders() {
        assertVariantsRender([
            .init(name: "Idle") {
                TimerBanner(model: .init(title: "Timer", tint: .purple, state: .idle(message: "Start a focus session")))
            },
            .init(name: "Active") {
                TimerBanner(model: .init(title: "Timer", tint: .green, state: .active(activity: "UX Audit", elapsed: "22m", remaining: "18m")))
            },
            .init(name: "Disabled") {
                TimerBanner(model: .init(title: "Timer", tint: .gray, state: .disabled(reason: "Timer paused by automation")))
            },
            .init(name: "Loading") {
                TimerBanner(model: .init(title: "Timer", tint: .orange, state: .loading))
            }
        ])
    }

    @Test("SummaryPeek renders grid variants")
    func summaryPeekRenders() {
        assertVariantsRender([
            .init(name: "Idle") {
                SummaryPeek(state: .idle(title: "Summary", metrics: [
                    .init(title: "Focus", value: "3h 45m", delta: "+25m", trend: .up),
                    .init(title: "Sessions", value: "6", delta: "+2", trend: .up),
                    .init(title: "Breaks", value: "45m", delta: "-10m", trend: .down)
                ]))
            },
            .init(name: "Active") {
                SummaryPeek(state: .active(title: "Today", metrics: [
                    .init(title: "Focus", value: "2h 15m", delta: "+15m", trend: .up),
                    .init(title: "Breaks", value: "30m", delta: "-5m", trend: .down)
                ]))
            },
            .init(name: "Disabled") {
                SummaryPeek(state: .disabled(title: "Summary", message: "Summary temporarily unavailable."))
            },
            .init(name: "Loading") {
                SummaryPeek(state: .loading(title: "Summary"))
            }
        ])
    }

    @Test("SummaryList renders state permutations")
    func summaryListRenders() {
        assertVariantsRender([
            .init(name: "Idle") {
                SummaryList(state: .idle([
                    .init(title: "Deep Work", detail: "Longest session", value: "1h 15m", status: .idle),
                    .init(title: "Research", detail: "Most frequent", value: "3", status: .idle)
                ]))
            },
            .init(name: "Active") {
                SummaryList(state: .active([
                    .init(title: "UX Audit", detail: "Current session", value: "22m", status: .active),
                    .init(title: "Design Review", detail: "Last session", value: "35m", status: .idle)
                ]))
            },
            .init(name: "Disabled") {
                SummaryList(state: .disabled([
                    .init(title: "Integrations", detail: "Awaiting data", value: "--", status: .disabled)
                ]))
            },
            .init(name: "Loading") {
                SummaryList(state: .loading)
            }
        ])
    }

    @Test("Favorites grid adapts dynamic type collapse")
    func favoritesGridRenders() {
        assertVariantsRender([
            .init(name: "Default Grid") {
                FavoritesGrid(cards: [
                    .init(title: "Strategy", subtitle: "Planning", tint: .pink, state: .idle),
                    .init(title: "Design", subtitle: "High fidelity", tint: .teal, state: .active(progress: 0.4, remaining: "18m")),
                    .init(title: "Research", subtitle: "Customer calls", tint: .indigo, state: .idle)
                ])
            },
            .init(name: "Accessibility Collapse") {
                FavoritesGrid(cards: [
                    .init(title: "Design", subtitle: "Wireframes", tint: .green, state: .active(progress: 0.7, remaining: "9m")),
                    .init(title: "Testing", subtitle: "Scenarios", tint: .blue, state: .idle)
                ])
                .environment(\.dynamicTypeSize, .accessibility3)
            }
        ])
    }

    private func assertVariantsRender(_ variants: [ViewVariant]) {
        #expect(!variants.isEmpty)

        for variant in variants {
            let hosting = makeHostingController(for: variant.view)
            hosting.view.setNeedsLayout()
            hosting.view.layoutIfNeeded()

            #if canImport(UIKit)
            let targetSize = CGSize(width: variant.maxWidth ?? 600, height: UIView.layoutFittingCompressedSize.height)
            let size = hosting.view.systemLayoutSizeFitting(targetSize)
            #elseif canImport(AppKit)
            hosting.view.layoutSubtreeIfNeeded()
            let size = hosting.view.fittingSize
            #else
            let size = CGSize.zero
            #endif

            #expect(size.width.isFinite && size.width > 0, "\(variant.name) failed to resolve width")
            #expect(size.height.isFinite && size.height > 0, "\(variant.name) failed to resolve height")
        }
    }

    private func makeHostingController(for view: AnyView) -> HostingController {
        #if canImport(UIKit)
        let controller = HostingController(rootView: view)
        controller.loadViewIfNeeded()
        return controller
        #elseif canImport(AppKit)
        let controller = HostingController(rootView: view)
        _ = controller.view
        return controller
        #else
        fatalError("Unsupported platform")
        #endif
    }
}

private struct ViewVariant {
    let name: String
    let maxWidth: CGFloat?
    let view: AnyView

    init<V: View>(name: String, maxWidth: CGFloat? = nil, @ViewBuilder build: () -> V) {
        self.name = name
        self.maxWidth = maxWidth
        self.view = AnyView(build())
    }
}

#if canImport(UIKit)
private final class HostingController: UIHostingController<AnyView> {
    @MainActor
    override init(rootView: AnyView) {
        super.init(rootView: rootView)
    }

    @MainActor
    @objc
    required dynamic init?(coder aDecoder: NSCoder) {
        nil
    }
}
#elseif canImport(AppKit)
private final class HostingController: NSHostingController<AnyView> {
}
#endif
