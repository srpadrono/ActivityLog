import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct FavoritesGrid: View {
    let title: String
    let cards: [ActivityCard.Model]
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(title: String = "Favorites", cards: [ActivityCard.Model]) {
        self.title = title
        self.cards = cards
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(dynamicTypeSize.isAccessibilityCategory ? .title3.weight(.semibold) : .headline)
            grid
        }
        .padding(dynamicTypeSize.isAccessibilityCategory ? 24 : 20)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(platformBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(separator.opacity(0.2), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: dynamicTypeSize)
    }

    private var grid: some View {
        AdaptiveGrid(columns: columnCount, spacing: 16) {
            ForEach(cards) { card in
                ActivityCard(model: card)
            }
        }
    }

    private var columnCount: Int {
        dynamicTypeSize.isAccessibilityCategory ? 1 : 2
    }
}

private struct AdaptiveGrid<Content: View>: View {
    let columns: Int
    let spacing: CGFloat
    @ViewBuilder var content: () -> Content

    var body: some View {
        if columns <= 1 {
            VStack(alignment: .leading, spacing: spacing) {
                content()
            }
        } else {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns), spacing: spacing) {
                content()
            }
        }
    }
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

#if DEBUG
struct FavoritesGrid_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Array(TodayComponentPreviewData.favoritesGrid.enumerated()), id: \.offset) { _, variant in
            variant.view
                .previewDisplayName(variant.name)
        }
    }
}
#endif
