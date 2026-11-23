import SwiftUI

struct PokedexGridView: View {
    let viewModel: PokedexViewModel
    let onSelect: (Pokemon) -> Void
    let onRetry: () -> Void
    
    @Environment(\.viewModels) private var viewModels

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )

    var body: some View {
        
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Загружаем покемонов…")

        case .loaded(let pokemon):
            if pokemon.isEmpty {
                ContentUnavailableView(
                    "Каталог пуст",
                    systemImage: "square.grid.2x2"
                )
            }  else {
                content
            }
        
        case .failed(let error):
            VStack(spacing: 12) {
                Text("Не удалось загрузить каталог \(error)")
                Button("Повторить", action: onRetry)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if case .loaded(let pokemon) = viewModel.state {
            ScrollView {
                LazyVStack(spacing: 16) {
                    LazyVGrid(columns: columns, spacing: 8) {
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
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
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
