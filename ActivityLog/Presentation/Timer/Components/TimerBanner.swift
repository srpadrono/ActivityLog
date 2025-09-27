import SwiftUI

struct TimerBanner: View {
    struct Model: Equatable {
        enum State: Equatable {
            case idle(message: String)
            case active(activity: String, elapsed: String, remaining: String)
            case disabled(reason: String)
            case loading
        }

        let title: String
        let tint: Color
        let state: State

        init(title: String, tint: Color = .accentColor, state: State) {
            self.title = title
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
        VStack(alignment: .leading, spacing: dynamicTypeSize.isAccessibilityCategory ? 16 : 12) {
            Text(model.title)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title2.weight(.semibold) : .title3.weight(.semibold))
            stateContent
        }
        .padding(dynamicTypeSize.isAccessibilityCategory ? 24 : 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(overlayBorder)
        .shadow(color: model.tint.opacity(0.35), radius: 16, x: 0, y: 8)
        .animation(.easeInOut(duration: 0.25), value: model.state)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var stateContent: some View {
        switch model.state {
        case let .idle(message):
            Text(message)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title3 : .headline)
                .foregroundStyle(.white.opacity(0.85))
        case let .active(activity, elapsed, remaining):
            VStack(alignment: .leading, spacing: 8) {
                Label {
                    Text(activity)
                        .font(dynamicTypeSize.isAccessibilityCategory ? .title3 : .headline)
                        .bold()
                } icon: {
                    Image(systemName: "flame.fill")
                        .font(.title3)
                }
                HStack(spacing: 12) {
                    metricView(title: "Elapsed", value: elapsed)
                    Divider().background(.white.opacity(0.5))
                    metricView(title: "Remaining", value: remaining)
                }
                .font(dynamicTypeSize.isAccessibilityCategory ? .body : .footnote)
            }
        case let .disabled(reason):
            Text(reason)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title3 : .headline)
                .foregroundStyle(.white.opacity(0.7))
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
        }
    }

    private func metricView(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased())
                .font(.caption)
                .tracking(1.2)
                .foregroundStyle(.white.opacity(0.55))
            Text(value)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title3.bold() : .title3)
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [model.tint, model.tint.opacity(0.75)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var overlayBorder: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .strokeBorder(.white.opacity(0.2), lineWidth: 1)
    }
}

#if DEBUG
struct TimerBanner_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Array(TodayComponentPreviewData.timerBanner.enumerated()), id: \.offset) { _, variant in
            variant.view
                .previewDisplayName(variant.name)
        }
    }
}
#endif
