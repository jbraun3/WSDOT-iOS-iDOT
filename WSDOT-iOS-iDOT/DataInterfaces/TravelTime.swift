//
//  MyRoutes.swift
//  WSDOT-iOS-iDOT
//
//  Created by Arohee Kumar.
//
//  Travel times for major roadways

import Foundation

struct TravelTime: Codable, Identifiable{
    let id: Int
    let name: String
    
    let avgTime: Int
    let currentTime: Int
    let description: String
    let timeUpdated: String
    
    let dist: Double
    
    let startPoint: RoutePoint
    let endPoint: RoutePoint
    
    enum CodingKeys: String, CodingKey {
        case id = "TravelTimeID"
        case name = "Name"
        case avgTime = "AverageTime"
        case currentTime = "CurrentTime"
        case description = "Description"
        case dist = "Distance"
        case startPoint = "StartPoint"
        case endPoint = "EndPoint"
        case timeUpdated = "TimeUpdated"
    }
}

struct RoutePoint: Codable{
    let description: String
    let direction: String
    let latitude: Double
    let longitude: Double
    let milePost: Double
    let roadName: String
    
    enum CodingKeys: String, CodingKey {
        case description = "Description"
        case direction = "Direction"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case milePost = "MilePost"
        case roadName = "RoadName"
    }
}
