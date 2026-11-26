import Observation

@MainActor
@Observable
final class PokemonDetailViewModel {
    
    enum State {
        case idle
        case loading
        case loaded(PokemonDetail)
        case failed(String)
    }
    
    
    private(set) var state: State = .idle
    private let repository: any PokemonRepositoryProtocol
    
    
    init(repository: any PokemonRepositoryProtocol) {
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
            let detail = try await repository.fetchPokemon(id: id)
            
            
            print("there ------- \(detail.id) \(detail.name) \(String(reflecting: detail.types.first?.name))")
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
