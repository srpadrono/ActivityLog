import SwiftUI

@MainActor
protocol TodayViewModeling: ObservableObject {
    var viewState: TodayView.ViewState { get }
}

struct TodayView<ViewModel: TodayViewModeling>: View {
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: sectionSpacing) {
                header
                TimerBanner(model: viewModel.viewState.timer)
                    .accessibilityIdentifier("today.timerBanner")
                FavoritesGrid(title: viewModel.viewState.favoritesTitle, cards: viewModel.viewState.favorites)
                    .accessibilityIdentifier("today.favorites")
                recentsSection
                    .accessibilityIdentifier("today.recents")
                SummaryPeek(state: viewModel.viewState.summaryPeek)
                    .accessibilityIdentifier("today.summaryPeek")
                SummaryList(title: viewModel.viewState.summaryListTitle, state: viewModel.viewState.summaryList)
                    .accessibilityIdentifier("today.summaryList")
                if let footer = viewModel.viewState.summaryFooter, !footer.isEmpty {
                    Text(footer)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                        .accessibilityIdentifier("today.summaryFooter")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
        }
        .background(backgroundColor.ignoresSafeArea())
        .navigationTitle(viewModel.viewState.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.viewState.title)
                    .font(.largeTitle.bold())
                    .accessibilityIdentifier("today.header.title")
                Text(viewModel.viewState.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            headerAction
        }
        .padding(.top, 4)
        .accessibilityIdentifier("today.header")
    }

    private var headerAction: some View {
        Button(action: {}) {
            Image(systemName: "magnifyingglass")
                .font(.title3.weight(.semibold))
                .padding(12)
                .background(Circle().fill(Color.accentColor.opacity(0.12)))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("today.header.search")
        .accessibilityLabel(viewModel.viewState.searchButtonLabel)
        .disabled(true)
    }

    private var recentsSection: some View {
        RecentsScroller(title: viewModel.viewState.recentsTitle, state: viewModel.viewState.recents)
            .padding(dynamicPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(cardBorder, lineWidth: 1)
            )
    }

    private var horizontalPadding: CGFloat { 20 }
    private var verticalPadding: CGFloat { 28 }
    private var sectionSpacing: CGFloat { 24 }
    private var dynamicPadding: CGFloat { 20 }

    private var backgroundColor: Color {
#if canImport(UIKit)
        Color(uiColor: .systemGroupedBackground)
#else
        Color.secondary.opacity(0.06)
#endif
    }

    private var cardBackground: Color {
#if canImport(UIKit)
        Color(uiColor: .systemBackground)
#else
        Color.white
#endif
    }

    private var cardBorder: Color {
#if canImport(UIKit)
        Color(uiColor: .separator).opacity(0.2)
#else
        Color.secondary.opacity(0.2)
#endif
    }
}

extension TodayView {
    struct ViewState {
        var title: String
        var subtitle: String
        var searchButtonLabel: String
        var timer: TimerBanner.Model
        var favoritesTitle: String
        var favorites: [ActivityCard.Model]
        var recentsTitle: String
        var recents: RecentsScroller.State
        var summaryPeek: SummaryPeek.State
        var summaryListTitle: String
        var summaryList: SummaryList.State
        var summaryFooter: String?

        init(
            title: String,
            subtitle: String,
            searchButtonLabel: String,
            timer: TimerBanner.Model,
            favoritesTitle: String,
            favorites: [ActivityCard.Model],
            recentsTitle: String,
            recents: RecentsScroller.State,
            summaryPeek: SummaryPeek.State,
            summaryListTitle: String,
            summaryList: SummaryList.State,
            summaryFooter: String? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.searchButtonLabel = searchButtonLabel
            self.timer = timer
            self.favoritesTitle = favoritesTitle
            self.favorites = favorites
            self.recentsTitle = recentsTitle
            self.recents = recents
            self.summaryPeek = summaryPeek
            self.summaryListTitle = summaryListTitle
            self.summaryList = summaryList
            self.summaryFooter = summaryFooter
        }
    }
}

extension TodayView.ViewState {
    static var sample: Self {
        .init(
            title: "Today",
            subtitle: "Friday, Sep 27",
            searchButtonLabel: "Search activities",
            timer: .init(title: "Active Timer", tint: .green, state: .active(activity: "Prototype Build", elapsed: "18m", remaining: "12m")),
            favoritesTitle: "Favorites",
            favorites: [
                .init(title: "Strategy", subtitle: "Planning", tint: .pink, state: .idle),
                .init(title: "Design", subtitle: "High fidelity", tint: .teal, state: .active(progress: 0.4, remaining: "18m")),
                .init(title: "Research", subtitle: "Customer calls", tint: .indigo, state: .idle)
            ],
            recentsTitle: "Recents",
            recents: .active([
                .init(title: "Customer Call", detail: "Live", status: .active),
                .init(title: "Bug Bash", detail: "35m", status: .idle),
                .init(title: "Planning", detail: "Paused", status: .disabled)
            ]),
            summaryPeek: .active(title: "Today", metrics: [
                .init(title: "Focus", value: "3h 40m", delta: "+20m", trend: .up),
                .init(title: "Sessions", value: "6", delta: "+1", trend: .up),
                .init(title: "Breaks", value: "40m", delta: "-5m", trend: .down)
            ]),
            summaryListTitle: "Highlights",
            summaryList: .idle([
                .init(title: "Deep Work", detail: "Longest streak", value: "1h 15m", status: .idle),
                .init(title: "Research", detail: "Most frequent", value: "4", status: .idle),
                .init(title: "Focus Sprint", detail: "Current session", value: "22m", status: .active)
            ]),
            summaryFooter: "Weekly trends update every 15 minutes."
        )
    }
}

extension TodayView {
    @MainActor
    final class PreviewViewModel: TodayViewModeling {
        @Published var viewState: ViewState

        init(state: ViewState = .sample) {
            viewState = state
        }
    }
}

#Preview("TodayView") {
    NavigationStack {
        TodayView(viewModel: TodayView.PreviewViewModel())
    }
}

#Preview("TodayView • Empty") {
    NavigationStack {
        TodayView(viewModel: TodayView.PreviewViewModel(state: .init(
            title: "Today",
            subtitle: "Friday, Sep 27",
            searchButtonLabel: "Search activities",
            timer: .init(title: "Timer", tint: .purple, state: .idle(message: "Start when ready")),
            favoritesTitle: "Favorites",
            favorites: [],
            recentsTitle: "Recents",
            recents: .idle([]),
            summaryPeek: .loading(title: "Summary"),
            summaryListTitle: "Details",
            summaryList: .loading,
            summaryFooter: nil
        )))
    }
}
