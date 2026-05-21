import SwiftUI
import MapKit

struct TrafficMap: View {
    @StateObject private var locationManager = LocationManager()

    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    ))
    @State private var showLegend = false

    @State private var cameras: [TrafficCameraItem] = []
    @State private var alerts: [HighwayAlertItem] = []
    @State private var isLoadingCameras = true
    @State private var isLoadingAlerts = true

    @AppStorage("CameraMarkerPref") private var camerasOn = true
    @AppStorage("AlertsMarkerPref") private var alertsOn = true
    @AppStorage("mapStylePref") private var mapStyle = "system"

    var body: some View {
        ZStack {
            Map(position: $position) {
                UserAnnotation()

                if camerasOn {
                    ForEach(cameras) { camera in
                        Annotation(camera.title, coordinate: camera.coordinate) {
                            Image(systemName: camera.isVideo ? "video.fill" : "camera.fill")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                        }
                    }
                }

                if alertsOn {
                    ForEach(alerts.filter { $0.hasValidLocation }) { alert in
                        Annotation(alert.eventCategoryType, coordinate: alert.coordinate) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(4)
                                .background(alertColor(alert.travelCenterPriorityId))
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .mapStyle(mapStyle == "dark" ? .standard(pointsOfInterest: .excludingAll) : .standard)
            .onAppear {
                locationManager.requestLocation()
                restoreMapPosition()
                loadData()
            }
            .onChange(of: position) { _, _ in
                saveMapPosition()
            }

            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        legendButton
                        myLocationButton
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 67)
                }
                Spacer()
            }

            if showLegend {
                LegendPopup(isPresented: $showLegend)
            }
        }
    }

    private var legendButton: some View {
        Button(action: { showLegend = true }) {
            ZStack {
                Circle()
                    .fill(Color("WSDOTprimarygreen"))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                Image(systemName: "ellipsis")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .opacity(showLegend ? 0 : 1)
        .animation(.easeInOut(duration: 0.3), value: showLegend)
    }

    private var myLocationButton: some View {
        Button(action: {
            if let location = locationManager.userLocation {
                withAnimation {
                    position = .region(MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            } else {
                locationManager.requestLocation()
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color("WSDOTprimarygreen"))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                Image(systemName: "location.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
        }
    }

    private func loadData() {
        Task {
            do {
                cameras = try await TrafficCameraService.shared.getCameras()
                isLoadingCameras = false
            } catch {
                print("Camera load error: \(error)")
                isLoadingCameras = false
            }
        }
        Task {
            do {
                alerts = try await HighwayAlertsService.shared.getAlerts()
                isLoadingAlerts = false
            } catch {
                print("Alert load error: \(error)")
                isLoadingAlerts = false
            }
        }
    }

    private func restoreMapPosition() {
        let lat = UserDefaults.standard.double(forKey: "MapLatitudeBound")
        let lon = UserDefaults.standard.double(forKey: "MapLongitudeBound")
        let zoom = UserDefaults.standard.float(forKey: "MapZoom")
        if lat != 0, lon != 0 {
            let spanDelta = Double(max(0.01, 0.5 / Double(max(zoom, 1))))
            position = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)
            ))
        }
    }

    private func saveMapPosition() {
        if let region = position.region {
            UserDefaults.standard.set(region.center.latitude, forKey: "MapLatitudeBound")
            UserDefaults.standard.set(region.center.longitude, forKey: "MapLongitudeBound")
            let delta = region.span.latitudeDelta
            let zoom = delta > 0 ? Float(0.5 / delta) : 12.0
            UserDefaults.standard.set(zoom, forKey: "MapZoom")
        }
    }

    private func alertColor(_ priorityId: Int) -> Color {
        switch priorityId {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        default: return .accentColor
        }
    }
}
