struct ViewModelFactory: Sendable {
    let container: AppContainer
}

// MARK: - Screens
@MainActor
extension ViewModelFactory {
    func pokedex() -> PokedexViewModel {
        PokedexViewModel(repository: container.pokedexRepository)
    }
    
    func pokemonDetail() -> PokemonDetailViewModel {
        PokemonDetailViewModel(
            repository: container.pokedexRepository
        )
    }
    
    func pokemonSpecies() -> PokemonSpeciesViewModel {
        PokemonSpeciesViewModel(repository: container.pokedexRepository)
    }
}
