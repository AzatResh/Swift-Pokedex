import Foundation

protocol PokemonRepositoryProtocol: Sendable {
    func fetchPokemons(limit: Int, offset: Int) async throws -> PaginatedResponse<Pokemon>
    
    
    func fetchPokemon(id: Int) async throws -> PokemonDetail
    
    func fetchPokemonSpecies(id: Int) async throws -> PokemonSpecies
}

struct PokemonRepository: PokemonRepositoryProtocol {
    let network: any NetworkService
    
    func fetchPokemons(limit: Int, offset: Int) async throws -> PaginatedResponse<Pokemon> {
        let page = try await network.request(
            endpoint: PokeAPIEndpoint.pokemonList(limit: limit, offset: offset),
            responseType: PaginatedResponseDTO<ItemDTO>.self
        )
        
        let pokemons = page.results.compactMap(Pokemon.fromDTO)
        
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
    func fetchPokemonSpecies(id: Int) async throws  -> PokemonSpecies {
        let dto = try await network.request(
            endpoint: PokeAPIEndpoint.pokemonSpecies(id: id),
            responseType: PokemonSpeciesDTO.self
        )
         
        return PokemonSpecies.fromDTO(dto: dto)
    }
}
