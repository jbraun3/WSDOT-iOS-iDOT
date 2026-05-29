//
//  FerriesHome.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
import SwiftUI

struct FerriesHome: View {
    @State private var selectedTab = 0

    private var currentTitle: String {
        switch selectedTab {
        case 0: return "Ferries"
        case 1: return "Map"
        case 2: return "Alerts"
        case 3: return "Reserve"
        default: return "Ferries"
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            FerriesList()
                .tabItem {
                    Label("Ferries", systemImage: "ferry")
                }
                .tag(0)
            FerriesMap()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
            FerriesAlert()
                .tabItem {
                    Label("Alerts", systemImage: "exclamationmark.triangle.text.page")
                }
                .tag(2)
            FerriesReserve()
                .tabItem {
                    Label("Reserve", systemImage: "wallet.bifold")
                }
                .tag(3)
        }
        .wsdotTabView()
        .navigationTitle(currentTitle)
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
    }
}

#Preview {
    FerriesHome()
}
