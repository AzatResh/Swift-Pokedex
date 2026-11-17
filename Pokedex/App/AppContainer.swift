@MainActor
final class AppContainer {
    let dependencies: AppDependencies

    convenience init() {
        self.init(network: URLSessionNetworkService())
    }

    init(network: any NetworkService) {
        self.dependencies = AppDependencies(network: network)
    }

    func makePokedexViewModel() -> PokedexViewModel {
        let repository = PokedexRepository(network: dependencies.network)
        return PokedexViewModel(repository: repository)
    }
}

struct AppDependencies {
    let network: any NetworkService
}
