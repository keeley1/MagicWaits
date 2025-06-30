import SwiftUI

struct ToolbarView: View {
    var body: some View {
        TabView {
            AttractionsListViewContainer()
                .tabItem {
                    Label("Wait times", systemImage: "sparkles")
                }
            FavouriteAttractionsViewContainer()
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
        .environmentObject(AppState())
        .environmentObject(Favourites())
}
