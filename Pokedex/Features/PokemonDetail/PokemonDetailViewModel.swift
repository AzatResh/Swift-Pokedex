import Observation

@MainActor
@Observable
final class PokemonDetailViewModel {
    
    enum State {
        case idle
        case loading
        case loaded(PokemonDetail)
        case failed
    }
    
    
    private(set) var state: State = .idle
    private let repository: any PokedexRepositoryProtocol
    
    
    init(repository: any PokedexRepositoryProtocol) {
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
            
            
            print("there ------- \(detail.name)")
            try Task.checkCancellation()
            state = .loaded(detail)
        
        } catch {
            if Task.isCancelled || error is CancellationError {
                state = .idle
            } else {
                state = .failed
            }
        }
    }
}
