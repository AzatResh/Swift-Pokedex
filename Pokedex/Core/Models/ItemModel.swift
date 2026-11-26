import Foundation
import SwiftData


@Model
class ItemModel: Identifiable{
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension ItemModel {
    static func fromDTO(dto: ItemDTO) -> ItemModel? {
        guard let id = Int(dto.url.lastPathComponent) else {
            return nil
        }
        
        return ItemModel(
            id: id,
            name: dto.name.capitalized
        )
    }
}


@Model
class ItemDetail {
    
    var id: Int
    var name: String
    
    var flavorText: String 
    var sprite: String?
    
    init(id: Int, name: String, flavorText: String, sprite: String?) {
        self.id = id
        self.name = name
        self.flavorText = flavorText
        self.sprite = sprite
    }
}


extension ItemDetail {
    static func fromDTO(dto: ItemDetailDTO) -> ItemDetail {
        return ItemDetail(
            id : dto.id,
            name : dto.name,
            flavorText: dto.flavorTextEntries
                .first(where: { $0.language.name == "en"})?.text
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "é", with: "E")
            ?? "",
            sprite : dto.sprites.defaultImage,
        )
    }
}
