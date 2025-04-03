import SwiftUI

struct AttractionDetailsView: View {
    let attraction: Attraction
    
    var body: some View {
        VStack {
            Text("Attraction Details")
            Text("Name: \(attraction.name)")
            Text("Status: \(attraction.status.capitalizedStatus)")
            let sanitizedImageName = attraction.name.replacingOccurrences(of: ":", with: "")
            if let uiImage = UIImage(named: sanitizedImageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
            }
        }
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
