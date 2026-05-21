import SwiftUI

struct TrafficMapAlerts: View {
    @State private var alerts: [HighwayAlertItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading alerts...")
                } else if let errorMessage = errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Failed to load alerts")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else if alerts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        Text("No current alerts")
                            .font(.headline)
                        Text("There are no active highway alerts right now.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(alerts) { alert in
                            NavigationLink(destination: AlertDetailView(alert: alert)) {
                                AlertRowView(alert: alert)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alerts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task { await fetchAlerts() }
        }
    }

    private func fetchAlerts() async {
        isLoading = true
        do {
            alerts = try await HighwayAlertsService.shared.getAlerts()
            isLoading = false
        } catch {
            errorMessage = "Please check your connection and try again."
            print("Alert API Error: \(error)")
            isLoading = false
        }
    }
}

struct AlertRowView: View {
    let alert: HighwayAlertItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: categoryIcon)
                    .font(.caption)
                    .foregroundColor(categoryColor)

                Text(alert.eventCategoryTypeDescription)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(categoryColor)

                Spacer()

                Text(alert.priority)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(priorityColor.opacity(0.15))
                    .clipShape(Capsule())
            }

            Text(alert.headlineDescription)
                .font(.subheadline)
                .lineLimit(2)

            HStack {
                Image(systemName: "road.lanes")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(alert.roadName)
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Spacer()

                Text(alert.timeAgo)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private var categoryIcon: String {
        switch alert.eventCategory {
        case "Construction": return "cone.fill"
        case "Maintenance": return "wrench.fill"
        case "Incident": return "car.fill"
        case "Special Event": return "star.fill"
        default: return "exclamationmark.triangle.fill"
        }
    }

    private var categoryColor: Color {
        switch alert.travelCenterPriorityId {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        default: return .accentColor
        }
    }

    private var priorityColor: Color {
        switch alert.priority.lowercased() {
        case "highest": return .red
        case "high": return .orange
        case "medium": return .yellow
        case "low": return .green
        default: return .secondary
        }
    }
}
