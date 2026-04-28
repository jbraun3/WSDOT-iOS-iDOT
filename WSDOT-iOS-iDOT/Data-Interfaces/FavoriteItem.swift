//
//  Item.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/27/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteItem {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
