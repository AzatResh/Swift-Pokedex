import SwiftUI

struct PokedexView: View {
    @State private var viewModel: PokedexViewModel

   init(viewModel: PokedexViewModel) {
       _viewModel = State(initialValue: viewModel)
   }

    @Environment(\.viewModels) private var viewModels
    @State private var coordinator = PokedexCoordinator()
    @State private var loadAttempt = 0

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            content
                .background(Color.cardBackground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .navigationTitle("Pokédex")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Pokédex")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(Color.white)
                    }
                }
                .toolbarBackground(Color.red, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: PokedexRoute.self) { route in
                    switch route {
                    case .pokemonDetail(let pokemonId):
                            PokemonDetailView(
                                pokemonId: pokemonId,
                                viewModel: viewModels.pokemonDetail()
                            )
                    }
                }
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        PokedexGridView(
            viewModel: viewModel,
            onSelect: { pokemon in
                coordinator.showPokemonDetail(id: pokemon.id)
            },
            onRetry: {
                loadAttempt += 1
            }
        )
    }

    private func retry() {
        loadAttempt += 1
    }
}
