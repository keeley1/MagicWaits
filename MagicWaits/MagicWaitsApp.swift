import SwiftUI

@main
struct MagicWaitsApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var favourites = Favourites()
    
    var body: some Scene {
        WindowGroup {
            ToolbarView()
                .environmentObject(appState)
                .environmentObject(favourites)
        }
    }
}
