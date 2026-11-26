import Foundation

protocol ItemRepositoryProtocol: Sendable {
    func fetchItems(limit: Int, offset: Int) async throws -> PaginatedResponse<ItemModel>
    
    func fetchItemDetail(id: Int) async throws -> ItemDetail
}

struct ItemRepository: ItemRepositoryProtocol {
    
    let network: any NetworkService
    
    func fetchItems(limit: Int, offset: Int) async throws -> PaginatedResponse<ItemModel> {
        let page = try await network.request(
            endpoint: ItemAPIEndpoint.itemList(limit: limit, offset: offset),
            responseType: PaginatedResponseDTO<ItemDTO>.self
        )
        
        let items = page.results.compactMap(ItemModel.fromDTO)
        
        return PaginatedResponse<ItemModel>(
            items: items,
            hasNextPage: page.next != nil,
        )
    }
    
    
    func fetchItemDetail(id: Int) async throws -> ItemDetail {
        let result = try await network.request(
            endpoint: ItemAPIEndpoint.itemDetail(id: id),
            responseType: ItemDetailDTO.self
        )
        
        return ItemDetail.fromDTO(dto: result)
    }
    
}
