import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct SummaryPeek: View {
    struct Metric: Identifiable, Equatable {
        enum Trend: Equatable {
            case up
            case down
            case flat
        }

        let id: UUID
        let title: String
        let value: String
        let delta: String?
        let trend: Trend

        init(id: UUID = UUID(), title: String, value: String, delta: String? = nil, trend: Trend) {
            self.id = id
            self.title = title
            self.value = value
            self.delta = delta
            self.trend = trend
        }
    }

    enum State: Equatable {
        case idle(title: String, metrics: [Metric])
        case active(title: String, metrics: [Metric])
        case disabled(title: String, message: String)
        case loading(title: String)
    }

    private let state: State
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(state: State) {
        self.state = state
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            Divider()
            content
        }
        .padding(dynamicTypeSize.isAccessibilityCategory ? 24 : 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(border)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: state)
    }

    @ViewBuilder
    private var header: some View {
        switch state {
        case let .idle(title, _), let .active(title, _):
            Text(title)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title3.weight(.semibold) : .headline)
        case let .disabled(title, _):
            Text(title)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title3.weight(.semibold) : .headline)
                .foregroundStyle(.secondary)
        case let .loading(title):
            HStack(spacing: 12) {
                ProgressView()
                Text(title)
                    .font(dynamicTypeSize.isAccessibilityCategory ? .title3 : .headline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case let .idle(_, metrics), let .active(_, metrics):
            grid(for: metrics)
        case let .disabled(_, message):
            Text(message)
                .font(dynamicTypeSize.isAccessibilityCategory ? .body : .subheadline)
                .foregroundStyle(.secondary)
        case .loading:
            gridSkeleton
        }
    }

    private func grid(for metrics: [Metric]) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: gridColumnCount)
        return LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
            ForEach(metrics) { metric in
                metricView(metric)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: gridColumnCount)
    }

    private func metricView(_ metric: Metric) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(metric.title.uppercased())
                .font(.caption)
                .tracking(1.1)
                .foregroundStyle(.secondary)
            Text(metric.value)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title2.weight(.semibold) : .title3.weight(.semibold))
            if let delta = metric.delta {
                Label(delta, systemImage: trendIcon(for: metric.trend))
                    .font(.caption)
                    .foregroundStyle(trendColor(for: metric.trend))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(secondaryBackground)
        )
    }

    private var gridSkeleton: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: gridColumnCount)
        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<gridColumnCount * 2, id: \.self) { index in
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(secondaryFill.opacity(0.7))
                    .frame(height: 64)
                    .overlay(
                        ProgressView().progressViewStyle(.circular)
                    )
                    .accessibilityLabel(Text("Loading summary metric \(index + 1)"))
            }
        }
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(platformBackground)
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    private var border: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .strokeBorder(separator.opacity(0.2), lineWidth: 1)
    }

    private var gridColumnCount: Int {
        dynamicTypeSize.isAccessibilityCategory ? 1 : 2
    }

    private func trendIcon(for trend: Metric.Trend) -> String {
        switch trend {
        case .up:
            return "arrow.up"
        case .down:
            return "arrow.down"
        case .flat:
            return "minus"
        }
    }

    private func trendColor(for trend: Metric.Trend) -> Color {
        switch trend {
        case .up:
            return .green
        case .down:
            return .red
        case .flat:
            return .secondary
        }
    }

    private var secondaryBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .secondarySystemBackground)
#else
        Color.secondary.opacity(0.1)
#endif
    }

    private var secondaryFill: Color {
#if canImport(UIKit)
        Color(uiColor: .secondarySystemFill)
#else
        Color.secondary.opacity(0.12)
#endif
    }

    private var platformBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .systemBackground)
#else
        Color.white
#endif
    }

    private var separator: Color {
#if canImport(UIKit)
        Color(uiColor: .separator)
#else
        Color.secondary.opacity(0.4)
#endif
    }
}

#if DEBUG
struct SummaryPeek_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Array(TodayComponentPreviewData.summaryPeek.enumerated()), id: \.offset) { _, variant in
            variant.view
                .previewDisplayName(variant.name)
        }
    }
}
#endif
