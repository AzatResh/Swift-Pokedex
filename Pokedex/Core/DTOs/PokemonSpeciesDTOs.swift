import Foundation

struct PokemonSpeciesDTO: Decodable, Sendable {
    let id: Int
    let evolutionChain: EvolutionChain
    let flavorTextEntries: [FlavorText]
    let genera: [Genera]
    
    struct EvolutionChain: Decodable {
        let url: URL
    }
    
    struct FlavorText: Decodable {
        let flavorText: String
    }
    
    struct Genera: Decodable {
        let genus: String
        let language: Language
        
        struct Language: Decodable {
            let name: String
        }
    }
}
