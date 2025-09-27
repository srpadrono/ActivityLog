import SwiftUI

public struct PreviewVariant {
    public let name: String
    public let view: AnyView
    public let maxWidth: CGFloat?

    public init<V: View>(_ name: String, maxWidth: CGFloat? = nil, @ViewBuilder content: () -> V) {
        self.name = name
        self.view = AnyView(content())
        self.maxWidth = maxWidth
    }
}
