import SwiftUI
import MapKit

struct RestAreaDetailView: View {
    let restArea: RestAreaItem

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                categoryBadge

                VStack(spacing: 12) {
                    infoRow(label: "Route", value: restArea.route)
                    infoRow(label: "Direction", value: restArea.direction)
                    infoRow(label: "Milepost", value: "\(restArea.milepost)")

                    HStack {
                        Text("Status")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(width: 80, alignment: .leading)
                        Spacer()
                        Text(restArea.isOpen ? "Open" : "Closed")
                            .foregroundColor(restArea.isOpen ? .green : .red)
                            .fontWeight(.semibold)
                    }

                    HStack {
                        Text("Dump Station")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(width: 80, alignment: .leading)
                        Spacer()
                        Text(restArea.hasDump ? "Available" : "Not available")
                            .foregroundColor(restArea.hasDump ? .green : .secondary)
                    }
                }
                .padding()
                .glassEffect(in: .rect(cornerRadius: 16.0))

                if !restArea.amenities.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Amenities")
                            .font(.title2).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(restArea.amenities, id: \.self) { amenity in
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .font(.caption)
                                Text(amenity)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                    .glassEffect(in: .rect(cornerRadius: 16.0))
                }

                if let notes = restArea.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Notes")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }

                        Text(notes)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .glassEffect(in: .rect(cornerRadius: 16.0))
                }

                mapSection
            }
            .padding()
        }
        .navigationTitle("Rest Area")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var badgeColor: Color { .blue }

    private var categoryBadge: some View {
        HStack(spacing: 8) {
            Image(restArea.hasDump ? "icMapRestAreaDump" : "icMapRestArea")
                .resizable()
                .frame(width: 24, height: 24)
            Text(restArea.location)
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
        Map(initialPosition: .region(MKCoordinateRegion(
            center: restArea.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))) {
            Marker(restArea.location, coordinate: restArea.coordinate)
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
