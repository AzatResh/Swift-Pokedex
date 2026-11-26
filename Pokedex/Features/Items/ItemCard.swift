import SwiftUI

struct ItemCard: View {
    
    @State private var viewModel: ItemDetailViewModel
    @State private var itemModel: ItemModel
    
    init(viewModel: ItemDetailViewModel, itemModel: ItemModel) {
        self.viewModel = viewModel
        self.itemModel = itemModel
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .task {
                await viewModel.load(id: itemModel.id)
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .failed(let error):
            Text("Error: \(error)")
        case .loaded(let itemDetail):
            HStack(alignment: .top) {
                SpriteImage(url: itemDetail.sprite)
                    .frame(width: 60, height: 60)
                VStack (alignment: .leading) {
                    
                    Text(itemDetail.name)
                        .font(.pixel16)
                    
                    Text(itemDetail.flavorText)
                        .font(.pixel14)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
        
            }
            
        default:
            Color.clear
            }
        }
    
}
