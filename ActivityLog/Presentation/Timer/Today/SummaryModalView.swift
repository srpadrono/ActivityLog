import SwiftUI

struct SummaryModalView: View {
    struct FeatureFlags {
        var enableMatchedGeometry: Bool = false
    }

    let title: String
    let subtitle: String?
    let peekState: SummaryPeek.State
    let listState: SummaryList.State
    let featureFlags: FeatureFlags
    let namespace: Namespace.ID?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(
        title: String,
        subtitle: String? = nil,
        peekState: SummaryPeek.State,
        listState: SummaryList.State,
        featureFlags: FeatureFlags = .init(),
        namespace: Namespace.ID? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.peekState = peekState
        self.listState = listState
        self.featureFlags = featureFlags
        self.namespace = namespace
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    summaryPeek
                    SummaryList(state: listState)
                    footer
                }
                .padding(dynamicTypeSize.isAccessibilityCategory ? 28 : 24)
                .frame(maxWidth: 720, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .background(backgroundColor.ignoresSafeArea())
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar { closeButton }
        }
        .presentationDragIndicator(.visible)
    }

    @ToolbarContentBuilder
    private var closeButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: dismiss.callAsFunction) {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title2)
            }
            .accessibilityLabel(Text("Close summary"))
        }
    }

    @ViewBuilder
    private var summaryPeek: some View {
        let content = SummaryPeek(state: peekState)
        if let namespace, featureFlags.enableMatchedGeometry {
            content
                .matchedGeometryEffect(id: SummaryModalView.geometryID, in: namespace)
        } else {
            content
        }
    }

    @ViewBuilder
    private var footer: some View {
        if let subtitle {
            Text(subtitle)
                .font(dynamicTypeSize.isAccessibilityCategory ? .body : .subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var backgroundColor: Color {
#if canImport(UIKit)
        Color(uiColor: .systemGroupedBackground)
#else
        Color.secondary.opacity(0.08)
#endif
    }
}

extension SummaryModalView {
    static let geometryID = "summary.peek"
}

#if DEBUG
struct SummaryModalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SummaryModalView(
                title: "Today",
                subtitle: "A quick look at how you spent your time.",
                peekState: .active(title: "Today", metrics: SampleData.metrics),
                listState: .idle(SampleData.items)
            )
            .previewDisplayName("Default")

            SummaryModalPreviewHarness()
                .environment(\.dynamicTypeSize, .accessibility3)
                .preferredColorScheme(.dark)
                .previewDisplayName("Matched Geometry • Accessibility")
        }
    }

    private enum SampleData {
        static let metrics: [SummaryPeek.Metric] = [
            .init(title: "Focus", value: "3h 40m", delta: "+20m", trend: .up),
            .init(title: "Meetings", value: "1h 10m", delta: "-15m", trend: .down)
        ]
        static let items: [SummaryList.Item] = [
            .init(title: "Deep Work", detail: "Longest streak", value: "1h 15m", status: .idle),
            .init(title: "Research", detail: "Sessions completed", value: "4", status: .active)
        ]
    }

    private struct SummaryModalPreviewHarness: View {
        @Namespace private var previewNamespace

        var body: some View {
            SummaryModalView(
                title: "Today",
                peekState: .loading(title: "Today"),
                listState: .loading,
                featureFlags: .init(enableMatchedGeometry: true),
                namespace: previewNamespace
            )
        }
    }
}
#endif
