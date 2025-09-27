import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct RecentsScroller: View {
    struct Item: Identifiable, Equatable {
        enum Status: Equatable {
            case idle
            case active
            case disabled
        }

        let id: UUID
        let title: String
        let detail: String
        let status: Status

        init(id: UUID = UUID(), title: String, detail: String, status: Status) {
            self.id = id
            self.title = title
            self.detail = detail
            self.status = status
        }
    }

    enum State: Equatable {
        case idle([Item])
        case active([Item])
        case disabled([Item])
        case loading
    }

    private let title: String
    private let state: State
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(title: String = "Recents", state: State) {
        self.title = title
        self.state = state
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            content
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case let .idle(items), let .active(items), let .disabled(items):
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: itemSpacing) {
                    ForEach(items) { item in
                        pill(for: item)
                    }
                }
                .padding(.horizontal, 2)
            }
            .disabled(matchesDisabled)
            .opacity(matchesDisabled ? 0.5 : 1)
        case .loading:
            loadingSkeleton
        }
    }

    private var matchesDisabled: Bool {
        if case .disabled = state { return true }
        return false
    }

    private var itemSpacing: CGFloat {
        dynamicTypeSize.isAccessibilityCategory ? 20 : 12
    }

    private func pill(for item: Item) -> some View {
        let base = Capsule(style: .continuous)
        return VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(dynamicTypeSize.isAccessibilityCategory ? .body.bold() : .subheadline)
                .foregroundStyle(foreground(for: item.status))
            Text(item.detail)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, dynamicTypeSize.isAccessibilityCategory ? 20 : 16)
        .padding(.vertical, dynamicTypeSize.isAccessibilityCategory ? 12 : 10)
        .frame(minWidth: 120, alignment: .leading)
        .background(base.fill(background(for: item.status)))
        .overlay(base.strokeBorder(border(for: item.status), lineWidth: 1))
        .animation(.easeInOut(duration: 0.2), value: item.status)
        .accessibilityLabel(Text("\(item.title), \(item.detail)"))
    }

    private func background(for status: Item.Status) -> Color {
        switch status {
        case .active:
            return Color.accentColor.opacity(0.15)
        case .idle:
            return secondaryBackground
        case .disabled:
            return mutedFill
        }
    }

    private func border(for status: Item.Status) -> Color {
        switch status {
        case .active:
            return .accentColor
        case .idle:
            return separator.opacity(0.25)
        case .disabled:
            return separator.opacity(0.1)
        }
    }

    private func foreground(for status: Item.Status) -> Color {
        switch status {
        case .active:
            return .accentColor
        case .idle:
            return .primary
        case .disabled:
            return .secondary
        }
    }

    private var loadingSkeleton: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: itemSpacing) {
                ForEach(0..<4) { index in
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(secondaryFill.opacity(0.6))
                        .frame(width: 120, height: 52)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.accentColor)
                        )
                        .accessibilityLabel(Text("Loading recent item \(index + 1)"))
                }
            }
            .padding(.horizontal, 2)
        }
    }

    private var secondaryBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .secondarySystemBackground)
#else
        Color.secondary.opacity(0.12)
#endif
    }

    private var mutedFill: Color {
#if canImport(UIKit)
        Color(uiColor: .quaternarySystemFill)
#else
        Color.secondary.opacity(0.08)
#endif
    }

    private var separator: Color {
#if canImport(UIKit)
        Color(uiColor: .separator)
#else
        Color.secondary.opacity(0.4)
#endif
    }

    private var secondaryFill: Color {
#if canImport(UIKit)
        Color(uiColor: .secondarySystemFill)
#else
        Color.secondary.opacity(0.12)
#endif
    }
}

#if DEBUG
struct RecentsScroller_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Array(TodayComponentPreviewData.recentsScroller.enumerated()), id: \.offset) { _, variant in
            variant.view
                .previewDisplayName(variant.name)
        }
    }
}
#endif
