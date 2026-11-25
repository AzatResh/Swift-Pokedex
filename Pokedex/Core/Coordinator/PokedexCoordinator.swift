import Observation
import SwiftUI

enum PokedexRoute: Hashable {
    case pokemonDetail(pokemon: Pokemon)
}


@Observable
final class PokedexCoordinator {
    var path: [PokedexRoute] = []

    func showPokemonDetail(pokemon: Pokemon) {
        path.append(.pokemonDetail(pokemon: pokemon))
    }

    func popToRoot() {
        path.removeAll()
    }
    
    func transition(
        in namespace: Namespace.ID,
        pokemonID: Int
    ) -> some NavigationTransition {
        .zoom(sourceID: pokemonID, in: namespace)
    }
}
