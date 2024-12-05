import SwiftUI

@main
struct SynonymsApp: App {
    var body: some Scene {
        WindowGroup {
            SearchSynonymsView()
                .preferredColorScheme(.light)
        }
    }
}
