import SwiftUI

struct AttractionView: View {
    @ObservedObject var attraction: Attraction
    var viewModel: AttractionListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("**\(attraction.name)**")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    viewModel.toggleFavourite(attraction: attraction)
                }) {
                    Image(systemName: attraction.isFavourited ? "heart.fill" : "heart")
                        .foregroundColor(Color("IconColor"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text(attraction.entityType.capitalizedEntityType)
                Image(systemName: "circle.fill")
                    .font(.system(size: 5))
                Text("Tomorrowland")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                if let waitTime = attraction.queue?.formattedQueue, waitTime != " " {
                    Text("**\(waitTime)**")
                        .foregroundColor(attraction.queueTextColor)
                        .padding(8)
                        .background(attraction.queueBackgroundColor)
                        .cornerRadius(8)
                }
                Text("**\(attraction.status.capitalizedStatus)**")
                    .foregroundColor(attraction.statusTextColor)
                    .padding(8)
                    .background(attraction.statusBackgroundColor)
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("SecondaryColor"))
        .cornerRadius(16)
        .padding(.vertical, 4)
    }
}

// Need to populate this:
//#Preview {
//    AttractionView()
//}
