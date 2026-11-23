import SwiftUI

struct PokemonCard: View {
    let pokemon: Pokemon
    let onSelect: (Pokemon) -> Void
    
    @State private var viewModel: PokemonDetailViewModel
    
    
    init(
        pokemon: Pokemon,
        viewModel: PokemonDetailViewModel,
        onSelect: @escaping (Pokemon) -> Void
    ) {
        self.pokemon = pokemon
        self.viewModel = viewModel
        self.onSelect = onSelect
    }

    
    var body: some View {
        content
            .task {
                await viewModel.load(id: pokemon.id)
            }
    }
          
    @ViewBuilder
    private var content: some View {
        
        Button {
            onSelect(pokemon)
        }
         label: {
            switch viewModel.state {
                case .idle:
                    Text("Idle")
                case .loading:
                    ProgressView("Загрузка…")
                    
                case .failed:
                    Text("Failed")
                        .font(Font.title3)
                case .loaded(let pokemonDetail):
                    ZStack(alignment: .center){
                        SpriteImage(
                            url: URL(string: pokemonDetail.sprite.front)
                        )
                        
                        VStack() {
                            Text("#\(pokemonDetail.id)")
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(pokemonDetail.name)
                                .font(.system(size: 14))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundStyle(.primary)
                        }
                        .padding(16)
                        
                        
                    }
                    
                }
        }
        .buttonStyle(.plain)
        .frame(
            maxWidth: .infinity,
            minHeight: 100,
            maxHeight: .infinity,
        )
        .background(
            Color.secondary.opacity(0.12),
            in: RoundedRectangle(cornerRadius: 14)
        )
        .contentShape(
            RoundedRectangle(cornerRadius: 14)
        )
    }
}
