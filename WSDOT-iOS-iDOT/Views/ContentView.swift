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
        // TabView is the SwiftUI equivalent of a bottom navigation router
        TabView {
            HomePageView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            
            
            // Tab 1: Traffic Map
            TrafficMapView()
                .tabItem {
                    Label("Traffic", systemImage: "car.fill")
                }
            
            // Tab 2: Ferry Schedules
            FerryScheduleView()
                .tabItem {
                    Label("Ferries", systemImage: "ferry.fill")
                }
            
            // Tab 3: Mountain Passes
            MountainPassView()
                .tabItem {
                    Label("Passes", systemImage: "mountain.2.fill")
                }
            
            // Tab 4: My Route
            MyRouteView()
                .tabItem {
                    Label("My Route", systemImage: "road.lanes")
                }
            
        }
        .tint(.wsdotGreen)
    }
}

// MARK: - Placeholder Views
// These are the structs Xcode was looking for!
struct TrafficMapView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "map.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("Traffic Map")
                .font(.largeTitle)
                .bold()
            Text("Statewide traffic cameras and travel alerts.")
                .foregroundColor(.secondary)
        }
    }
}

struct FerryScheduleView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "ferry.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("Ferry Schedules")
                .font(.largeTitle)
                .bold()
            Text("Alerts and real-time ferry locations.")
                .foregroundColor(.secondary)
        }
    }
}

struct MountainPassView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "mountain.2.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("Mountain Passes")
                .font(.largeTitle)
                .bold()
            Text("Pass conditions and weather reports.")
                .foregroundColor(.secondary)
        }
    }
}

struct MyRouteView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "road.lanes")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("My Route")
                .font(.largeTitle)
                .bold()
            Text("Alerts impacting travel routes")
                .foregroundColor(.secondary)
        }
    }
}

struct HomePageView: View {
    //Traffic Map, Ferries, Mountain Passes, Bridge Alerts, Toll Rates, Border Waits, Amtrak, My Routes
    let icons = ["map.fill", "ferry.fill", "mountain.2.fill", "figure.walk.diamond", "rectangle.fill", "leaf.fill", "tram.fill", "road.lanes"]
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
