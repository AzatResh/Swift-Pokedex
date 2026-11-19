import SwiftData

@Model
final class PokemonResponse: Identifiable {
    let items: [Pokemon]
    let hasNextPage: Bool
    
    init(items: [Pokemon], hasNextPage: Bool) {
        self.items = items
        self.hasNextPage = hasNextPage
    }
}

@Model // @Model может сохранять локально
final class Pokemon: Identifiable {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

@Model
final class PokemonDetail: Identifiable {
    var id: Int
    var name: String
    var baseExperience: Int?
    var weight: Int
    var height: Int
    
    var sprite: Sprite
    
    init(dto: PokemonDetailDTO) {
        self.id = dto.id
        self.name = dto.name
        self.baseExperience = dto.baseExperience
        self.weight = dto.weight
        self.height = dto.height
        self.sprite = Sprite(front: dto.sprites.frontDefault, back: dto.sprites.backDefault)
    }
}


@Model
final class Sprite {
    var front: String
    var back: String?

    init(front: String, back: String?) {
        self.front = front
        self.back = back
    }
}
