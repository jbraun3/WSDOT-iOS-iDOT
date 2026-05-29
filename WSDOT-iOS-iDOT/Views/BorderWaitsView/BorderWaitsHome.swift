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
        .wsdotToolbar()
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
        HStack {
            Image(routeIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 4) {
                Text(wait.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(wait.lane)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(wait.routeDisplay)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(wait.waitTimeDisplay)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.accentColor)
                .frame(width: 80, alignment: .trailing)
        }
        .padding()
        .wsdotCard()
    }

    private var routeIcon: String {
        switch wait.route {
        case 5: return "icListI5"
        case 9: return "icListSR9"
        case 97: return "icListUS97"
        case 539: return "icListSR539"
        case 543: return "icListSR543"
        default: return "icListI5"
        }
    }
}

#Preview {
    NavigationStack {
        BorderWaitsHome()
    }
}
