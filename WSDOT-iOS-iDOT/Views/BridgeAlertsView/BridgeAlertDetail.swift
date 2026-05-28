import SwiftUI

struct BridgeAlertDetail: View {
    let alert: BridgeAlertItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(alert.bridge)
                    .font(.largeTitle).bold()

                HStack(spacing: 12) {
                    Image(systemName: alert.prioritySymbol)
                        .font(.title2)
                        .foregroundColor(alert.priorityColor)

                    VStack(alignment: .leading, spacing: 4) {
                        if !alert.roadName.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: "road.lanes")
                                    .font(.caption)
                                Text(alert.roadName)
                                    .font(.subheadline)
                            }
                        }
                        if !alert.direction.isEmpty {
                            Text(alert.direction)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.title2).bold()

                    if let attrStr = AttributedString(html: alert.descText) {
                        Text(attrStr)
                            .font(.body)
                            .lineSpacing(4)
                            .foregroundColor(.white)
                    } else {
                        Text(alert.descText)
                            .font(.body)
                            .lineSpacing(4)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .wsdotCard()

                if !alert.status.isEmpty || alert.duration > 0 {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Details")
                            .font(.title2).bold()

                        if !alert.status.isEmpty {
                            Label(alert.status, systemImage: "info.circle")
                        }
                        if alert.duration > 0 {
                            Label("\(alert.duration) min", systemImage: "clock")
                        }
                    }
                    .padding()
                    .wsdotCard()
                }

                if !alert.openingTime.isEmpty {
                    Label("Opens: \(alert.openingTime)", systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text("Last updated: \(alert.timeAgo)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Alert")
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
    }
}

#Preview {
    NavigationStack {
        BridgeAlertDetail(alert: BridgeAlertItem(
            alertId: 1,
            descText: "Bridge opening scheduled for maintenance.",
            status: "Active",
            duration: 30,
            travelCenterPriorityId: 3,
            location: BridgeLocation(
                description: "Hood Canal Bridge",
                latitude: 47.8593,
                longitude: -122.6248,
                milepost: 12.5,
                direction: "Both Directions",
                roadName: "SR-104"
            ),
            openingTime: "2026-05-12T22:00:00",
            lastUpdatedTime: "/Date(1778532051473)/"
        ))
    }
}
