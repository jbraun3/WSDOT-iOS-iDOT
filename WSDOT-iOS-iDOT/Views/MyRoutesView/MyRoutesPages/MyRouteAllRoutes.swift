//
//  MyRouteAllRoutes.swift
//  WSDOT-iOS-iDOT
//
//

import SwiftUI
import SwiftData

struct MyRouteAllRoutes: View {
    @Query private var savedRoutes: [SavedRoute]

    var body: some View {
        if savedRoutes.isEmpty {
            VStack(spacing: 12) {
                Text("No saved routes")
                Text("Tap the + button on the map to add a route")
            }
        } else {
            // TODO add styling
            List(savedRoutes) { route in
                NavigationLink {
                    RouteDetailView(route: route)
                } label: {
                    Text(route.name)
                }
            }
        }
    }
}
