//
//  FerryRoute.swift
//  WSDOT-iOS-iDOT
//
//  Models one WSDOT ferry route.
//

import Foundation

struct FerryRoute: Identifiable, Codable, Hashable {
    let routeID: Int
    let routeAbbrev: String
    let description: String
    let regionID: Int
    let vesselWatchID: Int?
    let reservationFlag: Bool?
    let internationalFlag: Bool?
    let passengerOnlyFlag: Bool?
    let crossingTime: String?
    let adaNotes: String?
    let generalRouteNotes: String?
    let seasonalRouteNotes: String?

    var id: Int { routeID }

    enum CodingKeys: String, CodingKey {
        case routeID            = "RouteID"
        case routeAbbrev        = "RouteAbbrev"
        case description        = "Description"
        case regionID           = "RegionID"
        case vesselWatchID      = "VesselWatchID"
        case reservationFlag    = "ReservationFlag"
        case internationalFlag  = "InternationalFlag"
        case passengerOnlyFlag  = "PassengerOnlyFlag"
        case crossingTime       = "CrossingTime"
        case adaNotes           = "AdaNotes"
        case generalRouteNotes  = "GeneralRouteNotes"
        case seasonalRouteNotes = "SeasonalRouteNotes"
    }

    // MARK: - Display helpers

    // edit this later to make grouping work
    var displayName: String {
        let parts = description.components(separatedBy: " / ")
        if parts.count == 2 {
            return parts.joined(separator: " ↔ ")
        }
        return description
    }

    var crossingTimeDisplay: String {
        guard let crossingTime, !crossingTime.isEmpty else { return "—" }
        if let minutes = Int(crossingTime) {
            if minutes >= 60 {
                let hours = minutes / 60
                let mins = minutes % 60
                return mins == 0
                    ? "~\(hours) hr"
                    : "~\(hours) hr \(mins) min"
            }
            return "~\(minutes) min"
        }

        return crossingTime
    }
}
