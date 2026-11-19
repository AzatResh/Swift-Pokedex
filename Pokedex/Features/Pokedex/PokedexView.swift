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
            VStack {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Pokédex")
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
        .task(id: loadAttempt) {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Button("Загрузить покемонов", action: retry)

        case .loading:
            ProgressView("Загружаем покемонов…")

        case .loaded(let pokemon):
            if pokemon.isEmpty {
                ContentUnavailableView(
                    "Каталог пуст",
                    systemImage: "square.grid.2x2"
                )
            } else {
                PokedexGridView(
                    viewModel: viewModel,
                    onSelect: { pokemon in
                        coordinator.showPokemonDetail(id: pokemon.id)
                    }
                )
            }

        case .failed:
            VStack(spacing: 12) {
                Text("Не удалось загрузить каталог")
                Button("Повторить", action: retry)
            }
            .padding()
        }
    }

    private func retry() {
        loadAttempt += 1
    }
}
