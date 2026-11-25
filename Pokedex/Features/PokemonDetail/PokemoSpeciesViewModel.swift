import Observation

@MainActor
@Observable
final class PokemonSpeciesViewModel {
    
    enum State {
        case idle
        case loading
        case loaded(PokemonSpecies)
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
            let result = try await repository.fetchPokemonSpecies(id: id)
            
            
            try Task.checkCancellation()
            state = .loaded(result)
        
        } catch {
            if Task.isCancelled || error is CancellationError {
                state = .idle
            } else {
                state = .failed(String(reflecting: error))
            }
        }
    }
}
