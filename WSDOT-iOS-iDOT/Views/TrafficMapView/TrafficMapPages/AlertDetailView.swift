import SwiftUI
import MapKit

struct AlertDetailView: View {
    let alert: HighwayAlertItem

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                categoryBadge

                descriptionSection

                VStack(spacing: 12) {
                    infoRow(label: "Road", value: alert.roadName)
                    infoRow(label: "Direction", value: alert.startDirection)
                    infoRow(label: "Region", value: alert.region)
                    infoRow(label: "Priority", value: alert.priority)
                    if let county = alert.county, !county.isEmpty {
                        infoRow(label: "County", value: county)
                    }
                    infoRow(label: "Updated", value: alert.timeAgo)
                }
                .padding()
                .wsdotCard()

                mapSection
            }
            .padding()
        }
        .navigationTitle("Alert")
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
    }

    private var categoryBadge: some View {
        HStack(spacing: 8) {
            Image(alert.mapIconName)
                .resizable()
                .frame(width: 24, height: 24)
            Text(alert.eventCategoryTypeDescription)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(categoryColor.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(categoryColor.opacity(0.5), lineWidth: 1)
        )
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "info.circle.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Description")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }

            if !alert.headlineDescription.isEmpty {
                Text(alert.headlineDescription)
                    .font(.body)
                    .foregroundColor(.primary)
            }

            if let desc = alert.extendedDescription, !desc.isEmpty {
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .wsdotCard()
    }

    private var mapSection: some View {
        let lat = alert.hasValidLocation ? alert.displayLatitude : 47.7511
        let lon = alert.hasValidLocation ? alert.displayLongitude : -120.7401
        let zoom: Double = alert.hasValidLocation ? 0.05 : 0.5

        return Map(initialPosition: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        ))) {
            if alert.hasValidLocation {
                Marker(alert.eventCategoryType, coordinate: alert.coordinate)
            }
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

    private var categoryColor: Color {
        switch alert.travelCenterPriorityId {
        case 1: return .white
        case 2: return .red
        case 3: return .orange
        default: return .yellow
        }
    }
}
