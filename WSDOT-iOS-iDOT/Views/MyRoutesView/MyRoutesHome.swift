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
    var body: some View {
        TabView() {
            MyRoutesMap()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            MyRouteAllRoutes()
                .tabItem {
                    Label("Routes", systemImage: "list.star")
                }
        }
        .wsdotTabView()
    }
}

#Preview {
    MyRoutesHome()
}
