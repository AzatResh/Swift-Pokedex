import SwiftUI

struct PokedexView: View {
    let viewModel: PokedexViewModel

    @State private var loadAttempt = 0

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Pokédex")
                .task(id: loadAttempt) {
                    await viewModel.load()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
            
        case .idle:
            Text("Idle")
        case .loading:
            ProgressView("Загружаем покемонов…")

        case .loaded(let pokemon):
            if pokemon.isEmpty {
                ContentUnavailableView(
                    "Каталог пуст",
                    systemImage: "list.bullet"
                )
            } else {
                PokedexGridView(pokemon: pokemon)
//                List(pokemon) { entry in
//                    NavigationLink {
//                        PokemonDetailView(pokemon: entry)
//                    } label: {
//                        HStack {
//                            Text("#\(entry.id)")
//                                .foregroundStyle(.secondary)
//
//                            Text(entry.name)
//                        }
//                    }
//                }
            }

        case .failed:
            VStack(spacing: 12) {
                Text("Не удалось загрузить каталог")

                Button("Повторить") {
                    loadAttempt += 1
                }
            }
            .padding()
        }
    }
}


struct PokedexGridView: View {
    let pokemon: [Pokemon]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(pokemon) { entry in
                    NavigationLink {
                        PokemonDetailView(pokemon: entry)
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
