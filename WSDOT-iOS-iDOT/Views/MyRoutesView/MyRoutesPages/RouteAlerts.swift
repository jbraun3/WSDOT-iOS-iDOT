//
//  RouteAlerts.swift
//  WSDOT-iOS-iDOT
//
//  Created by Arohee Kumar on 5/25/26.
//

import SwiftUI
import CoreLocation
import MapKit

struct RouteAlerts: View {
    let route: SavedRoute
    let date: Date
    let today = Date()

    @State private var allAlerts: [HighwayAlertItem] = []
    @State private var routePolylinePoints: [CLLocationCoordinate2D] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    

    var body: some View{
        VStack(alignment: .leading, spacing: 0){
            if isLoading {
                HStack{
                    Spacer()
                    ProgressView("Loading Alerts")
                        .padding()
                    Spacer()
                    
                }
            } else if filteredAlerts.isEmpty{
                emptyView
            }else{
                alertList
            }
        }
        .task(id: route.id){
            await withTaskGroup(of:Void.self){ group in
                group.addTask {await loadAlerts()}
                group.addTask {await loadPolyline()}
            }
        }
    }
    
    //MARK: -Filtering Alerts to display
    private var filteredAlerts: [HighwayAlertItem] {
        allAlerts.filter{ alert in
            isOnRoute(alert) && isActive(alert, onDate: date)
        }
    }
//    
    private func isOnRoute(_ alert: HighwayAlertItem) -> Bool{
        guard alert.hasValidLocation else {return false}
        let alertLocation = CLLocation(latitude: alert.coordinate.latitude, longitude: alert.coordinate.longitude)
        let thresholdMeters: Double = 100
        
        if !routePolylinePoints.isEmpty {
            return routePolylinePoints.contains { point in
                let pointLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
                return alertLocation.distance(from: pointLocation) <= thresholdMeters
            }
        }
        return false
    }
    
    private func isActive(_ alert: HighwayAlertItem, onDate: Date) -> Bool{
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: onDate)
        guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else {return false}
        
        guard let alertStart = parseDotNetDate(alert.startTime) else{
            return true
        }
        
        let alertEnd: Date? = alert.endTime.flatMap{parseDotNetDate($0)}
        
        guard alertStart < dayEnd else {return false}
        
        if let end = alertEnd{
            return end > dayStart
        }
        return true
    }
    
    private func parseDotNetDate(_ dateString: String) -> Date? {
        let pattern = #"\/Date\((\d+)([+-]\d{4})?\)\/"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: dateString, range: NSRange(dateString.startIndex..., in: dateString)) else {
            return nil
        }
        let msRange = match.range(at: 1)
        let msString = (dateString as NSString).substring(with: msRange)
        guard let ms = Double(msString) else { return nil }
        return Date(timeIntervalSince1970: ms / 1000)
    }
    
    
    private var alertList: some View{
        VStack(spacing: 10){
            ForEach(filteredAlerts){ alert in
                AlertCard(alert: alert)
            }
            Text("alert list")
        }
        .padding(.horizontal)
    }
    
    
    
    private var emptyView: some View{
        HStack(spacing: 12){
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.wsdoTprimarygreen)
            VStack(alignment: .leading, spacing: 2){
                Text("No alerts on this route")
                    .font(.subheadline)
                Text("No current alerts for this route as of \(today) for \(date)")
                    .font(.caption)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.wsdoTgrey))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
    
    private func loadAlerts() async{
        isLoading = true
        errorMessage = nil
        
        do{
            allAlerts = try await HighwayAlertsService.shared.getAlerts()
        } catch{
            errorMessage = "Error loading alerts: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    private func loadPolyline()async{
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: route.start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: route.end))
        request.transportType = .automobile
        
        guard let response = try? await MKDirections(request: request).calculate(),
              let mkRoute = response.routes.first else {return}
        
        
        let polyline = mkRoute.polyline
        var coords = [CLLocationCoordinate2D](
            repeating: kCLLocationCoordinate2DInvalid, count:polyline.pointCount
        )
        polyline.getCoordinates(&coords, range: NSRange(location: 0, length: polyline.pointCount))
        routePolylinePoints = coords
    }
    
    
    //MARK: -AlertCard
    
    private struct AlertCard: View{
        let alert: HighwayAlertItem
        
        @State private var isExpanded = false
        
        var body: some View{
            VStack(alignment: .leading, spacing: 2){
                Button{
                    withAnimation(.spring){
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(alignment: .top){
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 4)
                        Text(alert.headlineDescription)
                    }
                }
                
            }
        }
    }
    
    
    
}
