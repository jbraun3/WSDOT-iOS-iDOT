//
//  RouteAlerts.swift
//  WSDOT-iOS-iDOT
//
//  Created by Arohee Kumar on 5/25/26.
//

import SwiftUI
import CoreLocation

struct RouteAlerts: View {
    let route: SavedRoute
    let date: Date

    @State private var alert: [HighwayAlertItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    

    var body: some View{
        VStack{
            Text("RouteAlerts")
        }
    }
}
