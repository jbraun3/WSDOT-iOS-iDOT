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
            
            TrafficMapLocation()
                .tabItem {
                    Label("Location", systemImage: "map")
                }
            
            TrafficMapCameras()
                .tabItem {
                    Label("Cameras", systemImage: "camera")
                }
            
            TrafficMapAlerts()
                .tabItem {
                    Label("Alerts", systemImage: "exclamationmark.triangle.text.page")
                }
            
            TrafficMapTravelerInformation()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(.wsdoTprimarygreen)
    }
}

#Preview {
    TrafficMapHome()
}
