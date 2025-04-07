import SwiftUI

/*
 TODO:
 - display image
 - land attraction is in
 - map??
 - ability to save/fav attraction
 - forecasted wait??
 - attraction hours
 - see what details are available in api's
 */

struct AttractionDetailsView: View {
    let attraction: Attraction
    
    var body: some View {
        VStack(alignment: .leading) {
            let sanitizedImageName = attraction.name.replacingOccurrences(of: ":", with: "")
            if let uiImage = UIImage(named: sanitizedImageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            VStack(alignment: .leading) {
                Text("**\(attraction.name)**")
                    .font(.title)
                HStack {
                    Text(attraction.entityType.capitalizedEntityType)
                    Image(systemName: "circle.fill")
                        .font(.system(size: 5))
                    Text("Tomorrowland")
                }
                HStack(spacing: 16) {
                    if let waitTime = attraction.queue?.formattedQueue {
                        if waitTime != " " {
                            VStack(alignment: .leading) {
                                Text("Current wait")
                                Text("**\(waitTime)**")
                                    .font(.title)
                            }
                            .foregroundColor(attraction.queueTextColor)
                            .padding(16)
                            .padding(.trailing, 24)
                            .background(attraction.queueBackgroundColor)
                            .cornerRadius(8)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Status")
                        Text("**\(attraction.status.capitalizedStatus)**")
                            .font(.title)
                    }
                    .foregroundColor(attraction.statusTextColor)
                    .padding(16)
                    .padding(.trailing, 24)
                    .background(attraction.statusBackgroundColor)
                    .cornerRadius(8)
                }
                Text("Updated 2 mins ago")
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    AttractionDetailsView(attraction: Attraction(id: "f44a5072-3cda-4c7c-8574-33ad09d16cca",
                                                 name: "Main Street Cinema",
                                                 entityType: .attraction,
                                                 parkId: "832fcd51-ea19-4e77-85c7-75d5843b127c",
                                                 status: .operating,
                                                 showtimes: nil,
                                                 queue: Queue(standby: Standby(waitTime: 30))))
}
