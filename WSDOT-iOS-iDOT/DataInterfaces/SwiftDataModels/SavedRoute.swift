//
//  SavedRoute.swift
//  WSDOT-iOS-iDOT
//
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class SavedRoute {
    var id: UUID
    var name: String
    var startLocationName: String
    var startLatitude: Double
    var startLongitude: Double
    var endLocationName: String
    var endLatitude: Double
    var endLongitude: Double

    init(id: UUID, name: String, startLocationName: String, startLocation: CLLocationCoordinate2D, endLocationName: String, endLocation: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.startLocationName = startLocationName
        self.startLatitude = startLocation.latitude
        self.startLongitude = startLocation.longitude
        self.endLocationName = endLocationName
        self.endLatitude = endLocation.latitude
        self.endLongitude = endLocation.longitude
    }

    var start: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
    }

    var end: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: endLatitude, longitude: endLongitude)
    }
}
