//
//  FerriesVesselsService.swift
//  WSDOT-iOS-iDOT
//
//  Wraps the WSDOT Ferries Vessels API:
//    https://www.wsdot.wa.gov/ferries/api/vessels/rest/help
//
//  Skeleton — endpoints will be filled in when the detail page needs
//  vessel-level data
//

import Foundation

class FerriesVesselsService {

    static let shared = FerriesVesselsService()
    private init() {}

    private let baseURL = "https://www.wsdot.wa.gov/ferries/api/vessels/rest"

    // TODO: getVesselBasics() — /vesselbasics
    // TODO: getVesselLocations() — /vessellocations
    // TODO: getVesselAccommodations() — /vesselaccommodations
    // TODO: getVesselStats() — /vesselstats
}
