import Foundation
import UIKit
import SwiftUI

struct BridgeAlertItem: Codable, Identifiable {
    let alertId: Int
    let descText: String
    let status: String
    let duration: Int
    let travelCenterPriorityId: Int
    let location: BridgeLocation
    let openingTime: String
    let lastUpdatedTime: String

    var id: Int { alertId }
    var bridge: String { location.description }
    var latitude: Double { location.latitude }
    var longitude: Double { location.longitude }
    var milepost: Double { location.milepost }
    var direction: String { location.direction }
    var roadName: String { location.roadName }

    enum CodingKeys: String, CodingKey {
        case alertId = "BridgeOpeningId"
        case descText = "EventText"
        case status = "Status"
        case duration = "Duration"
        case travelCenterPriorityId = "TravelCenterPriorityId"
        case location = "BridgeLocation"
        case openingTime = "OpeningTime"
        case lastUpdatedTime = "LastUpdatedTime"
    }

    var prioritySymbol: String {
        switch travelCenterPriorityId {
        case 1: return "xmark.octagon.fill"
        case 2: return "exclamationmark.triangle.fill"
        case 3: return "exclamationmark.circle.fill"
        case 4: return "info.circle.fill"
        default: return "info.circle.fill"
        }
    }

    var priorityColor: Color {
        switch travelCenterPriorityId {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        default: return .green
        }
    }

    var timeAgo: String {
        guard let date = parseDotNetDate(lastUpdatedTime) else {
            return lastUpdatedTime
        }
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        if minutes < 1 { return "Just now" }
        if minutes < 60 { return "\(minutes) min ago" }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        if hours < 24 { return "\(hours)h \(remainingMinutes)m ago" }
        return "\(hours / 24)d ago"
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

    var descriptionPlainText: String {
        guard let data = descText.data(using: .utf8),
              let plain = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
              ).string else {
            return descText
        }
        return plain
    }
}

struct BridgeLocation: Codable {
    let description: String
    let latitude: Double
    let longitude: Double
    let milepost: Double
    let direction: String
    let roadName: String

    enum CodingKeys: String, CodingKey {
        case description = "Description"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case milepost = "MilePost"
        case direction = "Direction"
        case roadName = "RoadName"
    }
}

extension AttributedString {
    init?(html: String) {
        let styledHTML = """
        <style>
          * { font-family: -apple-system; font-size: 15px; }
          a { text-decoration: none; }
        </style>
        \(html)
        """
        guard let data = styledHTML.data(using: .unicode),
              let nsAttr = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
              ) else { return nil }
        self.init(nsAttr)
    }
}
