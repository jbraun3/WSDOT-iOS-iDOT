import SwiftUI

struct TrafficMapTravelerInformation: View {
    @AppStorage("TrafficLayerMarkerPref") private var trafficLayerOn = true
    @AppStorage("AlertsMarkerPref") private var alertsOn = true
    @AppStorage("CameraMarkerPref") private var camerasOn = true
    @AppStorage("MountainPassMarkerPref") private var mountainPassesOn = true
    @AppStorage("RestAreaMarkerPref") private var restAreasOn = true
    @AppStorage("TravelTimesMarkerPref") private var travelTimesOn = true

    @State private var showLegend = false
    @State private var showMapStylePicker = false
    @AppStorage("mapStylePref") private var mapStyle = "system"

    var body: some View {
        NavigationStack {
            List {
                Section("Map Style") {
                    Button(action: { showMapStylePicker = true }) {
                        HStack {
                            Image(systemName: "map.fill")
                                .foregroundColor(.accentColor)
                            Text("Style")
                            Spacer()
                            Text(mapStyleDisplayName)
                                .foregroundColor(.secondary)
                        }
                    }
                    .confirmationDialog("Map Style", isPresented: $showMapStylePicker) {
                        Button("System") { mapStyle = "system" }
                        Button("Light") { mapStyle = "light" }
                        Button("Dark") { mapStyle = "dark" }
                        Button("Cancel", role: .cancel) {}
                    }
                }

                Section("Map Layers") {
                    ToggleRow(icon: "car.2.fill", label: "Traffic Layer", isOn: $trafficLayerOn)
                    ToggleRow(icon: "exclamationmark.triangle.fill", label: "WSDOT Alerts", isOn: $alertsOn)
                    ToggleRow(icon: "camera.fill", label: "Cameras", isOn: $camerasOn)
                    ToggleRow(icon: "mountain.2.fill", label: "Mountain Passes", isOn: $mountainPassesOn)
                    ToggleRow(icon: "tent.fill", label: "Rest Areas", isOn: $restAreasOn)
                    ToggleRow(icon: "clock.fill", label: "Travel Times", isOn: $travelTimesOn)
                }

                Section("Information") {
                    Button(action: { showLegend = true }) {
                        HStack {
                            Image(systemName: "map.circle.fill")
                                .foregroundColor(.accentColor)
                            Text("Map Legend")
                        }
                    }

                    Link(destination: URL(string: "https://wsdot.wa.gov/travel/real-time/mountainpasses")!) {
                        HStack {
                            Image(systemName: "snowflake")
                                .foregroundColor(.accentColor)
                            Text("Mountain Passes")
                        }
                    }

                    Link(destination: URL(string: "https://mygoodtogo.com")!) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(.accentColor)
                            Text("My Good To Go")
                        }
                    }

                    Link(destination: URL(string: "https://wsdot.wa.gov")!) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.accentColor)
                            Text("WSDOT Website")
                        }
                    }
                }
            }
            .navigationTitle("Traveler Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showLegend) {
                LegendPopup(isPresented: $showLegend)
            }
        }
    }

    private var mapStyleDisplayName: String {
        switch mapStyle {
        case "light": return "Light"
        case "dark": return "Dark"
        default: return "System"
        }
    }
}

struct ToggleRow: View {
    let icon: String
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            Text(label)
            Spacer()
            Toggle("", isOn: $isOn)
        }
    }
}
