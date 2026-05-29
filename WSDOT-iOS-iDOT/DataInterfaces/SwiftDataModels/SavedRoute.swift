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
    var startLatitude: Double
    var startLongitude: Double
    var endLatitude: Double
    var endLongitude: Double

    init(id: UUID, name: String, startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.startLatitude = startLocation.latitude
        self.startLongitude = startLocation.longitude
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
