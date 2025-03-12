import SwiftUI

/*
 Magic Waits - testing API
 
 Next steps:
 - Display list of attractions
 - Further refine attraction details api extraction
 - Rename + modernise api call files (service/business)
 - Notifications for ride opening/queue times
 - Design for application
 - Display multiple parks
 - Display attractions first
 - Filtering
 */

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Text("Magic Waits")
                .font(.largeTitle)
                .padding()
            ScrollView {
                AttractionListView()
            }
        }
    }
}

#Preview {
    ContentView()
}
