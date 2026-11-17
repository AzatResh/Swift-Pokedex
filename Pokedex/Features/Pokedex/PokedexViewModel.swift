import Observation

@MainActor
@Observable
final class PokedexViewModel {
    
    enum State {
        case idle
        case loading
        case loaded([Pokemon])
        case failed
    }
    
    private(set) var state: State = .idle
    private let repository: any PokedexRepositoryProtocol
    
    
    init(repository: any PokedexRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func load() async{
        switch state {
        case .idle, .failed:
            state = .loading
        case .loading, .loaded:
            return;
        }
            
        do {
            print("Pokédex: начинаю запрос")
            let pokemon = try await repository.fetchPokemons()
            print("Pokédex: получено \(pokemon.count) покемонов")

            try Task.checkCancellation()
            state = .loaded(pokemon)
        } catch {
            if Task.isCancelled || error is CancellationError {
                state = .idle
            } else {
                state = .failed
            }
        }
    }

}
