final class AppContainer: Sendable {
    
    let network: any NetworkService
    let pokedexRepository: any PokemonRepositoryProtocol
    let itemRepository: any ItemRepositoryProtocol
    
    let imageColorAnalyzer: ImageColorAnalyzing
    let spriteLoader: SpriteLoader


    init(network: any NetworkService? = nil) {
        let pokedexNetwork = network ?? URLSessionNetworkService(
            baseUrl: APIConfiguration.baseURL
        )
        
        self.network = pokedexNetwork
        self.pokedexRepository = PokemonRepository(network: pokedexNetwork)
        self.itemRepository = ItemRepository(network: pokedexNetwork)
        
        self.imageColorAnalyzer = ImageColorAnalyzer()
        self.spriteLoader = SpriteLoader()
    }
    
    
    static let live = AppContainer()
}
