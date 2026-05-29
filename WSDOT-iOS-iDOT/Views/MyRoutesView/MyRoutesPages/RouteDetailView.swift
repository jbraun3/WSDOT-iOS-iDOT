//
//  RouteDetailView.swift
//  WSDOT-iOS-iDOT
//
//  Detail screen for a single saved route. Hosts the favorite star.
//

import SwiftUI
import MapKit

struct RouteDetailView: View {
    let route: SavedRoute

    @State private var selectedTab = "Alerts"
    @State private var selectedDate: Date = Date()
    
    @Namespace private var tabNamespace
    
    
    @State private var calculatedRoute: MKRoute? = nil
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(route.name)
                    .font(.headline).bold()
                    .padding(.horizontal)

                mapSection
                    .padding(.horizontal)
                
                HStack{
                    Text("Date Using Route:")
                        .font(.subheadline)
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .padding(.horizontal)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
                .padding(.horizontal)
                
                HStack(spacing: 0){
                    ForEach(["Alerts", "Travel Times", "Cameras"], id: \.self){ tab in
                        Button {
                            withAnimation(.spring()){
                                selectedTab = tab
                            }
                        } label: {
                            Text(tab)
                                .font(.subheadline)
                                .foregroundColor(selectedTab == tab ? .primary : .wsdoTprimarygreen)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                        }
                        .background(
                            Group{
                                if selectedTab == tab{
                                    Capsule()
                                        .fill(Color(.wsdoTprimarygreen))
                                }
                            }
                        )


                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)

                switch selectedTab{
                case "Alerts":
                    RouteAlerts(route: route, date: selectedDate)
                case "Travel Times":
                    RouteTravelTimes()
                case "Cameras":
                    RouteCameras()
                default:
                    EmptyView()
                }

                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle(route.name)
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
        .wsdotFavorite(category: .route, itemId: route.id.uuidString, title: route.name)
        
    }

    private var mapSection: some View {
        Map(initialPosition: .rect(boundingRect)) {
            if let polyline = calculatedRoute?.polyline {
                MapPolyline(polyline)
                    .stroke(Color(.wsdoTlimegreen), lineWidth: 5)
            }
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .mapStyle(.standard)
        .task{
            await fetchRoute()
        }
    }

    private var boundingRect: MKMapRect {
        let startPoint = MKMapPoint(route.start)
        let endPoint = MKMapPoint(route.end)
        let minX = min(startPoint.x, endPoint.x)
        let minY = min(startPoint.y, endPoint.y)
        let width = abs(startPoint.x - endPoint.x)
        let height = abs(startPoint.y - endPoint.y)
        let rect = MKMapRect(x: minX, y: minY, width: width, height: height)
        return rect.insetBy(dx: -width * 0.3, dy: -height * 0.3)
    }
    

    
    func fetchRoute() async {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: route.start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: route.end))
        request.transportType = .automobile
        
        if let response = try? await MKDirections(request: request).calculate(){
            if let routeLine = response.routes.first{
                self.calculatedRoute = routeLine
                position = .rect(routeLine.polyline.boundingMapRect)
            }
        }
    }
}

//
//struct RouteCard: View {
//    let route: SavedRoute
//
//    @State private var selectedTab = "Alerts"
//    @State private var selectedDate: Date = Date()
//    
//    @Namespace private var tabNamespace
//    
//    @State private var calculatedRoute: MKRoute? = nil
//    @State private var position: MapCameraPosition = .automatic
//
//    
//    var body: some View{
//        GeometryReader{ geometry in
//            VStack(spacing: 0){
//                Map(position: $position){
//                    if let polyline = calculatedRoute?.polyline {
//                        MapPolyline(polyline)
//                            .stroke(Color(.wsdoTlimegreen), lineWidth: 5)
//                    }
//                }.frame(height: geometry.size.height * 0.4)
//                VStack(spacing: 5){
//                    HStack{
//                        Text("Date Using Route:")
//                            .font(.subheadline)
//                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
//                            .padding(.horizontal)
//                            .datePickerStyle(.compact)
//                            .labelsHidden()
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 8)
//                    
//                    // navigation bar for alerts, travel times, and cameras for the chosen route
//                    HStack(spacing: 0){
//                        ForEach(["Alerts", "Travel Times", "Cameras"], id: \.self){ tab in
//                            Button {
//                                withAnimation(.spring()){
//                                    selectedTab = tab
//                                }
//                            } label: {
//                                Text(tab)
//                                    .font(.subheadline)
//                                    .foregroundColor(selectedTab == tab ? .primary : .wsdoTprimarygreen)
//                                    .frame(maxWidth: .infinity)
//                                    .padding(.vertical, 4)
//                            }
//                            .background(
//                                Group{
//                                    if selectedTab == tab{
//                                        Capsule()
//                                            .fill(Color(.wsdoTprimarygreen))
//                                    }
//                                }
//                            )
//                            
//                            
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 8)
//                    
//                    switch selectedTab{
//                    case "Alerts":
//                        RouteAlerts(route: route, date: selectedDate)
//                    case "Travel Times":
//                        RouteTravelTimes()
//                    case "Cameras":
//                        RouteCameras()
//                    default:
//                        EmptyView()
//                    }
//                    
//                    Spacer()
//                }
//                .frame(height: geometry.size.height * 0.6)
//            }
//        }
//        .task{
//            await fetchRoute()
//        }
//    }
//    
//
//}
//
//
