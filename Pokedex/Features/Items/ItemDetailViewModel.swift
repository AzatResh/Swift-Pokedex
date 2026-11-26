import Observation

@MainActor
@Observable
final class ItemDetailViewModel {
    
    enum State {
        case idle
        case loading
        case loaded(ItemDetail)
        case failed(String)
    }
    
    
    private(set) var state: State = .idle
    private let repository: any ItemRepositoryProtocol
    
    
    init(repository: any ItemRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func load(id: Int) async {
        
        switch state {
            case .idle, .failed:
                state = .loading
            
            case .loading, .loaded:
                return
        }
        
        do {
            let detail = try await repository.fetchItemDetail(id: id)
            
            
            print("there ------- \(detail.id) \(detail.name)")
            try Task.checkCancellation()
            state = .loaded(detail)
        
        } catch {
            if Task.isCancelled || error is CancellationError {
                state = .idle
            } else {
                state = .failed(String(reflecting: error))
            }
        }
    }
}
