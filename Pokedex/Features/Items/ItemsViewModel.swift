import Observation

@MainActor
@Observable
final class ItemsViewModel {
    
    enum State {
        case idle
        case loading
        case loaded([ItemModel])
        case failed(String)
    }
    
    private(set) var state: State = .idle
    private let repository: any ItemRepositoryProtocol
    
    
    private(set) var isLoadingNextPage = false
    private(set) var hasNextPage = true
    private(set) var nextPageFailed = false

    private let pageSize = 10
    private var offset = 0
    
    init(repository: any ItemRepositoryProtocol) {
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
            let result = try await repository.fetchItems(
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
        print("load next")
            guard case .loaded(let currentPokemon) = state,
                  hasNextPage,
                  !isLoadingNextPage,
                  !nextPageFailed else {
                return
            }

            isLoadingNextPage = true
            defer { isLoadingNextPage = false }

            do {
                let page = try await repository.fetchItems(
                    limit: pageSize,
                    offset: offset
                )

                try Task.checkCancellation()

                offset += page.items.count
                hasNextPage = page.hasNextPage && !page.items.isEmpty
                state = .loaded(currentPokemon + page.items)
                
                print("there ----- \(offset) \(hasNextPage)")
            } catch {
                if Task.isCancelled || error is CancellationError {
                    return
                }

                nextPageFailed = true
            }
        }

}
