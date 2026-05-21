import SwiftUI
import MapKit
import Combine

struct TrafficMap: View {
    @StateObject private var locationManager = LocationManager()

    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.5990, longitude: -122.3350),
        span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
    ))
    @State private var showLegend = false
    @State private var showLocationAlert = false
    @State private var locationAlertTitle = ""
    @State private var locationAlertMessage = ""

    @State private var cameras: [TrafficCameraItem] = []
    @State private var alerts: [HighwayAlertItem] = []
    @State private var mountainPasses: [MountainPass] = []
    @State private var travelTimes: [TravelTime] = []
    @State private var restAreas: [RestAreaItem] = []
    @State private var isLoadingCameras = true
    @State private var isLoadingAlerts = true
    @State private var isLoadingPasses = true
    @State private var isLoadingTravelTimes = true
    @State private var isLoadingRestAreas = true
    @State private var selectedCamera: TrafficCameraItem?
    @State private var savePositionTask: Task<Void, Never>?

    @AppStorage("TrafficLayerMarkerPref") private var trafficLayerOn = true
    @AppStorage("CameraMarkerPref") private var camerasOn = true
    @AppStorage("AlertsMarkerPref") private var alertsOn = true
    @AppStorage("MountainPassMarkerPref") private var mountainPassesOn = true
    @AppStorage("RestAreaMarkerPref") private var restAreasOn = true
    @AppStorage("TravelTimesMarkerPref") private var travelTimesOn = true
    @AppStorage("mapStylePref") private var mapStyle = "system"
    @AppStorage("shouldClusterCameraIcons") private var clusterCamerasOn = true

    var body: some View {
        ZStack {
            Map(position: $position) {
                UserAnnotation()

                if camerasOn {
                    ForEach(cameras) { camera in
                        Annotation(camera.title, coordinate: camera.coordinate) {
                            Image("icMapCamera")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .contentShape(Rectangle())
                                .onTapGesture { selectedCamera = camera }
                        }
                    }
                }

                if alertsOn {
                    ForEach(alerts.filter { $0.hasValidLocation }) { alert in
                        Annotation(alert.eventCategoryType, coordinate: alert.coordinate) {
                            Image(alertIconName(for: alert.travelCenterPriorityId))
                                .resizable()
                                .frame(width: 36, height: 36)
                        }
                    }
                }

                if mountainPassesOn {
                    ForEach(mountainPasses) { pass in
                        if let coordinate = pass.coordinate {
                            Annotation(pass.name, coordinate: coordinate) {
                                Image("icMountainPass")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                        }
                    }
                }

                if restAreasOn {
                    ForEach(restAreas) { area in
                        Annotation(area.location, coordinate: area.coordinate) {
                            Image(area.hasDump ? "icMapRestAreaDump" : "icMapRestArea")
                                .resizable()
                                .frame(width: 36, height: 36)
                        }
                    }
                }

                if travelTimesOn {
                    ForEach(travelTimes) { time in
                        let coord = CLLocationCoordinate2D(latitude: time.startPoint.latitude, longitude: time.startPoint.longitude)
                        if coord.latitude != 0 || coord.longitude != 0 {
                            Annotation(time.name, coordinate: coord) {
                                Image("icTravelTime")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                        }
                    }
                }
            }
            .mapStyle(
                mapStyle == "dark"
                    ? .standard(pointsOfInterest: .excludingAll, showsTraffic: trafficLayerOn)
                    : .standard(showsTraffic: trafficLayerOn)
            )
            .onAppear {
                restoreMapPosition()
                loadData()
            }
            .onChange(of: position) { _, _ in
                savePositionTask?.cancel()
                savePositionTask = Task {
                    try? await Task.sleep(for: .milliseconds(300))
                    saveMapPosition()
                }
            }
            .alert(locationAlertTitle, isPresented: $showLocationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(locationAlertMessage)
            }
            .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
                Task { await refreshAlerts() }
            }

            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        legendButton
                        cameraToggleButton
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
        .sheet(item: $selectedCamera) { camera in
            NavigationStack {
                CameraDetailView(camera: camera)
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

    private var cameraToggleButton: some View {
        Button(action: { camerasOn.toggle() }) {
            ZStack {
                Circle()
                    .fill(Color("WSDOTprimarygreen"))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                Image(systemName: camerasOn ? "camera.fill" : "camera")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
        }
    }

    private var myLocationButton: some View {
        Button(action: {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
                if let location = locationManager.currentLocation {
                    withAnimation {
                        position = .region(MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))
                    }
                } else {
                    locationManager.startUpdating()
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                locationAlertTitle = "Location Services Are Disabled"
                locationAlertMessage = "You can enable location services from Settings."
                showLocationAlert = true
            } else if CLLocationManager.authorizationStatus() == .denied {
                locationAlertTitle = "\"WSDOT\" Doesn't Have Permission To Use Your Location"
                locationAlertMessage = "You can enable location services for this app in Settings"
                showLocationAlert = true
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

    private func refreshAlerts() async {
        do {
            alerts = try await HighwayAlertsService.shared.getAlerts()
        } catch {
            print("Alert refresh error: \(error)")
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
        Task {
            do {
                mountainPasses = try await MountainPassesService.shared.getMountainPasses()
                isLoadingPasses = false
            } catch {
                print("Mountain pass load error: \(error)")
                isLoadingPasses = false
            }
        }
        Task {
            do {
                travelTimes = try await TravelTimeServices.shared.getTravelTimes()
                isLoadingTravelTimes = false
            } catch {
                print("Travel time load error: \(error)")
                isLoadingTravelTimes = false
            }
        }
        Task {
            restAreas = RestAreaService.shared.getRestAreas()
            isLoadingRestAreas = false
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

    private func alertIconName(for priorityId: Int) -> String {
        switch priorityId {
        case 1: return "icMapClosed"
        case 2: return "icMapAlertHigh"
        case 3: return "icMapAlertModerate"
        default: return "icMapAlertLow"
        }
    }
}
