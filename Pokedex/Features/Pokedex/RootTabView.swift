import SwiftUI

struct RootTabView: View {
    private enum Tabs: Hashable {
        case pokedex
        case favorites
        case items
    }
    
    @State private var selectedTab: Tabs = .pokedex
    
    @Environment(\.viewModels) private var viewModels
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                "Pokedex",
                systemImage: "square.grid.3x3.fill",
                value: Tabs.pokedex,
                content: {
                    PokedexView(viewModel: viewModels.pokedex())
                }
            )
            Tab(
                "Favorite",
                systemImage: "heart.fill",
                value: Tabs.favorites,
                content: {
                    FavoriteView()
                }
            )
            Tab(
                "Items",
                systemImage: "xmark.triangle.circle.square.fill",
                value: Tabs.items,
                content: {
                    ItemsView(viewModel: viewModels.itemsView())
                }
            )
            
        }
        .tint(.red)
        
        
    }
}
