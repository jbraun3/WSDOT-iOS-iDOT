//
//  SavedRoute.swift
//  WSDOT-iOS-iDOT
//
//
// storing route information, used ai to understand cllocationcoordinate2d

import Foundation
import CoreLocation

struct SavedRoute: Identifiable, Codable{
    let id: UUID
    let name: String
    let startLatitude: Double
    let startLongitude: Double
    let endLatitude: Double
    let endLongitude: Double
    
    init(id: UUID, name: String, startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.startLatitude = startLocation.latitude
        self.startLongitude = startLocation.longitude
        self.endLatitude = endLocation.latitude
        self.endLongitude = endLocation.longitude
    }
    
    var start: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
    }
    
    var end: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: endLatitude, longitude: endLongitude)
    }
}
