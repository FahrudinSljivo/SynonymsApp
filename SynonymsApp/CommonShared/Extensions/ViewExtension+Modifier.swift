import SwiftUI

// MARK: - ToastModifier

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                VStack {
                    ToastView(message: message)
                        .transition(.asymmetric(insertion: .opacity.animation(.easeIn(duration: 0.4)),
                                                removal: .opacity.animation(.easeOut(duration: 0.4))))
                        .animation(.easeInOut, value: isShowing)
                    Spacer()
                }
                .zIndex(1)
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, message: String) -> some View {
        modifier(ToastModifier(isShowing: isShowing, message: message))
    }
}
