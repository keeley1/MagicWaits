import SwiftUI

struct ToolbarView: View {
    var body: some View {
        TabView {
            AttractionsListView()
                .tabItem {
                    Label("Wait times", systemImage: "sparkles")
                }
            FavouriteAttractionsView()
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ToolbarView()
}
