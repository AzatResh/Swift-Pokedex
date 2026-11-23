import SwiftUI

struct SpriteImage: View {
    
//    @State private var image: Image
    
    let url: URL?
    let minHeight: CGFloat?
    
    
    init(url: URL?, minHeight: CGFloat? = nil) {
        self.url = url
        self.minHeight = minHeight
    }
    
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase{
            case .empty:
                Color.clear
                    .frame(height: minHeight)
//                ProgressView()
//                    .frame(minHeight: minHeight, alignment: .center)
            case .success(let image):
                image.resizable().scaledToFit()
            case .failure(let error):
                VStack {
                    Text(error.localizedDescription)
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                }
            @unknown default:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
            }
            
        }
        
    }
}
