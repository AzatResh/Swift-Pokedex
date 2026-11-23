import Foundation

protocol PokedexRepositoryProtocol: Sendable {
    func fetchPokemons(limit: Int, offset: Int) async throws -> PaginatedResponse<Pokemon>
    
    
    func fetchPokemon(id: Int) async throws -> PokemonDetail
}

struct PokedexRepository: PokedexRepositoryProtocol {
    let network: any NetworkService
    
    func fetchPokemons(limit: Int, offset: Int) async throws -> PaginatedResponse<Pokemon> {
        let page = try await network.request(
            endpoint: PokeAPIEndpoint.pokemonList(limit: limit, offset: offset),
            responseType: PaginatedResponseDTO<ItemDTO>.self
        )
        
        let pokemons = try page.results.map { entry in
            guard let id = Int(entry.url.lastPathComponent) else {
                throw PokemonMappingError.invalidID(entry.url.absoluteString)
            }
            return Pokemon(id: id, name: entry.name.capitalized)
        }
        
        return PaginatedResponse<Pokemon>(
            items: pokemons,
            hasNextPage: page.next != nil,
        )
    }
    
    
    
    
    func fetchPokemon(id: Int) async throws  -> PokemonDetail {
        let dto = try await network.request(
            endpoint: PokeAPIEndpoint.pokemonDetails(id: id),
            responseType: PokemonDetailDTO.self
        )
        
        return PokemonDetail.fromDTO(dto: dto)
    }
}

private enum PokemonMappingError: Error {
  case invalidID(String)
}
