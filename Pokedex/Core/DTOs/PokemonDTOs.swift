import Foundation


 struct ItemDTO: Decodable, Sendable {
     let name: String
     let url: URL
}


nonisolated struct PaginatedResponseDTO: Decodable, Sendable {
    let results: [ItemDTO]
}

struct PokemonDetailDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let baseExperience: Int?
    let weight: Int
    let height: Int
}
