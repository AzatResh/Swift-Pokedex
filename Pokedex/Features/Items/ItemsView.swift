import SwiftUI

struct ItemsViiew: View {
    
    @State private var viewModel: ItemsViewModel
    
    @Environment(\.viewModels) private var viewModels
    
    init(viewModel: ItemsViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        content
            .task {
                await viewModel.load()
            }
            .applyScreenStyle()
    }
    
    @ViewBuilder
    var content: some View {
        
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .failed(let error):
            Text("Error \(error)")
        case .loaded(let items):
            ScrollView{
                LazyVStack {
                    ForEach(items) {
                        entry in ItemCard(
                            viewModel: viewModels.itemDetail(),
                            itemModel: entry
                        )
                    }
                    
                    paginatedFooter
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .task {
                            await viewModel.loadNextPage()
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    var paginatedFooter: some View {
        if viewModel.nextPageFailed {
            Text("Не удалось загрузить следующую страницу")
                .font(.footnote)
        } else if viewModel.isLoadingNextPage {
            ProgressView()
        } else {
            Color.clear
                .frame(height: 1)
        }
    }
    
}
