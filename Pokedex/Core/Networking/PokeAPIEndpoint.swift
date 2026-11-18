import Foundation

enum PokeAPIEndpoint: APIEndpoint {
    case pokemonList(limit: Int)
    case pokemonDetails(id: Int)

    var baseURL: String { "https://pokeapi.co/api/v2/" }
    var method: String {
        switch self {
        case .pokemonList, .pokemonDetails:
            return "GET"
//        case .addFavorite:
//            return "POST"
        }
    }

    var path: String {
        switch self {
        case .pokemonList:
            return "pokemon"
        case .pokemonDetails(let id):
            return "pokemon/\(id)"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .pokemonList(let limit):
            return [URLQueryItem(name: "limit", value: String(limit))]
        case .pokemonDetails:
            return []
        }
    }
}
