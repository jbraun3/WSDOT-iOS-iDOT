import SwiftUI

struct BorderWaitsHome: View {
    @State private var waits: [BorderWaitItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Fetching border wait times...")
            } else if let errorMessage = errorMessage {
                Text("Failed to load: \(errorMessage)")
                    .foregroundColor(.red)
            } else if waits.isEmpty {
                Text("No border crossing data available")
                    .foregroundColor(.secondary)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(waits) { wait in
                            BorderWaitCardView(wait: wait)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Border Waits")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task {
            await fetchData()
        }
    }

    private func fetchData() async {
        isLoading = true
        do {
            waits = try await BorderWaitsService.shared.getBorderWaits()
            isLoading = false
        } catch {
            errorMessage = "Please check your connection and try again."
            print("API Error: \(error)")
            isLoading = false
        }
    }
}

struct BorderWaitCardView: View {
    let wait: BorderWaitItem

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(wait.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(wait.lane)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 6) {
                    Image(systemName: routeIcon)
                        .font(.caption)
                    Text(wait.routeDisplay)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(wait.waitTimeDisplay)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.accentColor)

                Text(wait.timeAgo)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
        .shadow(color: Color.accentColor.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    private var routeIcon: String {
        switch wait.route {
        case 5: return "road.lanes"
        case 9: return "road.lanes"
        case 97: return "road.lanes"
        case 539: return "road.lanes"
        case 543: return "road.lanes"
        default: return "questionmark.diamond"
        }
    }
}

#Preview {
    NavigationStack {
        BorderWaitsHome()
    }
}
