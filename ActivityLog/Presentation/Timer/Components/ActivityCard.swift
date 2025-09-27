import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ActivityCard: View {
    struct Model: Identifiable, Equatable {
        enum State: Equatable {
            case idle
            case active(progress: Double, remaining: String)
            case disabled
            case loading
        }

        let id: UUID
        let title: String
        let subtitle: String
        let tint: Color
        let state: State

        init(
            id: UUID = UUID(),
            title: String,
            subtitle: String,
            tint: Color = .accentColor,
            state: State
        ) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.tint = tint
            self.state = state
        }
    }

    private let model: Model
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(model: Model) {
        self.model = model
    }

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            header
            status
        }
        .padding(padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .overlay(border)
        .overlay(loadingOverlay)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: shadowColor, radius: 6, x: 0, y: 4)
        .opacity(model.state == .disabled ? 0.55 : 1)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: model.state)
        .accessibilityElement(children: .combine)
        .accessibilityHint(accessibilityHint)
    }

    private var header: some View {
        HStack(alignment: .lastTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(titleColor)
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                Text(model.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            Spacer()
            Image(systemName: iconName)
                .font(dynamicTypeSize.isAccessibilitySize ? .title3 : .title2)
                .foregroundStyle(iconColor)
        }
    }

    @ViewBuilder
    private var status: some View {
        switch model.state {
        case .idle:
            Text("Ready when you are")
                .font(.footnote)
                .foregroundStyle(.secondary)
        case let .active(progress, remaining):
            VStack(alignment: .leading, spacing: 6) {
                ProgressView(value: progress)
                    .tint(model.tint)
                Text("Time left: \(remaining)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        case .disabled:
            Text("Disabled")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        case .loading:
            EmptyView()
        }
    }

    private var loadingOverlay: some View {
        Group {
            if case .loading = model.state {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(platformBackground.opacity(0.85))
                    ProgressView()
                        .tint(model.tint)
                }
            }
        }
    }

    private var border: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .strokeBorder(borderColor, lineWidth: 1)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(cardBackground)
    }

    private var padding: CGFloat {
        dynamicTypeSize.isAccessibilityCategory ? 20 : 16
    }

    private var spacing: CGFloat {
        dynamicTypeSize.isAccessibilityCategory ? 16 : 12
    }

    private var cornerRadius: CGFloat { dynamicTypeSize.isAccessibilityCategory ? 28 : 20 }

    private var borderColor: Color {
        switch model.state {
        case .active:
            return model.tint.opacity(0.6)
        case .disabled:
            return mutedStroke
        case .idle, .loading:
            return subtleSeparator
        }
    }

    private var shadowColor: Color {
        switch model.state {
        case .active:
            return model.tint.opacity(0.25)
        case .idle:
            return Color.black.opacity(0.08)
        case .disabled:
            return Color.clear
        case .loading:
            return Color.black.opacity(0.05)
        }
    }

    private var cardBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .secondarySystemBackground)
#else
        Color.secondary.opacity(0.1)
#endif
    }

    private var platformBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .systemBackground)
#else
        Color.white
#endif
    }

    private var mutedStroke: Color {
#if canImport(UIKit)
        Color(uiColor: .quaternaryLabel)
#else
        Color.secondary.opacity(0.2)
#endif
    }

    private var subtleSeparator: Color {
#if canImport(UIKit)
        Color(uiColor: .separator).opacity(0.3)
#else
        Color.secondary.opacity(0.15)
#endif
    }

    private var iconName: String {
        switch model.state {
        case .active:
            return "timer"
        case .idle:
            return "play.circle"
        case .disabled:
            return "slash.circle"
        case .loading:
            return "hourglass"
        }
    }

    private var iconColor: Color {
        switch model.state {
        case .active:
            return model.tint
        case .idle:
            return .secondary
        case .disabled:
            return .secondary.opacity(0.6)
        case .loading:
            return model.tint
        }
    }

    private var titleColor: Color {
        model.state == .disabled ? .secondary : .primary
    }

    private var accessibilityHint: Text {
        switch model.state {
        case .idle:
            return Text("Start \(model.title)")
        case .active:
            return Text("\(model.title) timer is running")
        case .disabled:
            return Text("\(model.title) is disabled")
        case .loading:
            return Text("Loading \(model.title) details")
        }
    }
}

#if DEBUG
struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Array(TodayComponentPreviewData.activityCards.enumerated()), id: \.offset) { _, variant in
            variant.view
                .previewDisplayName(variant.name)
        }
    }
}
#endif
