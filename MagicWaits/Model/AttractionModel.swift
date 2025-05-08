import Foundation

//*** review this model ***

/*
 To include for details - should get data here to avoid extra api calls
- review what should be optional
- attraction operating hours
- last updated can get from api
 */

// Note this solution will only work for false - in this scope that is fine for now
@propertyWrapper
struct DecodableBool {
    var wrappedValue = false
}

extension DecodableBool: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Bool.self)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: DecodableBool.Type,
                forKey key: Key) throws -> DecodableBool {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

class Attraction: Decodable, Identifiable, ObservableObject {
    let id: String
    let name: String
    let entityType: EntityType
    let parkId: String?
    let status: LiveStatus
    let showtimes: [Showtime]?
    let queue: Queue?
    @Published var isFavourited: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id, name, entityType, parkId, status, showtimes, queue, isFavourited
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        entityType = try container.decode(EntityType.self, forKey: .entityType)
        parkId = try container.decodeIfPresent(String.self, forKey: .parkId)
        status = try container.decode(LiveStatus.self, forKey: .status)
        showtimes = try container.decodeIfPresent([Showtime].self, forKey: .showtimes)
        queue = try container.decodeIfPresent(Queue.self, forKey: .queue)
        isFavourited = try container.decodeIfPresent(Bool.self, forKey: .isFavourited) ?? false
    }
    
    init(id: String,
         name: String,
         entityType: EntityType,
         parkId: String?,
         status: LiveStatus,
         showtimes: [Showtime]?,
         queue: Queue?,
         isFavourited: Bool = false) {
        self.id = id
        self.name = name
        self.entityType = entityType
        self.parkId = parkId
        self.status = status
        self.showtimes = showtimes
        self.queue = queue
        self.isFavourited = isFavourited
    }
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
            return "\(waitTime) min"
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
