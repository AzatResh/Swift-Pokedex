import SwiftUI
import SwiftData

struct FavoriteView: View {
    
    @Query private var favorites: [Pokemon]
    
    @State private var coordinator = PokedexCoordinator()
    @Namespace private var namespace

    @Environment(\.viewModels) private var viewModels
    
    var body: some View {
        
        NavigationStack(path: $coordinator.path) {
            content
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Favorite")
                            .font(.pixel22)
                            .foregroundStyle(Color.white)
                    }
                }
                .toolbarBackground(Color.red, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: PokedexRoute.self) { route in
                switch route {
                case .pokemonDetail(let pokemon):
                        PokemonDetailView(
                            pokemon: pokemon,
                            viewModel: viewModels.pokemonDetail()
                        ).navigationTransition(
                            .zoom(
                                sourceID: pokemon.id,
                                in: namespace
                            )
                        )
                }
            }
        }
        
    }
    
    
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(favorites) { entry in
                        PokemonCard(
                            pokemon: entry,
                            viewModel: viewModels.pokemonDetail(),
                            onSelect: {
                                pokemon in coordinator.showPokemonDetail(pokemon: entry)
                                
                            } ,
                        )
                        .matchedTransitionSource(
                            id: entry.id,
                            in: namespace
                        )
                    }
                }
            }
            .padding(16)
        }
    }
}
