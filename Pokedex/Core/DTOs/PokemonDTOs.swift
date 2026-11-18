import Foundation

nonisolated struct PokemonPageDTO: Decodable, Sendable {
    struct Entry: Decodable, Sendable {
        let name: String
        let url: URL
    }

    let results: [Entry]
}
