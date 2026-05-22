//
//  MyRouteAllRoutes.swift
//  WSDOT-iOS-iDOT
//
//

import SwiftUI

struct MyRouteAllRoutes: View {
    @ObservedObject var routeStore: RouteStore
    
    var body: some View {
        if routeStore.savedRoutes.isEmpty {
            VStack(spacing: 12){
                Text("No saved routes")
                Text("Tap the + button on the map to add a route")
            }
        }
        
    }
}
