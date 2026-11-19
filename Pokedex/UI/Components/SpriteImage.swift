import SwiftUI

struct SpriteImage: View {
    
//    @State private var image: Image
    
    let url: URL?
    
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase{
            case .empty:
                ProgressView()
                    .frame(height: 400, alignment: .center)
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
