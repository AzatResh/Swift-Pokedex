final class AppContainer: Sendable {
//    let dependencies: AppDependencies
    
    let network: any NetworkService
    let pokedexRepository: any PokedexRepositoryProtocol

    convenience init() {
        self.init(network: URLSessionNetworkService())
    }

    init(network: any NetworkService) {
        self.network = network
        self.pokedexRepository = PokedexRepository(network: network)
    }
    
    
    static let live = AppContainer()
}
//
//struct AppDependencies {
//    let network: any NetworkService
//    
//    let pokedexRepository: any PokedexRepositoryProtocol
//}
