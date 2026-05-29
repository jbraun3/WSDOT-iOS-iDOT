//
//  FavoriteItem.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/27/26.
//

import Foundation
import SwiftData

// Each case maps to one favoritable feature in the app.
// To support a new feature, add a case here and fill in its label and icon.
enum FavoriteCategory: String, Codable, CaseIterable {
    case mountainPass
    case trafficCamera
    case borderWait
    case travelTime
    case tollRate
    case route
    case ferryRoute

    var label: String {
        switch self {
        case .mountainPass:   return "Mountain Passes"
        case .trafficCamera:  return "Traffic Cameras"
        case .borderWait:     return "Border Waits"
        case .travelTime:     return "Travel Times"
        case .tollRate:       return "Toll Rates"
        case .route:          return "My Routes"
        case .ferryRoute:     return "Ferries"
        }
    }

    var icon: String {
        switch self {
        case .mountainPass:   return "icHomePasses"
        case .trafficCamera:  return "icHomeTraffic"
        case .borderWait:     return "icHomeBorderWaits"
        case .travelTime:     return "icHomeMyRoutes"
        case .tollRate:       return "icHomeTollRates"
        case .route:          return "icHomeMyRoutes"
        case .ferryRoute:     return "icHomeFerries"
        }
    }
}

@Model
final class FavoriteItem {
    var category: FavoriteCategory
    var itemId: String
    var title: String
    var subtitle: String?
    var addedDate: Date

    init(category: FavoriteCategory, itemId: String, title: String, subtitle: String? = nil) {
        self.category = category
        self.itemId = itemId
        self.title = title
        self.subtitle = subtitle
        self.addedDate = Date()
    }
}
