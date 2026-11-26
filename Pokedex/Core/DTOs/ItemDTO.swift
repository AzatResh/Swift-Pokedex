import Foundation

struct ItemDetailDTO: Decodable, Sendable {
    
    struct Sprites: Decodable {
        let defaultImage: String?

        enum CodingKeys: String, CodingKey {
            case defaultImage = "default"
        }
    }
    
    
    let id: Int
    let name: String
    
    let sprites: Sprites
    
    let flavorTextEntries: [Flavor]
    
    
    struct Flavor: Decodable {
        let text: String
        let language: Language
        
        struct Language: Decodable {
            let name: String
        }
    }
}

