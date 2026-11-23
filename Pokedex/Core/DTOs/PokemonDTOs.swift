import Foundation


 struct ItemDTO: Decodable, Sendable {
     let name: String
     let url: URL
}


nonisolated struct PaginatedResponseDTO<T: Decodable & Sendable>: Decodable, Sendable {
    let results: [T]
    
    let next: URL?
}

struct PokemonDetailDTO: Decodable, Sendable {
    
    struct Sprites: Decodable {
        let frontDefault: String
        let backDefault: String
    }
    
    let id: Int
    let name: String
    let baseExperience: Int?
    let weight: Int
    let height: Int
    
    let sprites: Sprites
}
