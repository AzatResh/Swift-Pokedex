import SwiftUI

@main
@MainActor
struct PokedexApp: App {
    @State private var viewModel: PokedexViewModel

    init() {
        let container = AppContainer()
        _viewModel = State(initialValue: container.makePokedexViewModel())
    }

    var body: some Scene {
        WindowGroup {
            PokedexView(viewModel: viewModel)
        }
    }
}
