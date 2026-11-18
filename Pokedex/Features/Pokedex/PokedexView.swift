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
                PokedexGridView(pokemon: pokemon) { selectedPokemon in
                    coordinator.showPokemonDetail(id: selectedPokemon.id)
                }
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

struct PokedexGridView: View {
    let pokemon: [Pokemon]
    let onSelect: (Pokemon) -> Void

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(pokemon) { entry in
                    Button {
                        onSelect(entry)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("#\(entry.id)")
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(.secondary)

                            Text(entry.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(
                            Color.secondary.opacity(0.12),
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
    }
}
