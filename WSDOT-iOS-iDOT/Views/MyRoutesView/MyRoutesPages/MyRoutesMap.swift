//
//  MyRoutesMap.swift
//  WSDOT-iOS-iDOT
//
// TODO: input selection of route, edit animation

import SwiftUI
import SwiftData
import MapKit

struct MyRoutesMap: View {

    @Environment(\.modelContext) private var modelContext
    @Binding var searchRoute: Bool
    @State private var startSearch = ""
    @State private var endSearch = ""
    @State private var startResult: CLLocationCoordinate2D?
    @State private var endResult: CLLocationCoordinate2D?
    @State private var isSearchStart = false
    @State private var chosenRoute: MKRoute?
    @State private var routeOptions: [MKRoute] = []
    @StateObject private var routeSearchCompleter = SearchCompleter()

    var canSubmit: Bool { startResult != nil && endResult != nil }
    var canSave: Bool { chosenRoute != nil }

    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.5990, longitude: -122.3350),
        span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
    ))

    var body: some View {
        Map(position: $position) {
            ForEach(routeOptions, id: \.name) { route in
                MapPolyline(route.polyline)
                    .stroke(
                        route.name == chosenRoute?.name ? Color(.wsdoTlimegreen) : Color(.wsdoTgrey),
                        lineWidth: route.name == chosenRoute?.name ? 5 : 3
                    )
            }
        }
        .sheet(isPresented: $searchRoute) {
            routeFinderSheet
                .presentationDetents([.fraction(0.35), .large])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
        }
    }

    // MARK: - Route Finder Sheet

    private var routeFinderSheet: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Add New Route")
                    .font(.headline)
                    .padding(.top, 8)

                // starting location
                VStack(alignment: .leading, spacing: 4) {
                    Label("Starting Location", systemImage: "mappin.circle")
                        .font(.caption)
                        .foregroundColor(.wsdoTprimarygreen)
                    TextField("Search start location", text: $startSearch)
                        .textFieldStyle(.roundedBorder)
                        .onTapGesture {
                            isSearchStart = true
                        }
                        .onChange(of: startSearch) { _, val in
                            routeSearchCompleter.search(val)
                            isSearchStart = true
                            startResult = nil
                            resetRoutes()
                        }
                    if isSearchStart && !routeSearchCompleter.results.isEmpty && startResult == nil {
                        suggestedRoutes(routeSearchCompleter.results) { completed in
                            startSearch = completed.title + (completed.subtitle.isEmpty ? "" : ", \(completed.subtitle)")
                            geocode(startSearch) { coord in
                                startResult = coord
                            }
                            isSearchStart = false
                            routeSearchCompleter.results = []
                        }
                    }
                }

                // ending location
                VStack(alignment: .leading, spacing: 4) {
                    Label("Ending Location", systemImage: "mappin.circle")
                        .font(.caption)
                        .foregroundColor(.wsdoTprimarygreen)
                    TextField("Search end location", text: $endSearch)
                        .textFieldStyle(.roundedBorder)
                        .onTapGesture {
                            isSearchStart = false
                        }
                        .onChange(of: endSearch) { _, val in
                            routeSearchCompleter.search(val)
                            isSearchStart = false
                            endResult = nil
                        }
                    if !isSearchStart && !routeSearchCompleter.results.isEmpty && endResult == nil {
                        suggestedRoutes(routeSearchCompleter.results) { completed in
                            endSearch = completed.title + (completed.subtitle.isEmpty ? "" : ", \(completed.subtitle)")
                            geocode(endSearch) { coord in
                                endResult = coord
                                if let start = startResult {
                                    Task {
                                        await fetchRouteOptions(start: start, end: coord)
                                    }
                                }
                            }
                            isSearchStart = false
                            routeSearchCompleter.results = []
                        }
                    }
                }

                // submit button
                Button {
                    guard let start = startResult, let end = endResult else { return }
                    modelContext.insert(SavedRoute(id: UUID(),
                                                   name: "\(startSearch) → \(endSearch)",
                                                   startLocation: start,
                                                   endLocation: end))
                    startSearch = ""
                    endSearch = ""
                    startResult = nil
                    endResult = nil
                    resetRoutes()
                    searchRoute = false
                } label: {
                    Text("Save Route")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canSubmit ? Color(.wsdoTprimarygreen) : Color(.wsdoTgrey25))
                        .foregroundColor(.white)
                        .cornerRadius(WSDOTStyle.cardCornerRadius)
                }
                .disabled(!canSubmit)
            }
            .padding()
        }
    }

    @ViewBuilder
    func suggestedRoutes(_ results: [MKLocalSearchCompletion], onSelect: @escaping (MKLocalSearchCompletion) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(results, id: \.self) { result in
                Button {
                    onSelect(result)
                } label: {
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        if !result.subtitle.isEmpty {
                            Text(result.subtitle)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
            }
        }
    }

    // MARK: -Helper Functions

    func fetchRouteOptions(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) async {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        if let response = try? await MKDirections(request: request).calculate() {
            routeOptions = response.routes.sorted { $0.distance < $1.distance }
            chosenRoute = routeOptions.first
            if let route = routeOptions.first {
                position = .rect(route.polyline.boundingMapRect)
            }
        }
    }

    func geocode(_ query: String, completed: @escaping (CLLocationCoordinate2D) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            if let item = response?.mapItems.first {
                completed(item.placemark.coordinate)
            }
        }
    }

    func resetRoutes() {
        routeOptions = []
        chosenRoute = nil
    }
}
