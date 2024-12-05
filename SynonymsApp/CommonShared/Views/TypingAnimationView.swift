import SwiftUI

struct TypingAnimationView: View {
    private let fullText: String
    private let typingSpeed: Double = 0.1
    @State private var displayedText: String = ""
    
    init(fullText: String) {
        self.fullText = fullText
    }
    
    var body: some View {
        Text(displayedText)
            .font(.title2)
            .foregroundColor(.gray)
            .onAppear {
                startTypingAnimation()
            }
    }
    
    private func startTypingAnimation() {
        displayedText = ""
        
        for (index, character) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed * Double(index)) {
                displayedText.append(character)
            }
        }
    }
}
