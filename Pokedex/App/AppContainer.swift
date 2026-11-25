final class AppContainer: Sendable {
    
    let network: any NetworkService
    let pokedexRepository: any PokemonRepositoryProtocol
    let imageColorAnalyzer: ImageColorAnalyzing
    let spriteLoader: SpriteLoader


    init(network: any NetworkService? = nil) {
        let pokedexNetwork = network ?? URLSessionNetworkService(
            baseUrl: APIConfiguration.baseURL
        )
        
        self.network = pokedexNetwork
        self.pokedexRepository = PokemonRepository(network: pokedexNetwork)
        
        self.imageColorAnalyzer = ImageColorAnalyzer()
        self.spriteLoader = SpriteLoader()
    }
    
    
    static let live = AppContainer()
}
