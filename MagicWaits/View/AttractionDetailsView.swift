import SwiftUI

struct AttractionDetailsView: View {
    var attractionName: String
    
    var body: some View {
        VStack {
            Text("Attraction Details")
            Text("Name: \(attractionName)")
        }
    }
}

#Preview {
    AttractionDetailsView(attractionName: "Space Mountain")
}
