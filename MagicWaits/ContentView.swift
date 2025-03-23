import SwiftUI

/*
 Magic Waits - testing API
 
 Next steps:
 - Home page to show list of parks (for now disneyland + DCA)
 - Update attraction list data
 - Decide how often to call api to update wait times
 - Handle possible errors for attraction list
 - Further refine attraction details api extraction
 - Rename + modernise api call files (service/business)
 - Notifications for ride opening/queue times
 - Design for application
 - Display multiple parks
 - Display attractions first
 - Filtering
 
 - review class v struct for view models
 - review private, public vars
 */

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    let parks = ["Disneyland"]

    var body: some View {
        VStack {
            SelectParkView()
        }
    }
}

#Preview {
    ContentView()
}
