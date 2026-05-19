//
//  HighwayAlerts.swift
//  WSDOT-iOS-iDOT
//
//  Created by Arohee Kumar on 5/18/26.
//
//  Alerts that impact the major roadways

import Foundation

struct HighwayAlerts: Codable, Identifiable {
    let id: Int
    let county: String
    let endRoadwayLocation: RoadwayLocation
    let endTime: Date
    let eventCategory: String
    let eventStatus: String
    let extendedDescription: String
    let headlineDescription: String
    let lastUpdatedTime: Date
    let priority: String
    let region: String
    let startRoadwayLocation: RoadwayLocation
    let startTime: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "AlertID"
        case county = "County"
        case endRoadwayLocation = "EndRoadwayLocation"
        case endTime = "EndTime"
        case eventCategory = "EventCategory"
        case eventStatus = "EventStatus"
        case extendedDescription = "ExtendedDescription"
        case headlineDescription = "HeadlineDescription"
        case lastUpdatedTime = "LastUpdatedTime"
        case priority
        case region
        case startRoadwayLocation = "StartRoadwayLocation"
    }
}

struct RoadwayLocation: Codable {
    let description: String
    let roadName: String
    let direction: String
    let milepost: Double
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey{
        case description = "Description"
        case roadName = "RoadName"
        case direction = "Direction"
        case milepost = "MilePost"
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}
