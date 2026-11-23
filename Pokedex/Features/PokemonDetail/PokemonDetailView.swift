import SwiftUI

struct PokemonDetailView: View {
    
    let pokemonId: Int
    
    @State private var viewModel: PokemonDetailViewModel
    @State private var color: Color?
    @Environment(\.imageColorAnalyzer) private var imageColorAnalyzer
    
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
            .background(Color.cardBackground)
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
                    
                    SpriteImage(
                        url: pokemon.sprite.front,
                    ) {
                        uiImage in
                        guard let bgColor = await  imageColorAnalyzer.dominantColor(for: pokemonId, image: uiImage)
                                else {return}
                        
                        color = bgColor
                    }
                    .frame(
                        minHeight: 120,
                        maxHeight: 500
                    )
                    Text(pokemon.name)
                    HStack() {
                        Text("Height: \(pokemon.height)")
                        Text("Weight: \(pokemon.weight)")
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(color.ignoresSafeArea())
            
            case .failed:
                VStack(spacing: 12) {
                    Text("Не удалось загрузить каталог")
                }
            }
            
    }
}

