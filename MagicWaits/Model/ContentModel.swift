import Foundation

//*** review this model ***

/*
 To include for details - should get data here to avoid extra api calls
- review what should be optional
- attraction operating hours
- last updated can get from api
 */

struct Attraction: Decodable, Identifiable {
    let id: String
    let name: String
    let entityType: EntityType
    let parkId: String?
    let status: LiveStatus
    let showtimes: [Showtime]?
    let queue: Queue?
}

struct Showtime: Decodable {
    let startTime: String
    let endTime: String
}

struct Queue: Decodable {
    let standby: Standby?
    
    private enum CodingKeys: String, CodingKey {
        case standby = "STANDBY"
    }
    
    var formattedQueue: String? {
        if let waitTime = standby?.waitTime {
            return "\(waitTime)"
        } else {
            return " "
        }
    }
}

struct Standby: Decodable {
    let waitTime: Int?
}

enum LiveStatus: String, Decodable {
    case operating = "OPERATING"
    case down = "DOWN"
    case closed = "CLOSED"
    case refurbishment = "REFURBISHMENT"

    var capitalizedStatus: String {
        return self.rawValue.capitalized
    }
}

enum EntityType: String, Decodable {
    case destination = "DESTINATION"
    case park = "PARK"
    case attraction = "ATTRACTION"
    case restuarant = "RESTAURANT"
    case hotel = "HOTEL"
    case show = "SHOW"
    
    var capitalizedEntityType: String {
        return self.rawValue.capitalized
    }
}

struct DisneylandData: Decodable {
    let id: String
    let name: String
    let entityType: String
    let timezone: String
    let liveData: [Attraction]
}
