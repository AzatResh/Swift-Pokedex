import SwiftUI

struct SpriteImage: View {
    
//    @State private var image: Image
    
    let url: String?
    
    var onLoaded: ((UIImage) async -> Void)?
    
    @Environment(\.spriteLoader) private var spriteLoader
    @State private var image: Image?
    
    
    init(
        url: String?,
        onLoaded: ((UIImage) async -> Void)? = nil)
    {
        self.url = url
        self.onLoaded = onLoaded
    }
    
    var body: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity)
            } else {
                Color.white.opacity(0.05)
                
            }
//        }
//        AsyncImage(url: URL(string: url)) { phase in
//            switch phase{
//            case .empty:
//                Color.clear
//                    .frame(height: minHeight)
////                ProgressView()
////                    .frame(minHeight: minHeight, alignment: .center)
//            case .success(let image):
//                image.resizable().scaledToFit()
//            case .failure(let error):
//                VStack {
//                    Text(error.localizedDescription)
//                    Image(systemName: "photo")
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundStyle(.secondary)
//                }
//            @unknown default:
//                Image(systemName: "photo")
//                    .resizable()
//                    .scaledToFit()
//                    .foregroundStyle(.secondary)
//            }
//            
        }
        .frame( alignment: .center)
        .task(id: url) {
            guard let url, let uiImage = await spriteLoader.spriteImage(from: url)
            else { return }
            
            await onLoaded?(uiImage)
            withAnimation(DesignKit.Animation.Primitive.easeInOut20) {
                image = Image(uiImage: uiImage)
            }
        }
        
    }
}
