import SwiftUI
import MapKit

struct TravelTimeDetailView: View {
    let travelTime: TravelTime

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                categoryBadge

                VStack(spacing: 12) {
                    infoRow(label: "Route", value: travelTime.description.replacingOccurrences(of: "Downtown ", with: ""))
                    infoRow(label: "Distance", value: "\(String(format: "%.1f", travelTime.dist)) mi")
                    infoRow(label: "From", value: travelTime.startPoint.description)
                    infoRow(label: "To", value: travelTime.endPoint.description)
                    infoRow(label: "Direction", value: travelTime.startPoint.direction)
                }
                .padding()
                .wsdotCard()

                VStack(spacing: 12) {
                    Text("Travel Times")
                        .font(.title2).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Text("Current")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(travelTime.currentTime) min")
                            .font(.title3).bold()
                    }

                    HStack {
                        Text("Average")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(travelTime.avgTime) min")
                            .foregroundColor(.secondary)
                    }

                    let diff = travelTime.currentTime - travelTime.avgTime
                    HStack {
                        Text("Status")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(diff > 0 ? "\(diff) min slower" : (diff < 0 ? "\(-diff) min faster" : "On time"))
                            .foregroundColor(diff > 0 ? .orange : .green)
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .wsdotCard()

                mapSection

                Text("Updated: \(travelTime.timeUpdated)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
        .navigationTitle("Travel Times")
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
        .wsdotFavorite(category: .travelTime, itemId: String(travelTime.id), title: travelTime.name)
    }

    private var badgeColor: Color { .purple }

    private var categoryBadge: some View {
        HStack(spacing: 8) {
            Image("icTravelTime")
                .resizable()
                .frame(width: 24, height: 24)
            Text(travelTime.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(badgeColor.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(badgeColor.opacity(0.5), lineWidth: 1)
        )
    }

    private var mapSection: some View {
        let midLat = (travelTime.startPoint.latitude + travelTime.endPoint.latitude) / 2
        let midLon = (travelTime.startPoint.longitude + travelTime.endPoint.longitude) / 2
        let latDelta = abs(travelTime.startPoint.latitude - travelTime.endPoint.latitude) * 1.5 + 0.02
        let lonDelta = abs(travelTime.startPoint.longitude - travelTime.endPoint.longitude) * 1.5 + 0.02

        return Map(initialPosition: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: midLat, longitude: midLon),
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        ))) {
            Marker(travelTime.startPoint.description, coordinate: CLLocationCoordinate2D(
                latitude: travelTime.startPoint.latitude,
                longitude: travelTime.startPoint.longitude
            ))
            Marker(travelTime.endPoint.description, coordinate: CLLocationCoordinate2D(
                latitude: travelTime.endPoint.latitude,
                longitude: travelTime.endPoint.longitude
            ))
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .mapStyle(.standard)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
        }
    }
}
