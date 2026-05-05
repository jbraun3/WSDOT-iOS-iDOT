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
                        withAnimation {
                            showLegend.toggle()
                        }
                    }) {
                        Image("legendinfoicon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 41)
                    }
                    .padding(.top, 67)
                    .padding(.trailing, 16)
                }
                Spacer()
            }
            
            if showLegend {
                LegendPopup(isPresented: $showLegend)
            }
        }
    }
}

struct LegendPopup: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            Text("Legend Info")
                .foregroundColor(.white)
                .padding(24)
                .background(.black.opacity(0.6), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(32)
        }
    }
}
