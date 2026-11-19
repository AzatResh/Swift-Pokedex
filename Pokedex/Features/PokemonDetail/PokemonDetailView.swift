import SwiftUI

struct PokemonDetailView: View {
    let pokemonId: Int
    @State private var viewModel: PokemonDetailViewModel
    
    init(pokemonId: Int, viewModel: PokemonDetailViewModel) {
        self.pokemonId = pokemonId
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.load(id: pokemonId)
            }
    }
          
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
            case .idle:
                Text("Idle")
            case .loading:
                ProgressView("Загрузка…")
                
            case .loaded(let pokemon):
                VStack() {
                    
                    SpriteImage(url: URL(string: pokemon.sprite.front))
                    Text(pokemon.name)
                    HStack() {
                        Text("Height: \(pokemon.height)")
                        Text("Weight: \(pokemon.weight)")
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            case .failed:
                VStack(spacing: 12) {
                    Text("Не удалось загрузить каталог")
                }
            }
            
    }
}

