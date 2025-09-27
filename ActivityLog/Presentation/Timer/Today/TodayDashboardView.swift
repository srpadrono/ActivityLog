import SwiftUI

struct TodayDashboardView: View {
    struct Model {
        var title: String
        var subtitle: String
        var favorites: [ActivityCard.Model]
        var recents: RecentsScroller.State
        var timer: TimerBanner.Model
        var summaryPeek: SummaryPeek.State
        var summaryList: SummaryList.State
        var summaryFooter: String?

        init(
            title: String,
            subtitle: String,
            favorites: [ActivityCard.Model],
            recents: RecentsScroller.State,
            timer: TimerBanner.Model,
            summaryPeek: SummaryPeek.State,
            summaryList: SummaryList.State,
            summaryFooter: String? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.favorites = favorites
            self.recents = recents
            self.timer = timer
            self.summaryPeek = summaryPeek
            self.summaryList = summaryList
            self.summaryFooter = summaryFooter
        }
    }

    struct FeatureFlags {
        var enableSummaryMatchedGeometry: Bool = false
        var useSummarySpringAnimation: Bool = true

        init(enableSummaryMatchedGeometry: Bool = false, useSummarySpringAnimation: Bool = true) {
            self.enableSummaryMatchedGeometry = enableSummaryMatchedGeometry
            self.useSummarySpringAnimation = useSummarySpringAnimation
        }
    }

    let model: Model
    let featureFlags: FeatureFlags
    let onOpenSummary: (() -> Void)?
    let onCloseSummary: (() -> Void)?

    @State private var isSummaryPresented = false
    @Namespace private var summaryNamespace
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(
        model: Model,
        featureFlags: FeatureFlags = .init(),
        onOpenSummary: (() -> Void)? = nil,
        onCloseSummary: (() -> Void)? = nil
    ) {
        self.model = model
        self.featureFlags = featureFlags
        self.onOpenSummary = onOpenSummary
        self.onCloseSummary = onCloseSummary
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: sectionSpacing) {
                header
                FavoritesGrid(cards: model.favorites)
                RecentsScroller(state: model.recents)
                TimerBanner(model: model.timer)
                summaryTrigger
            }
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .frame(maxWidth: 820)
            .frame(maxWidth: .infinity)
        }
        .background(backgroundColor.ignoresSafeArea())
        .sheet(isPresented: $isSummaryPresented) {
            summarySheet
        }
        .onChange(of: isSummaryPresented) { presented in
            if presented {
                onOpenSummary?()
            } else {
                onCloseSummary?()
            }
        }
    }

    private var summarySheet: some View {
        SummaryModalView(
            title: model.title,
            subtitle: model.summaryFooter,
            peekState: model.summaryPeek,
            listState: model.summaryList,
            featureFlags: .init(enableMatchedGeometry: featureFlags.enableSummaryMatchedGeometry),
            namespace: featureFlags.enableSummaryMatchedGeometry ? summaryNamespace : nil
        )
        .presentationDetents([.fraction(0.45), .large])
        .presentationCornerRadius(32)
        .presentationBackgroundInteraction(.enabled)
        .onDisappear(perform: notifyCloseIfNeeded)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.title)
                .font(dynamicTypeSize.isAccessibilityCategory ? .largeTitle.bold() : .largeTitle)
                .fontWeight(.bold)
            Text(model.subtitle)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title3 : .title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var summaryTrigger: some View {
        Button(action: presentSummary) {
            SummaryPeek(state: model.summaryPeek)
                .modifier(SummaryMatchedGeometryModifier(
                    enabled: featureFlags.enableSummaryMatchedGeometry,
                    namespace: summaryNamespace
                ))
                .overlay(triggerAccessory, alignment: .bottomTrailing)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Open summary"))
    }

    private var triggerAccessory: some View {
        Image(systemName: "chevron.up.circle.fill")
            .font(dynamicTypeSize.isAccessibilityCategory ? .title : .title2)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(Color.accentColor)
            .padding(dynamicTypeSize.isAccessibilityCategory ? 16 : 12)
    }

    private var backgroundColor: Color {
#if canImport(UIKit)
        Color(uiColor: .systemGroupedBackground)
#else
        Color.secondary.opacity(0.06)
#endif
    }

    private var sectionSpacing: CGFloat {
        dynamicTypeSize.isAccessibilityCategory ? 28 : 24
    }

    private var horizontalPadding: CGFloat {
        dynamicTypeSize.isAccessibilityCategory ? 28 : 24
    }

    private var verticalPadding: CGFloat {
        dynamicTypeSize.isAccessibilityCategory ? 32 : 28
    }

    private func presentSummary() {
        if featureFlags.useSummarySpringAnimation {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.82, blendDuration: 0.15)) {
                isSummaryPresented = true
            }
        } else {
            isSummaryPresented = true
        }
    }

    private func notifyCloseIfNeeded() {
        if isSummaryPresented {
            // The sheet is dismissing via swipe, update binding after animation completes
            DispatchQueue.main.async {
                if self.isSummaryPresented {
                    self.isSummaryPresented = false
                }
            }
        }
    }
}

private struct SummaryMatchedGeometryModifier: ViewModifier {
    let enabled: Bool
    let namespace: Namespace.ID

    func body(content: Content) -> some View {
        if enabled {
            content.matchedGeometryEffect(id: SummaryModalView.geometryID, in: namespace)
        } else {
            content
        }
    }
}

#if DEBUG
struct TodayDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodayDashboardPreviewHarness()
                .previewDisplayName("Today Dashboard")
            TodayDashboardPreviewHarness(featureFlags: .init(enableSummaryMatchedGeometry: true, useSummarySpringAnimation: true))
                .environment(\.dynamicTypeSize, .accessibility2)
                .preferredColorScheme(.dark)
                .previewDisplayName("Matched Geometry • Dark")
        }
    }

    private struct TodayDashboardPreviewHarness: View {
        private let model = TodayDashboardView.Model(
            title: "Today",
            subtitle: "Friday, Sep 27",
            favorites: SampleData.favorites,
            recents: .active(SampleData.recents),
            timer: SampleData.timer,
            summaryPeek: .active(title: "Today", metrics: SampleData.metrics),
            summaryList: .idle(SampleData.summaryItems),
            summaryFooter: "Weekly trends update every 15 minutes."
        )

        let featureFlags: TodayDashboardView.FeatureFlags

        init(featureFlags: TodayDashboardView.FeatureFlags = .init()) {
            self.featureFlags = featureFlags
        }

        var body: some View {
            TodayDashboardView(model: model, featureFlags: featureFlags)
        }

        private enum SampleData {
            static let favorites: [ActivityCard.Model] = [
                .init(title: "Strategy", subtitle: "Planning", tint: .pink, state: .idle),
                .init(title: "Design", subtitle: "High fidelity", tint: .teal, state: .active(progress: 0.4, remaining: "18m")),
                .init(title: "Research", subtitle: "Customer calls", tint: .indigo, state: .idle),
                .init(title: "QA", subtitle: "Regression suite", tint: .orange, state: .disabled)
            ]
            static let recents: [RecentsScroller.Item] = [
                .init(title: "Bug Bash", detail: "35m", status: .idle),
                .init(title: "Customer Call", detail: "Live", status: .active)
            ]
            static let timer = TimerBanner.Model(
                title: "Active Timer",
                tint: .green,
                state: .active(activity: "Prototype Build", elapsed: "18m", remaining: "12m")
            )
            static let metrics: [SummaryPeek.Metric] = [
                .init(title: "Focus", value: "3h 40m", delta: "+20m", trend: .up),
                .init(title: "Meetings", value: "1h 10m", delta: "-15m", trend: .down)
            ]
            static let summaryItems: [SummaryList.Item] = [
                .init(title: "Deep Work", detail: "Longest streak", value: "1h 15m", status: .idle),
                .init(title: "Research", detail: "Sessions completed", value: "4", status: .active)
            ]
        }
    }
}
#endif
