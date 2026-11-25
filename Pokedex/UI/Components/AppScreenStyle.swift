import SwiftUI

struct AppScreenStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.appBackground
                    .ignoresSafeArea()
            }
//            .toolbarBackground(
//                Color.appBackground,
//                for: .navigationBar
//            )
//            .toolbarBackground(.visible, for: .navigationBar)
    }
}

extension View {
    func applyScreenStyle() -> some View {
        modifier(AppScreenStyle())
    }
}
