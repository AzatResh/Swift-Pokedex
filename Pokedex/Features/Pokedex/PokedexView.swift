import SwiftUI

struct PokedexView: View {

    @State private var viewModel: PokedexViewModel
    @State private var coordinator = PokedexCoordinator()
    @State private var loadAttempt = 0
    
    @Namespace private var namespace
    
    @Environment(\.viewModels) private var viewModels
    
    init(viewModel: PokedexViewModel) {
        _viewModel = State(initialValue: viewModel)
    }


    var body: some View {
        NavigationStack(path: $coordinator.path) {
            content
                .applyScreenStyle()
//                .navigationTitle("Pokédex")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Pokédex")
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
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        PokedexGridView(
            namespace: namespace,
            viewModel: viewModel,
            onSelect: { pokemon in
                coordinator.showPokemonDetail(pokemon: pokemon)
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
