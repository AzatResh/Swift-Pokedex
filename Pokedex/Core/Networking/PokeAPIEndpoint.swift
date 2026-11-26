import Foundation

enum PokeAPIEndpoint: APIEndpoint {
    case pokemonList(limit: Int, offset: Int)
    case pokemonDetails(id: Int)
    case pokemonSpecies(id: Int)

//    var baseURL: String { "https://pokeapi.co/api/v2/" }
    var method: String {
        switch self {
        case .pokemonList, .pokemonDetails, .pokemonSpecies:
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
        case .pokemonSpecies(let id):
            return "pokemon-species/\(id)"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .pokemonList(let limit, let offset):
            return [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset)),
        ]
        case .pokemonDetails:
            return []
            
        case .pokemonSpecies:
            return []
        }
    }
}


enum ItemAPIEndpoint: APIEndpoint {
    case itemList(limit: Int, offset: Int)
    case itemDetail(id: Int)


    
    var method: String {
        switch self {
        case .itemList, .itemDetail:
            return "GET"
        }
    }

    var path: String {
        switch self {
        case .itemList:
            return "item"
        case .itemDetail(let id):
            return "item/\(id)"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .itemList(let limit, let offset):
            return [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset)),
            ]
        case .itemDetail:
            return []
        }
    }
}
