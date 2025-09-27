import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct SummaryList: View {
    struct Item: Identifiable, Equatable {
        enum Status: Equatable {
            case idle
            case active
            case disabled
            case loading
        }

        let id: UUID
        let title: String
        let detail: String
        let value: String
        let status: Status

        init(id: UUID = UUID(), title: String, detail: String, value: String, status: Status) {
            self.id = id
            self.title = title
            self.detail = detail
            self.value = value
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

    init(title: String = "Summary Details", state: State) {
        self.title = title
        self.state = state
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title3.weight(.semibold) : .headline)
            content
        }
        .padding(dynamicTypeSize.isAccessibilityCategory ? 24 : 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(platformBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(separator.opacity(0.15), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case let .idle(items), let .active(items), let .disabled(items):
            VStack(alignment: .leading, spacing: rowSpacing) {
                ForEach(items) { item in
                    row(for: item)
                }
            }
            .opacity(matchesDisabled ? 0.5 : 1)
        case .loading:
            VStack(alignment: .leading, spacing: rowSpacing) {
                ForEach(0..<4, id: \.self) { index in
                    skeletonRow(index: index)
                }
            }
        }
    }

    private var rowSpacing: CGFloat {
        dynamicTypeSize.isAccessibilityCategory ? 20 : 12
    }

    private var matchesDisabled: Bool {
        if case .disabled = state { return true }
        return false
    }

    private func row(for item: Item) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(dynamicTypeSize.isAccessibilityCategory ? .body.weight(.semibold) : .subheadline.weight(.semibold))
                    .foregroundStyle(foreground(for: item.status))
                Text(item.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 12)
            Text(item.value)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title3.weight(.semibold) : .title3)
                .foregroundStyle(valueColor(for: item.status))
        }
        .padding(.vertical, dynamicTypeSize.isAccessibilityCategory ? 12 : 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(item.title), \(item.detail), value \(item.value)"))
    }

    private func skeletonRow(index: Int) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(secondaryFill.opacity(0.7))
                .frame(width: 140, height: 16)
            Spacer()
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(secondaryFill.opacity(0.7))
                .frame(width: 60, height: 16)
        }
        .padding(.vertical, 10)
        .overlay(
            ProgressView().progressViewStyle(.circular)
                .tint(.accentColor)
        )
        .accessibilityLabel(Text("Loading summary row \(index + 1)"))
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

    private var secondaryFill: Color {
#if canImport(UIKit)
        Color(uiColor: .secondarySystemFill)
#else
        Color.secondary.opacity(0.12)
#endif
    }

    private func foreground(for status: Item.Status) -> Color {
        switch status {
        case .idle:
            return .primary
        case .active:
            return .accentColor
        case .disabled:
            return .secondary
        case .loading:
            return .secondary
        }
    }

    private func valueColor(for status: Item.Status) -> Color {
        switch status {
        case .active:
            return .accentColor
        case .idle:
            return .primary
        case .disabled, .loading:
            return .secondary
        }
    }
}

#if DEBUG
struct SummaryList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Array(TodayComponentPreviewData.summaryList.enumerated()), id: \.offset) { _, variant in
            variant.view
                .previewDisplayName(variant.name)
        }
    }
}
#endif
