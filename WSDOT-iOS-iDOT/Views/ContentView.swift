//
//  ContentView.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/27/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView {
            HomePageView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            
            TrafficMapHome()
                .tabItem {
                    Label("Traffic", systemImage: "car.fill")
                }
            
            FerriesHome()
                .tabItem {
                    Label("Ferries", systemImage: "ferry.fill")
                }
            
            MountainPassesHome()
                .tabItem {
                    Label("Passes", systemImage: "mountain.2.fill")
                }
            
            BridgeAlertsHome()
                .tabItem {
                    Label("Bridges", systemImage: "bridge.fill")
                }
            
            TollRatesHome()
                .tabItem {
                    Label("Tolls", systemImage: "creditcard.fill")
                }
            
            BorderWaitsHome()
                .tabItem {
                    Label("Border", systemImage: "flag.fill")
                }
            
            AmtrakHome()
                .tabItem {
                    Label("Amtrak", systemImage: "tram.fill")
                }
            
            MyRoutesHome()
                .tabItem {
                    Label("My Routes", systemImage: "road.lanes")
                }
        }
        .tint(.wsdotGreen)
    }
}

struct HomePageView: View {
    //Traffic Map, Ferries, Mountain Passes, Bridge Alerts, Toll Rates, Border Waits, Amtrak, My Routes
    let icons = ["map.fill", "ferry.fill", "mountain.2.fill", "bridge.fill", "creditcard.fill", "flag.fill", "tram.fill", "road.lanes"]
    let labels = ["Traffic Map", "Ferries", "Mountain Passes", "Bridge Alerts", "Toll Rates", "Border Waits", "Amtrak", "My Routes"]
    
    let radius: CGFloat = 120
    
    var body: some View {
        ZStack{
            ForEach(0 ..< icons.count, id :\.self){index in
                let angle = Double(index) * (360/Double(icons.count))
                VStack{
                    Image(systemName: icons[index])
                        .font(.system(size:60))
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Text(labels[index])
                        .font(.caption)

                }
                .rotationEffect(.degrees(-angle))

                .offset(y: -radius)
                .rotationEffect(.degrees(angle))
            }
        }
    }
}
        
#Preview {
    ContentView()
}
