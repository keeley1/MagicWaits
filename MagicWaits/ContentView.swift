import SwiftUI

/*
 Magic Waits - testing API
 
 Next steps:
 - Update attraction list data
 - Handle possible errors for attraction list
 - Further refine attraction details api extraction
 - Rename + modernise api call files (service/business)
 - Notifications for ride opening/queue times
 - Design for application
 - Display multiple parks
 - Display attractions first
 - Filtering
 - decide on bottom navigation or not
 - option to display times for both parks???
 - dark mode/light mode look into (dark mode styling will sometimes appear by default)
 - attraction suggestion
 - historic/predictive wait times???
 - display time last updated
 - figure out how to store attraction/park locations and display
 - could change images based on night/day
 
 - review class v struct for view models
 - review private, public vars
 - error handling
 - should protocols be used throughout???
 - do my models need initialisers
 - explore what to do if
 
 - can get average waits from queue-times.com
 */

struct ContentView: View {
    var body: some View {
        VStack {
            SelectParkView()
        }
    }
}

#Preview {
    ContentView()
}
