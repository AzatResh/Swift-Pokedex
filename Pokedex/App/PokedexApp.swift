import SwiftUI

@main
struct PokedexApp: App {
    private let container = AppContainer.live
    
//    @State private var viewModel: PokedexViewModel

//    init() {
//        let container = AppContainer()
//        _viewModel = State(initialValue: container.makePokedexViewModel())
//    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.container, container)
                .preferredColorScheme(.dark)
                .background {
                    Color.red
                        .ignoresSafeArea()
                }
        }
    }
}

private struct RootView: View {
//    @Environment(\.container) private var container
    @Environment(\.viewModels) private var viewModels

    var body: some View {
        
        PokedexView(viewModel: viewModels.pokedex())
//        RootTabView(viewModel: viewModels.pokedex(), multiplayerSetup: viewModels.multiplayerSetup())
    }
}
