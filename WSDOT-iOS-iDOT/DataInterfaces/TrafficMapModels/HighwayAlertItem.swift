import Foundation
import CoreLocation

struct HighwayAlertsResponse: Codable {
    let alerts: HighwayAlertContainer
}

struct HighwayAlertContainer: Codable {
    let items: [HighwayAlertItem]
}

struct HighwayAlertItem: Codable, Identifiable {
    let alertId: Int
    let priority: String
    let region: String
    let eventCategory: String
    let eventCategoryType: String
    let eventCategoryTypeDescription: String
    let headlineDescription: String
    let extendedDescription: String?
    let eventStatus: String?
    let county: String?
    let travelCenterPriorityId: Int
    let displayLatitude: Double
    let displayLongitude: Double
    let startRoadwayLocation: RoadwayAlertLocation
    let endRoadwayLocation: RoadwayAlertLocation?
    let lastUpdatedTime: String
    let startTime: String
    let endTime: String?

    var id: Int { alertId }

    var roadName: String { startRoadwayLocation.roadName }
    var startDirection: String { startRoadwayLocation.direction }
    var startLatitude: Double { startRoadwayLocation.latitude }
    var startLongitude: Double { startRoadwayLocation.longitude }
    var endLatitude: Double { endRoadwayLocation?.latitude ?? 0 }
    var endLongitude: Double { endRoadwayLocation?.longitude ?? 0 }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: displayLatitude, longitude: displayLongitude)
    }

    var hasValidLocation: Bool {
        displayLatitude != 0 && displayLongitude != 0
    }

    var lastUpdatedDate: Date? {
        parseDotNetDate(lastUpdatedTime)
    }

    var startDate: Date? {
        parseDotNetDate(startTime)
    }

    var endDate: Date? {
        endTime.flatMap { parseDotNetDate($0) }
    }

    var isActive: Bool {
        let now = Date()
        guard let start = startDate, start <= now else { return false }
        if let end = endDate { return now <= end }
        return true
    }

    var timeAgo: String {
        guard let date = lastUpdatedDate else { return lastUpdatedTime }
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        if minutes < 1 { return "Just now" }
        if minutes < 60 { return "\(minutes) min ago" }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        if hours < 24 { return "\(hours)h \(remainingMinutes)m ago" }
        return "\(hours / 24)d ago"
    }

    var mapIconName: String {
        let severity: String
        switch travelCenterPriorityId {
        case 1: severity = "Closure"
        case 2: severity = "High"
        case 3: severity = "Medium"
        default: severity = "Low"
        }
        let prefix: String
        switch eventCategoryType {
        case "Construction": prefix = "construction"
        case "Incident": prefix = "incident"
        default: prefix = "incident"
        }
        return "\(prefix)\(severity)Alert"
    }

    private func parseDotNetDate(_ dateString: String) -> Date? {
        let pattern = #"\/Date\((\d+)([+-]\d{4})?\)\/"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: dateString, range: NSRange(dateString.startIndex..., in: dateString)) else {
            return nil
        }
        let msRange = match.range(at: 1)
        let msString = (dateString as NSString).substring(with: msRange)
        guard let ms = Double(msString) else { return nil }
        return Date(timeIntervalSince1970: ms / 1000)
    }

    enum CodingKeys: String, CodingKey {
        case alertId = "AlertID"
        case priority = "Priority"
        case region = "Region"
        case eventCategory = "EventCategory"
        case eventCategoryType = "EventCategoryType"
        case eventCategoryTypeDescription = "EventCategoryTypeDescription"
        case headlineDescription = "HeadlineDescription"
        case extendedDescription = "ExtendedDescription"
        case eventStatus = "EventStatus"
        case county = "County"
        case travelCenterPriorityId = "TravelCenterPriorityId"
        case displayLatitude = "DisplayLatitude"
        case displayLongitude = "DisplayLongitude"
        case startRoadwayLocation = "StartRoadwayLocation"
        case endRoadwayLocation = "EndRoadwayLocation"
        case lastUpdatedTime = "LastUpdatedTime"
        case startTime = "StartTime"
        case endTime = "EndTime"
    }
}

struct RoadwayAlertLocation: Codable {
    let roadName: String
    let direction: String
    let latitude: Double
    let longitude: Double
    let milePost: Double?

    enum CodingKeys: String, CodingKey {
        case roadName = "RoadName"
        case direction = "Direction"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case milePost = "MilePost"
    }
}
