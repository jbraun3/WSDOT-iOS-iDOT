//
//  TrafficMapHome.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
import SwiftUI

struct TrafficMapHome: View {
    var body: some View {
        TabView {
            TrafficMapRefresh()
                .tabItem {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            
            TrafficMapLocation()
                .tabItem {
                    Label("Location", systemImage: "location.fill")
                }
            
            TrafficMapCameras()
                .tabItem {
                    Label("Cameras", systemImage: "camera.fill")
                }
            
            TrafficMapAlerts()
                .tabItem {
                    Label("Alerts", systemImage: "exclamationmark.triangle.text.page")
                }
            
            TrafficMapSettings()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.wsdotGreen)
    }
}

#Preview {
    TrafficMapHome()
}
