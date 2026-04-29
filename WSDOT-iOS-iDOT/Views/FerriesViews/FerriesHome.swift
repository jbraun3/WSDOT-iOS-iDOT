//
//  FerriesHome.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
import SwiftUI

struct FerriesHome: View {
    var body: some View {
         
        TabView {
            FerriesList()
                .tabItem {
                    Label("Ferries", systemImage: "ferry")
                }
            
            FerriesMap()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            FerriesAlert()
                .tabItem {
                    Label("Alerts", systemImage: "exclamationmark.triangle.text.page")
                }
            FerriesReserve()
                .tabItem {
                    Label("Reserve", systemImage: "wallet.bifold")
                }
        }
        .tint(.wsdotGreen)
    }
}

#Preview {
    FerriesHome()
}
