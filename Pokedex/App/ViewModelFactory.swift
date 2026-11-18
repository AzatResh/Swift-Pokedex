struct ViewModelFactory: Sendable {
    let container: AppContainer
}

// MARK: - Screens
extension ViewModelFactory {
    @MainActor
    func pokedex() -> PokedexViewModel {
        PokedexViewModel(repository: container.pokedexRepository)
    }
    
    @MainActor
    func pokemonDetail() -> PokemonDetailViewModel {
        PokemonDetailViewModel(
            repository: container.pokedexRepository
        )
    }
}
