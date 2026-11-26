import SwiftUI
import SwiftData

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
        .modelContainer(for: Pokemon.self)
       
    }
}

private struct RootView: View {
//    @Environment(\.container) private var container
    @Environment(\.viewModels) private var viewModels

    var body: some View {
        RootTabView()
        
//        PokedexView(viewModel: viewModels.pokedex())
    }
}
