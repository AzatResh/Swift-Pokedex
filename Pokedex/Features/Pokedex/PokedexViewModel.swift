import Observation

@MainActor
@Observable
final class PokedexViewModel {
    
    enum State {
        case idle
        case loading
        case loaded([Pokemon])
        case failed(String)
    }
    
    private(set) var state: State = .idle
    private let repository: any PokemonRepositoryProtocol
    
    
    private(set) var isLoadingNextPage = false
    private(set) var hasNextPage = true
    private(set) var nextPageFailed = false

    private let pageSize = 21
    private var offset = 0
    
    init(repository: any PokemonRepositoryProtocol) {
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
            let result = try await repository.fetchPokemons(
                limit: pageSize,
                offset: 0
            )

            try Task.checkCancellation()
            
            offset = result.items.count
            hasNextPage = result.hasNextPage && !result.items.isEmpty
            nextPageFailed = false
            
            state = .loaded(result.items)
        } catch {
            if Task.isCancelled || error is CancellationError {
                state = .idle
            } else {
                state = .failed(String(reflecting: error))
            }
        }
    }
    
    func loadNextPage() async {
            guard case .loaded(let currentPokemon) = state,
                  hasNextPage,
                  !isLoadingNextPage,
                  !nextPageFailed else {
                return
            }

            isLoadingNextPage = true
            defer { isLoadingNextPage = false }

            do {
                let page = try await repository.fetchPokemons(
                    limit: pageSize,
                    offset: offset
                )

                try Task.checkCancellation()

                // Исключаем повторяющиеся ID, если страницы пересекаются.
                var existingIDs = Set(currentPokemon.map(\.id))
                let newPokemon = page.items.filter {
                    existingIDs.insert($0.id).inserted
                }

                offset += page.items.count
                hasNextPage = page.hasNextPage && !page.items.isEmpty
                state = .loaded(currentPokemon + newPokemon)
            } catch {
                if Task.isCancelled || error is CancellationError {
                    return
                }

                nextPageFailed = true
            }
        }

}
