import SwiftUI

struct TollRatesHome: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(TollRoute.allCases, id: \.self) { route in
                    NavigationLink(destination: TollRateDetail(route: route)) {
                        TollRouteCard(route: route)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle("Toll Rates")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("My Good To Go") {
                    if let url = URL(string: "https://mygoodtogo.com") {
                        UIApplication.shared.open(url)
                    }
                }
                .foregroundColor(.white)
                .font(.caption)
            }
        }
    }
}

struct TollRouteCard: View {
    let route: TollRoute

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(route.fullName)
                    .font(.headline)
                    .foregroundColor(.primary)
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

    private var iconName: String {
        switch route {
        case .sr16: return "road.lanes"
        case .sr99: return "tunnel"
        case .sr167: return "arrow.triangle.swap"
        case .sr509: return "road.lanes"
        case .sr520: return "bridge"
        case .i405: return "arrow.triangle.swap"
        }
    }
}

#Preview {
    NavigationStack {
        TollRatesHome()
    }
}
