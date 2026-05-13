import Foundation

struct BorderWaitsResponse: Codable {
    let waitTimes: WaitTimes

    enum CodingKeys: String, CodingKey {
        case waitTimes = "waittimes"
    }
}

struct WaitTimes: Codable {
    let items: [BorderWaitItem]
}

struct BorderWaitItem: Codable, Identifiable {
    let id: Int
    let route: Int
    let waitTime: Int
    let name: String
    let lane: String
    let direction: String
    let updated: String

    enum CodingKeys: String, CodingKey {
        case id
        case route
        case waitTime = "wait"
        case name
        case lane
        case direction
        case updated
    }

    var routeDisplay: String {
        switch route {
        case 5: return "I-5"
        case 9: return "SR-9"
        case 97: return "US-97"
        case 539: return "SR-539"
        case 543: return "SR-543"
        default: return "Route \(route)"
        }
    }

    var waitTimeDisplay: String {
        if waitTime == -1 { return "N/A" }
        if waitTime < 5 { return "< 5 min" }
        return "\(waitTime) min"
    }

    var timeAgo: String {
        if let date = ISO8601DateFormatter().date(from: updated) ?? DateFormatter.wsdotDate.date(from: updated) {
            let interval = Date().timeIntervalSince(date)
            let minutes = Int(interval / 60)
            if minutes < 1 { return "Just now" }
            if minutes < 60 { return "\(minutes) min ago" }
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if hours < 24 { return "\(hours)h \(remainingMinutes)m ago" }
            return "\(hours / 24)d ago"
        }
        return updated
    }
}

extension DateFormatter {
    static let wsdotDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(abbreviation: "PST")
        return f
    }()
}
