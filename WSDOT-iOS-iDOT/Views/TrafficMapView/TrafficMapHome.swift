import SwiftUI

struct TrafficMapHome: View {
    var body: some View {
        TabView {
            TrafficMap()
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
        .navigationTitle("Traffic Map")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("WSDOT-logo-white")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
            }
        }
        .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        TrafficMapHome()
    }
}
