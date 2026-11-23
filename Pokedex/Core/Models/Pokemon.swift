import SwiftData


struct PaginatedResponse<T> {
    let items: [T]
    let hasNextPage: Bool
    
    init(items: [T], hasNextPage: Bool) {
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
    var types: [PokemonType]
    
    init(
        id: Int,
        name: String,
        baseExperience: Int?,
        weight: Int,
        height: Int,
        sprite: Sprite,
        types: [PokemonType]
    ) {
        self.id = id
        self.name = name
        self.baseExperience = baseExperience
        self.weight = weight
        self.height = height
        self.sprite = sprite
        self.types = types
    }
    
}

extension PokemonDetail {
    static func fromDTO(dto: PokemonDetailDTO) -> PokemonDetail {
        PokemonDetail(
            id : dto.id,
            name : dto.name,
            baseExperience : dto.baseExperience,
            weight : dto.weight,
            height : dto.height,
            sprite : Sprite(front: dto.sprites.frontDefault, back: dto.sprites.backDefault),
            types:  dto.types.map{item in
                return PokemonType(slot: item.slot, name: item.type.name)
            }
        )
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

@Model
final class PokemonType {
    var slot: Int
    var name: String
    
    init(slot: Int, name: String) {
        self.slot = slot
        self.name = name
    }
}
