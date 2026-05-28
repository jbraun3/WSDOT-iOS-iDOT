import SwiftUI
import SwiftData

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

    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteItem]

    private var isFavorited: Bool {
        favorites.contains { $0.category == .borderWait && $0.itemId == String(wait.id) }
    }

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

            VStack(spacing: 6) {
                Button {
                    toggleFavorite()
                } label: {
                    Image(systemName: isFavorited ? "star.fill" : "star")
                        .font(.title3)
                        .foregroundColor(isFavorited ? Color("WSDOTprimarygreen") : .accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                Text(wait.waitTimeDisplay)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(width: 80)
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
        .shadow(color: Color.accentColor.opacity(0.1), radius: 4, x: 0, y: 2)
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

    private func toggleFavorite() {
        if let existing = favorites.first(where: { $0.category == .borderWait && $0.itemId == String(wait.id) }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(FavoriteItem(category: .borderWait, itemId: String(wait.id), title: wait.name))
        }
    }
}

#Preview {
    NavigationStack {
        BorderWaitsHome()
    }
}
