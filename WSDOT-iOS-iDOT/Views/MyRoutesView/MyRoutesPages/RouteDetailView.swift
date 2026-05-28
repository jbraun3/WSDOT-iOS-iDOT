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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(route.name)
                    .font(.title2).bold()
                    .padding(.horizontal)

                mapSection
                    .padding(.horizontal)
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
            Marker("Start", coordinate: route.start)
            Marker("End", coordinate: route.end)
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .mapStyle(.standard)
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
}
