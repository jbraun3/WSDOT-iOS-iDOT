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
    @State private var selectedAlert: HighwayAlertItem?
    @State private var selectedPass: MountainPass?
    @State private var selectedRestArea: RestAreaItem?
    @State private var selectedTravelTimeGroup: TravelTimeGroup?
    @State private var savePositionTask: Task<Void, Never>?
    @State private var hasCenteredOnUser = false

    @AppStorage("TrafficLayerMarkerPref") private var trafficLayerOn = true
    @AppStorage("CameraMarkerPref") private var camerasOn = true
    @AppStorage("AlertsMarkerPref") private var alertsOn = true
    @AppStorage("MountainPassMarkerPref") private var mountainPassesOn = true
    @AppStorage("RestAreaMarkerPref") private var restAreasOn = true
    @AppStorage("TravelTimesMarkerPref") private var travelTimesOn = true
    @AppStorage("mapStylePref") private var mapStyle = "system"

    var body: some View {
        ZStack {
            Map(position: $position) {
                UserAnnotation()

                if camerasOn {
                    ForEach(cameras) { camera in
                        Annotation("", coordinate: camera.coordinate) {
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
                        Annotation("", coordinate: alert.coordinate) {
                            Image(alert.mapIconName)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .contentShape(Rectangle())
                                .onTapGesture { selectedAlert = alert }
                        }
                    }
                }

                if mountainPassesOn {
                    ForEach(mountainPasses) { pass in
                        if let coordinate = pass.coordinate {
                            Annotation("", coordinate: coordinate) {
                                Image("icMountainPass")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .contentShape(Rectangle())
                                    .onTapGesture { selectedPass = pass }
                            }
                        }
                    }
                }

                if restAreasOn {
                    ForEach(restAreas) { area in
                        Annotation("", coordinate: area.coordinate) {
                            Image(area.hasDump ? "icMapRestAreaDump" : "icMapRestArea")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .contentShape(Rectangle())
                                .onTapGesture { selectedRestArea = area }
                        }
                    }
                }

                if travelTimesOn {
                    let groups = groupTravelTimes(travelTimes)
                    ForEach(groups) { group in
                        Annotation("", coordinate: group.center) {
                            Image("icTravelTime")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .contentShape(Rectangle())
                                .onTapGesture { selectedTravelTimeGroup = group }
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
                if !hasCenteredOnUser, let location = locationManager.userLocation, UserDefaults.standard.double(forKey: "MapLatitudeBound") == 0 {
                    hasCenteredOnUser = true
                    position = .region(MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
                if UserDefaults.standard.double(forKey: "MapLatitudeBound") == 0 {
                    locationManager.requestLocation()
                }
                loadData()
            }
            .onReceive(locationManager.$userLocation.compactMap { $0 }) { location in
                guard !hasCenteredOnUser, UserDefaults.standard.double(forKey: "MapLatitudeBound") == 0 else { return }
                hasCenteredOnUser = true
                position = .region(MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
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
        .sheet(item: $selectedAlert) { alert in
            NavigationStack {
                AlertDetailView(alert: alert)
            }
        }
        .sheet(item: $selectedPass) { pass in
            NavigationStack {
                MountainPassesDetail(pass: pass)
            }
        }
        .sheet(item: $selectedRestArea) { area in
            NavigationStack {
                RestAreaDetailView(restArea: area)
            }
        }
        .sheet(item: $selectedTravelTimeGroup) { group in
            NavigationStack {
                TravelTimeListView(group: group)
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
        if lat != 0, lon != 0 {
            let zoom = UserDefaults.standard.float(forKey: "MapZoom")
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

    private func groupTravelTimes(_ times: [TravelTime]) -> [TravelTimeGroup] {
        let filtered = times.filter { !$0.name.localizedCaseInsensitiveContains("HOV") && !$0.description.localizedCaseInsensitiveContains("HOV") }
        let threshold = 0.05
        var groups: [TravelTimeGroup] = []
        for time in filtered {
            let coord = CLLocationCoordinate2D(latitude: time.startPoint.latitude, longitude: time.startPoint.longitude)
            if coord.latitude == 0 && coord.longitude == 0 { continue }
            if let idx = groups.firstIndex(where: { abs($0.center.latitude - coord.latitude) < threshold && abs($0.center.longitude - coord.longitude) < threshold }) {
                var updated = groups[idx]
                updated.times.append(time)
                let lat = updated.times.reduce(0.0) { $0 + $1.startPoint.latitude } / Double(updated.times.count)
                let lon = updated.times.reduce(0.0) { $0 + $1.startPoint.longitude } / Double(updated.times.count)
                updated.center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                groups[idx] = updated
            } else {
                groups.append(TravelTimeGroup(id: "\(coord.latitude)-\(coord.longitude)", times: [time], center: coord))
            }
        }
        return groups
    }

}
