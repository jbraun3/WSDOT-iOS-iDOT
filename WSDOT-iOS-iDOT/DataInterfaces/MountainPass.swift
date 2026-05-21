//
//  MountainPass.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 5/4/26.
//

import Foundation
import CoreLocation

// single mountain pass object
struct MountainPass: Codable, Identifiable {
    // fields
    
    // mountain pass identifiers
    let id: Int
    let name: String
    
    // page information
    let elevationInFeet: Int?
    
    let temperatureInFahrenheit: Int?
    let weatherCondition: String
    let roadCondition: String
    
    let latitude: Double?
    let longitude: Double?
    
    let restrictionOne: PassRestriction?
    let restrictionTwo: PassRestriction?
    let cameras: [PassCamera]?
    
    let dateUpdated: String
    
    var hasValidLocation: Bool {
        guard let lat = latitude, let lon = longitude else { return false }
        return lat != 0 && lon != 0
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard hasValidLocation else { return nil }
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    
    // fix naming conventions
    enum CodingKeys: String, CodingKey {
        case id = "MountainPassId"
        case name = "MountainPassName"
        case elevationInFeet = "ElevationInFeet"
        case temperatureInFahrenheit = "TemperatureInFahrenheit"
        case dateUpdated = "DateUpdated"
        case roadCondition = "RoadCondition"
        case weatherCondition = "WeatherCondition"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case restrictionOne = "RestrictionOne"
        case restrictionTwo = "RestrictionTwo"
        case cameras = "Cameras"
    }
    
    // MARK: -weather icon helper
    
    var weatherSymbol: String {
        let condition = weatherCondition.lowercased()
        
        let textSaysNight = condition.contains("night") || condition.contains("tonight")
        let currentHour = Calendar.current.component(.hour, from: Date())
        // If the time is before 6 AM or after 6 PM, we consider it night
        let timeIsNight = currentHour < 6 || currentHour >= 18
        
        let isNight = textSaysNight || timeIsNight
        
        // We merged the old app's keyword arrays and mapped them to native SF Symbols!
        let mappings: [(keywords: [String], symbol: String)] = [
            (["thunderstorm", "thunderstorms"], "cloud.bolt.rain.fill"),
            (["ice pellets", "light ice pellets", "heavy ice pellets", "hail"], "cloud.hail.fill"),
            (["rain snow", "light rain snow", "heavy rain snow", "rain and snow"], "cloud.sleet.fill"),
            (["snow", "snowing", "light snow", "heavy snow"], "snowflake"),
            (["light rain", "showers", "scattered rain"], "cloud.drizzle.fill"),
            (["rain", "heavy rain", "raining"], "cloud.rain.fill"),
            (["fog"], "cloud.fog.fill"),
            (["overcast", "broken", "mostly cloudy", "cloudy", "increasing clouds"], "cloud.fill"),
            (["partly cloudy", "partly sunny", "few clouds", "scattered clouds", "mostly sunny", "mostly clear"], "cloud.sun.fill"),
            (["fair", "sunny", "clear"], "sun.max.fill")
        ]
        
        for mapping in mappings {
            if mapping.keywords.contains(where: { condition.contains($0) }) {
                var chosenSymbol = mapping.symbol
                
                if isNight {
                    if chosenSymbol == "sun.max.fill" {
                        chosenSymbol = "moon.stars.fill"
                    } else if chosenSymbol == "cloud.sun.fill" {
                        chosenSymbol = "cloud.moon.fill"
                    }
                }
                return chosenSymbol
            }
        }
        
        // default
        return "icloud.slash"
    }
}

// MARK: -sub-object declarations

struct PassRestriction: Codable {
    let travelDirection: String
    let restrictionText: String
    
    enum CodingKeys: String, CodingKey {
        case travelDirection = "TravelDirection"
        case restrictionText = "RestrictionText"
    }
}

struct PassCamera: Codable, Identifiable {
    let id: Int
    let title: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "CameraId"
        case title = "Title"
        case imageURL = "ImageURL"
    }
}
