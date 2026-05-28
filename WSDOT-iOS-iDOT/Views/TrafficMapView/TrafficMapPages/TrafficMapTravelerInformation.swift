import SwiftUI

struct TrafficMapTravelerInformation: View {
    @AppStorage("TrafficLayerMarkerPref") private var trafficLayerOn = true
    @AppStorage("AlertsMarkerPref") private var alertsOn = true
    @AppStorage("MountainPassMarkerPref") private var mountainPassesOn = true
    @AppStorage("RestAreaMarkerPref") private var restAreasOn = true
    @AppStorage("TravelTimesMarkerPref") private var travelTimesOn = true
    @AppStorage("shouldClusterCameraIcons") private var clusterCamerasOn = true

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
                    MapLayerRow(systemName: "car.2.fill", label: "Traffic Layer", isOn: $trafficLayerOn)
                    MapLayerRow(imageName: "icMapAlertLow", label: "WSDOT Alerts", isOn: $alertsOn)
                    MapLayerRow(imageName: "icMountainPass", label: "Mountain Passes", isOn: $mountainPassesOn)
                    MapLayerRow(imageName: "icMapRestArea", label: "Rest Areas", isOn: $restAreasOn)
                    MapLayerRow(imageName: "icTravelTime", label: "Travel Times", isOn: $travelTimesOn)
                    MapLayerRow(imageName: "icMapCamera", label: "Cluster Cameras", isOn: $clusterCamerasOn)
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .wsdotToolbar()
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

struct MapLayerRow: View {
    let imageName: String?
    let systemName: String?
    let label: String
    @Binding var isOn: Bool

    init(imageName: String, label: String, isOn: Binding<Bool>) {
        self.imageName = imageName
        self.systemName = nil
        self.label = label
        self._isOn = isOn
    }

    init(systemName: String, label: String, isOn: Binding<Bool>) {
        self.imageName = nil
        self.systemName = systemName
        self.label = label
        self._isOn = isOn
    }

    var body: some View {
        HStack {
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            } else if let systemName = systemName {
                Image(systemName: systemName)
                    .foregroundColor(.accentColor)
                    .frame(width: 24)
            }
            Text(label)
            Spacer()
            Toggle("", isOn: $isOn)
        }
    }
}
