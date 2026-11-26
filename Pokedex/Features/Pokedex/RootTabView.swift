import SwiftUI

struct RootTabView: View {
    private enum Tabs: Hashable, CaseIterable {
        case pokedex
        case favorites
        case items

        var title: String {
            switch self {
            case .pokedex: "Pokedex"
            case .favorites: "Favorite"
            case .items: "Items"
            }
        }

        var icon: String {
            switch self {
            case .pokedex: "square.grid.3x3.fill"
            case .favorites: "heart.fill"
            case .items: "bag.fill"
            }
        }
    }

    @State private var selectedTab: Tabs = .pokedex

    @Environment(\.viewModels) private var viewModels

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                "Pokedex",
                systemImage: Tabs.pokedex.icon,
                value: Tabs.pokedex
            ) {
                PokedexView(viewModel: viewModels.pokedex())
                    .toolbar(.hidden, for: .tabBar)
            }

            Tab(
                "Favorite",
                systemImage: Tabs.favorites.icon,
                value: Tabs.favorites
            ) {
                FavoriteView()
                    .toolbar(.hidden, for: .tabBar)
            }

            Tab(
                "Items",
                systemImage: Tabs.items.icon,
                value: Tabs.items
            ) {
                ItemsView(viewModel: viewModels.itemsView())
                    .toolbar(.hidden, for: .tabBar)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomBar
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }

    private var bottomBar: some View {
        HStack(spacing: 0) {
            ForEach(Tabs.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22))

                        Text(tab.title)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundStyle(
                        selectedTab == tab
                            ? Color.pokedexRed
                            : Color.gray
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(
                    selectedTab == tab ? .isSelected : []
                )
            }
        }
        .padding(.vertical, 12)
        .background {
            Color.cardBackground
                .ignoresSafeArea(edges: .bottom)
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
        }
    }
}
