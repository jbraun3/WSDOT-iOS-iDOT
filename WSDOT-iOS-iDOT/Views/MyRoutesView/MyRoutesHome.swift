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
    @State private var selectedTab = 0
    @State private var searchRoute = false

    private var currentTitle: String {
        switch selectedTab {
        case 0: return "Route Finder"
        case 1: return "My Routes"
        default: return "My Routes"
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            MyRoutesMap(searchRoute: $searchRoute)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(0)
            MyRouteAllRoutes()
                .tabItem {
                    Label("Routes", systemImage: "list.star")
                }
                .tag(1)
        }
        .wsdotTabView()
        .navigationTitle(currentTitle)
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
        // add route toolbar button
        .toolbar {
            if selectedTab == 0 {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        searchRoute.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .rotationEffect(.degrees(searchRoute ? 45 : 0))
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: searchRoute)
                    }
                }
            }
        }
    }
}

#Preview {
    MyRoutesHome()
}
