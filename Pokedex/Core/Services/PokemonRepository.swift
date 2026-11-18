import Foundation

protocol PokedexRepositoryProtocol: Sendable {
    func fetchPokemons() async throws -> [Pokemon]
    
    func fetchPokemon(id: Int) async throws -> PokemonDetail
}

struct PokedexRepository: PokedexRepositoryProtocol {
  let network: any NetworkService

  func fetchPokemons() async throws -> [Pokemon] {
    let page = try await network.request(
      endpoint: PokeAPIEndpoint.pokemonList(limit: 20),
      responseType: PaginatedResponseDTO.self
    )

    return try page.results.map { entry in
      guard let id = Int(entry.url.lastPathComponent) else {
        throw PokemonMappingError.invalidID(entry.url.absoluteString)
      }

      return Pokemon(id: id, name: entry.name.capitalized)
    }
  }


  
  func fetchPokemon(id: Int) async throws  -> PokemonDetail {
      let dto = try await network.request(
        endpoint: PokeAPIEndpoint.pokemonDetails(id: id),
        responseType: PokemonDetailDTO.self
      )
      
      return PokemonDetail(
          id: dto.id,
          name: dto.name.capitalized,
          baseExperience: dto.baseExperience,
          weight: dto.weight,
          height: dto.height
      )
  }
}

private enum PokemonMappingError: Error {
  case invalidID(String)
}
