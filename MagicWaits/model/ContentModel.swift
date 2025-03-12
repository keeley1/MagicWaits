import Foundation

struct Attraction: Decodable {
    let id: String
    let name: String
    let entityType: String
    let parkId: String?
    let externalId: String
    let status: String
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

struct DisneylandData: Decodable {
    let id: String
    let name: String
    let entityType: String
    let timezone: String
    let liveData: [Attraction]
}
