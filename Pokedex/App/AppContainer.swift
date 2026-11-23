final class AppContainer: Sendable {
//    let dependencies: AppDependencies
    
    let network: any NetworkService
    let pokedexRepository: any PokemonRepositoryProtocol
    let imageColorAnalyzer: ImageColorAnalyzing
    let spriteLoader: SpriteLoader

    convenience init() {
        self.init(network: URLSessionNetworkService())
    }

    init(network: any NetworkService) {
        self.network = network
        self.pokedexRepository = PokemonRepository(network: network)
        self.imageColorAnalyzer = ImageColorAnalyzer()
        self.spriteLoader = SpriteLoader()
    }
    
    
    static let live = AppContainer()
}
//
//struct AppDependencies {
//    let network: any NetworkService
//    
//    let pokedexRepository: any PokedexRepositoryProtocol
//}
