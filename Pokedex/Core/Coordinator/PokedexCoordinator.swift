import Observation

enum PokedexRoute: Hashable {
    case pokemonDetail(id: Int)
}


@Observable
final class PokedexCoordinator {
    var path: [PokedexRoute] = []

    func showPokemonDetail(id: Int) {
        path.append(.pokemonDetail(id: id))
    }

    func popToRoot() {
        path.removeAll()
    }
}
