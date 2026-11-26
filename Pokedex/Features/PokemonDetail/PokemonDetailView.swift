import SwiftUI

struct PokemonDetailView: View {
    
    let pokemon: Pokemon
    
    @State private var viewModel: PokemonDetailViewModel
    @State private var color: Color = Color.darkGrey
    @State private var textColor: Color = Color.darkGrey
    @State private var spriteBlur: CGFloat = 0
    
    @Environment(\.imageColorAnalyzer) private var imageColorAnalyzer
    @Environment(\.viewModels) private var viewModels
    
    init(pokemon: Pokemon, viewModel: PokemonDetailViewModel) {
        self.pokemon = pokemon
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .applyScreenStyle()
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.load(id: pokemon.id)
            }
            .background(Color.cardBackground)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(pokemon.name)
                        .font(Font.pixel22)
                        .foregroundStyle(textColor)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    FavoriteButton(pokemon: pokemon)
                }
            }
    }
          
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
            case .idle, .loading:
                ProgressView("Загрузка…")
                
            case .loaded(let pokemonDetail):
             
                ScrollView {
                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {
                        
                        Text(pokemonDetail.name.capitalized)
                            .font(Font.pixel16)
                            .foregroundStyle(textColor)
                            .padding(.horizontal, 16)
                        
                        HStack() {
                            Text("Height: \(pokemonDetail.height)")
                                .font(Font.pixel14)
                                .foregroundStyle(textColor)
                            Text("Weight: \(pokemonDetail.weight)")
                                .font(Font.pixel14)
                                .foregroundStyle(textColor)
                        }
                        .padding(.horizontal, 16)
                        
                        PokemonInfo(
                            pokemon: pokemon,
                            textColor: textColor,
                            viewModel: viewModels.pokemonSpecies(),
                        )
                        
                        
                        DetailSection(
                            title:  "Moves",
                            textColor: textColor
                        ){
                            Text(pokemonDetail.moves.joined(separator: ", "))
                                .font(.pixel14)
                                .foregroundStyle(textColor)
                                .lineSpacing(4)
                                .lineLimit(5)
                                .truncationMode(.tail)
                                .padding(16)
                        }
                        
                        Color.clear.frame(height: 1000)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 350)
                }
//                .scrollEdgeEffectStyle(.soft, for: .top)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    geo.contentOffset.y + geo.contentInsets.top
                } action: { _, offset in
                    // No blur for the first 160pt, then ramp up to a 12pt cap.
                    spriteBlur = min(12, max(0, (offset - 160) / 12))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background{
                    VStack {
                        SpriteImage(
                            url: pokemonDetail.sprite.front,
                        ) {
                            uiImage in
                            guard let bgColor = await  imageColorAnalyzer.dominantColor(for: pokemonDetail.id, image: uiImage)
                                    else {return}
                            
                            color = bgColor
                            textColor = bgColor.isLight ? Color.darkGrey : Color.white
                        }
                        .frame(minHeight: 120, alignment: .top)
                        .blur(radius: spriteBlur)
                        Spacer()
                    }
                    .background {
                        MeshGradientBackground(color: color).ignoresSafeArea()
                    }
            }
                
            
            case .failed:
                VStack(spacing: 12) {
                    Text("Не удалось загрузить каталог")
                }
            }
            
    }
}

struct PokemonInfo: View {
    let pokemon: Pokemon
    let textColor: Color
    
    @State private var viewModel: PokemonSpeciesViewModel
    
    init(pokemon: Pokemon, textColor: Color, viewModel: PokemonSpeciesViewModel) {
        self.pokemon = pokemon
        self.viewModel = viewModel
        self.textColor = textColor
    }
    
    var body: some View {
        content
            .task {
                await viewModel.load(id: pokemon.id)
            }
    }
    
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loaded(let species):
            
            DetailSection(
                title: species.genus,
                textColor: textColor
            ){
                Text(species.flavorText)
                    .font(.pixel14)
                    .lineSpacing(4)
                    .foregroundStyle(textColor)
                    .padding(16)
            }
        case .failed(let error):
            Text(error)
        default:
            Color.clear
        }
    }
}
