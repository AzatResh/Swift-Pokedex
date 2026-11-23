import SwiftUI

struct PokedexGridView: View {
    let viewModel: PokedexViewModel
    let onSelect: (Pokemon) -> Void
    
    
    @Environment(\.viewModels) private var viewModels

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )

    var body: some View {
        if case .loaded(let pokemon) = viewModel.state {
            ScrollView {
                LazyVStack(spacing: 16) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(pokemon) { entry in
                            PokemonCard(
                                pokemon: entry,
                                viewModel: viewModels.pokemonDetail(),
                                onSelect: onSelect,
                            )
                        }
                    }
                    
                    paginationFooter
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .task(id: pokemon.count) {
                            await viewModel.loadNextPage()
                        }
                        
                }
                .padding(16)
            }
        }
    }
    
    private var paginationFooter: some View {
        VStack(spacing: 8) {
            if viewModel.nextPageFailed {
                Text("Не удалось загрузить следующую страницу")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

//                Button("Повторить") {
//                    Task {
//                        await viewModel.retryNextPage()
//                    }
//                }
            } else if viewModel.isLoadingNextPage {
                ProgressView()
            }
        }
    }
}
