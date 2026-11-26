import SwiftUI

struct DetailSection<Content: View>: View {
    var title: String?
    var textColor: Color?
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if let title{
                Text(title)
                    .font(Font.pixel16)
                    .foregroundStyle(textColor ?? .white)
                    .padding(16)
            }
            
            if #available(iOS 26.0, *) {
                VStack (alignment: .leading, spacing: 12) {
                    content()
                }
                
                .frame(maxWidth: .infinity)
                .glassEffect(.clear, in: Rectangle())
            } else {
                VStack (alignment: .leading, spacing: 12) {
                    content()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct DetailRow: View {
    var title: String
    let subtitle: String
    var axis: Axis = .horizontal

    var body: some View {
        switch axis {
        case .horizontal:
            HStack(alignment: .top, spacing: 16) {
                Text(title)
                    .frame(width: 82, alignment: .leading)
                Text(subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        case .vertical:
            VStack(alignment: .leading) {
                Text(title)
                Text(subtitle)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
