import SwiftUI

struct BridgeAlertsHome: View {
    @State private var alerts: [BridgeAlertItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    private let alwaysShownBridges = [
        "1st Avenue South Bridge",
        "Hood Canal Bridge",
        "Interstate Bridge"
    ]

    private var bridgeSections: [(String, [BridgeAlertItem])] {
        let grouped = Dictionary(grouping: alerts) { $0.bridge }
        var sections: [(String, [BridgeAlertItem])] = []

        for bridge in alwaysShownBridges {
            let bridgeAlerts = (grouped[bridge] ?? []).sorted { $0.lastUpdatedTime > $1.lastUpdatedTime }
            sections.append((bridge, bridgeAlerts))
        }

        let otherBridges = grouped.keys.filter { !alwaysShownBridges.contains($0) }.sorted()
        for bridge in otherBridges {
            if let bridgeAlerts = grouped[bridge] {
                sections.append((bridge, bridgeAlerts.sorted { $0.lastUpdatedTime > $1.lastUpdatedTime }))
            }
        }

        return sections
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Fetching bridge alerts...")
            } else if let errorMessage = errorMessage {
                Text("Failed to load: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(bridgeSections, id: \.0) { bridgeName, bridgeAlerts in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(bridgeName)
                                    .font(.title2).bold()
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 4)

                                if bridgeAlerts.isEmpty {
                                    NoAlertsCard()
                                } else {
                                    ForEach(bridgeAlerts) { alert in
                                        NavigationLink(destination: BridgeAlertDetail(alert: alert)) {
                                            BridgeAlertCardView(alert: alert)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Bridge Alerts")
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
        .task {
            await fetchData()
        }
    }

    private func fetchData() async {
        isLoading = true
        do {
            alerts = try await BridgeAlertsService.shared.getBridgeAlerts()
            isLoading = false
        } catch {
            errorMessage = "Please check your connection and try again."
            print("API Error: \(error)")
            isLoading = false
        }
    }
}

struct NoAlertsCard: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle")
                .font(.title2)
                .foregroundColor(.secondary)

            Text("No Alerts Reported")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
        .shadow(color: Color.accentColor.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct BridgeAlertCardView: View {
    let alert: BridgeAlertItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: alert.prioritySymbol)
                .font(.title2)
                .foregroundColor(alert.priorityColor)

            VStack(alignment: .leading, spacing: 6) {
                Text(alert.descriptionPlainText)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(3)

                if !alert.status.isEmpty {
                    Text(alert.status)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(alert.timeAgo)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
        .shadow(color: Color.accentColor.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        BridgeAlertsHome()
    }
}
