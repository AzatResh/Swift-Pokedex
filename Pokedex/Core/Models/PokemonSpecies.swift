import SwiftData
import Foundation

@Model
final class PokemonSpecies: Identifiable {
    var id: Int
    var flavorText: String
    var genus: String
    var evolutionChainId: Int?
    
    
    init(id: Int, flavorText: String, genus: String, evolutionChainId: Int?) {
        self.id = id
        self.flavorText = flavorText
        self.genus = genus
        self.evolutionChainId = evolutionChainId
    }
}

extension PokemonSpecies {
    static func fromDTO(dto: PokemonSpeciesDTO) -> PokemonSpecies {
        
        PokemonSpecies(
            id: dto.id,
            flavorText: dto.flavorTextEntries.first?.flavorText
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "é", with: "E") ?? "" ,
            genus: dto.genera.first(where: { $0.language.name == "en"})?.genus
                .replacingOccurrences(of: "é", with: "e") ?? "",
            evolutionChainId: Int(dto.evolutionChain.url.lastPathComponent)
        )
    }
}
