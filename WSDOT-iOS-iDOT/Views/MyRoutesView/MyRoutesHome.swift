//
//  MyRoutesHome.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
//  Home page for MyRoutes
//
import SwiftUI
import MapKit

struct MyRoutesHome: View {
    @State private var routeStore = RouteStore()
    
    var body: some View {
        TabView() {
            MyRoutesMap(routeStore: routeStore)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            MyRouteAllRoutes(routeStore: routeStore)
                .tabItem {
                    Label("Routes", systemImage: "list.star")
                }
        }
        .tint(.wsdoTprimarygreen)
        .navigationTitle("My Routes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)

    }

}

#Preview {
    MyRoutesHome()
}
