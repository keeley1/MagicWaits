import SwiftUI

@main
struct MagicWaitsApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ToolbarView()
                .environmentObject(appState)
        }
    }
}
