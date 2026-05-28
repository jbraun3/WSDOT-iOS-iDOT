import SwiftUI

struct TrafficMapHome: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TrafficMap()
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                            .environment(\.symbolVariants, .none)
                        Text("Location")
                    }
                }
                .tag(0)

            TrafficMapAlerts()
                .tabItem {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.text.page")
                            .environment(\.symbolVariants, .none)
                        Text("Alerts")
                    }
                }
                .tag(1)

            TrafficMapTravelerInformation()
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                            .environment(\.symbolVariants, .none)
                        Text("Settings")
                    }
                }
                .tag(2)
        }
        .wsdotTabView()
        .navigationTitle("Traffic Map")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                switch selectedTab {
                case 1:
                    Text("Alerts In This Area")
                        .foregroundColor(.white)
                        .font(.headline)
                case 2:
                    Text("Settings")
                        .foregroundColor(.white)
                        .font(.headline)
                default:
                    Image("WSDOT-logo-white")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                }
            }
        }
        .wsdotToolbar()
    }
}

#Preview {
    NavigationStack {
        TrafficMapHome()
    }
}
