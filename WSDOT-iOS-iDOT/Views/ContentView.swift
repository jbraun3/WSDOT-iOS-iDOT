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
            
            // Tab 1: Traffic Map
            TrafficMapView()
                .tabItem {
                    Label("Traffic", systemImage: "car.fill")
                }
            
            // Tab 2: Ferry Schedules
            FerryScheduleView()
                .tabItem {
                    Label("Ferries", systemImage: "sailboat.fill")
                }
            
            // Tab 3: Mountain Passes
            MountainPassView()
                .tabItem {
                    Label("Passes", systemImage: "mountain.2.fill")
                }
            
            // Tab 4: My Route
            MyRouteView()
                .tabItem {
                    Label("My Route", systemImage: "mountain.2.fill")
                }
            
        }
        .tint(.blue)
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
            Image(systemName: "sailboat.fill")
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
            Image(systemName: "road.lane.fill")
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

#Preview {
    ContentView()
}
