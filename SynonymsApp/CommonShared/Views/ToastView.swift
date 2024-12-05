import SwiftUI

struct ToastView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .font(.headline)
            .padding()
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal, 16)
    }
}
