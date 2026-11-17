import Foundation

protocol PokedexRepositoryProtocol {
  func fetchPokemons() async throws -> [Pokemon]
}

struct PokedexRepository: PokedexRepositoryProtocol {
  let network: any NetworkService

  func fetchPokemons() async throws -> [Pokemon] {
    let page = try await network.request(
      endpoint: PokeAPIEndpoint.pokemonList(limit: 20),
      responseType: PokemonPageDTO.self
    )

    return try page.results.map { entry in
      guard let id = Int(entry.url.lastPathComponent) else {
        throw PokemonMappingError.invalidID(entry.url.absoluteString)
      }

      return Pokemon(id: id, name: entry.name.capitalized)
    }
  }
}

private enum PokemonMappingError: Error {
  case invalidID(String)
}
