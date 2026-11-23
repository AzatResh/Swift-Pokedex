import SwiftUI

struct PokemonCard: View {
    let pokemon: Pokemon
    let onSelect: (Pokemon) -> Void
    
    @State private var viewModel: PokemonDetailViewModel
    @State private var color: Color?
    @State private var isLightBg: Bool = false
    @Environment(\.imageColorAnalyzer) private var imageColorAnalyzer
    
    
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
                    
                case .failed(let error):
                    Text(error)
                        .font(Font.title3)
                case .loaded(let pokemonDetail):
               
                    ZStack(alignment: .center){
                        SpriteImage(
                            url: pokemonDetail.sprite.front,
                           
                        ) {
                            uiImage in
                            guard let bgColor = await imageColorAnalyzer.dominantColor(for: pokemon.id, image: uiImage)
                            else { return }
                            
                            isLightBg = bgColor.isLight
                            color = bgColor
                        }
                        .frame(height: 120)
                        
                        VStack() {
                            Text("#\(pokemonDetail.id)")
                                .font(Font.pixel16)
//                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Text(pokemonDetail.name)
                                .font(Font.pixel12)
//                                .font(.system(size: 14))
                                .foregroundStyle(isLightBg ? Color.darkGrey : .white)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                }
        }
        .buttonStyle(.plain)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
        )
        .background(
            color ?? Color.gray.opacity(0.12),
            in: RoundedRectangle(cornerRadius: 12)
        )
        .contentShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}
