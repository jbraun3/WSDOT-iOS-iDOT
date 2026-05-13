import Foundation

// MARK: - Static Toll Rates (StaticTollRates.json)

struct StaticTollRatesResponse: Codable {
    let tollRates: [StaticTollRateItem]

    enum CodingKeys: String, CodingKey {
        case tollRates = "TollRates"
    }
}

struct StaticTollRateItem: Codable, Identifiable {
    let id: Int
    let route: Int
    let message: String
    let numCol: Int
    let travelDirection: String?
    let tollTable: [TollRateRow]
}

struct TollRateRow: Codable {
    let header: Bool
    let weekday: Bool?
    let startTime: String?
    let endTime: String?
    let rows: [String]

    enum CodingKeys: String, CodingKey {
        case header
        case weekday
        case startTime = "start_time"
        case endTime = "end_time"
        case rows
    }
}

// MARK: - Dynamic Toll Rates (GetTollRatesAsJson)

struct DynamicTollRateItem: Codable {
    let tripName: String
    let endLocationName: String
    let currentToll: Float
    let endMilepost: Int
    let currentMessage: String
    let endLatitude: Double
    let endLongitude: Double
    let updatedAt: String?
    let startLocationName: String
    let travelDirection: String
    let stateRoute: Int
    let startMilepost: Int
    let startLatitude: Double
    let startLongitude: Double

    enum CodingKeys: String, CodingKey {
        case tripName = "TripName"
        case endLocationName = "EndLocationName"
        case currentToll = "CurrentToll"
        case endMilepost = "EndMilepost"
        case currentMessage = "CurrentMessage"
        case endLatitude = "EndLatitude"
        case endLongitude = "EndLongitude"
        case updatedAt = "UpdatedAt"
        case startLocationName = "StartLocationName"
        case travelDirection = "TravelDirection"
        case stateRoute = "StateRoute"
        case startMilepost = "StartMilepost"
        case startLatitude = "StartLatitude"
        case startLongitude = "StartLongitude"
    }
}

struct DynamicTollSign: Identifiable {
    let startLocationName: String
    let travelDirection: String
    let stateRoute: Int
    let milepost: Int
    let startLatitude: Double
    let startLongitude: Double
    var trips: [DynamicTollTrip]

    var id: String { "\(startLocationName)-\(travelDirection)-\(stateRoute)" }
}

struct DynamicTollTrip: Identifiable {
    let tripName: String
    let endLocationName: String
    let toll: Float
    let endMilepost: Int
    let message: String
    let endLatitude: Double
    let endLongitude: Double

    var id: String { tripName + endLocationName }

    var tollDisplay: String {
        if !message.isEmpty { return message }
        return String(format: "$%.2f", toll)
    }
}
