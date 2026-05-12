//
//  TrafficMap.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
import SwiftUI
import MapKit

struct TrafficMap: View {
    @StateObject private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    @State private var showLegend = false
    
    var body: some View {
        
        Group {
            ZStack {
                Map(position: $position) {
                    UserAnnotation()
                }
                .mapStyle(.standard)
                .onAppear {
                    locationManager.requestLocation()
                }
                .onChange(of: locationManager.userLocation) { _, newLocation in
                    if let location = newLocation {
                        withAnimation {
                            position = .region(MKCoordinateRegion(
                                center: location.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            ))
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showLegend = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(.wsdoTprimarygreen)
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
                        .padding(.top, 67)
                        .padding(.trailing, 16)
                        .opacity(showLegend ? 0 : 1)
                        .animation(.easeInOut(duration: 0.3), value: showLegend)
                    }
                    Spacer()
                }
                
                if showLegend {
                    LegendPopup(isPresented: $showLegend)
                }
            }
        }
    }
}
