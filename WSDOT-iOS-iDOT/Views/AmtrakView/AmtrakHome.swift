import SwiftUI

struct AmtrakHome: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AmtrakMenuCard(
                    icon: "ticket.fill",
                    title: "Buy Tickets",
                    subtitle: "Purchase tickets on Amtrak.com"
                ) {
                    if let url = URL(string: "https://www.amtrakcascades.com/buy-tickets") {
                        UIApplication.shared.open(url)
                    }
                }

                NavigationLink(destination: AmtrakScheduleView()) {
                    AmtrakMenuCard(
                        icon: "magnifyingglass",
                        title: "Check Schedules and Status",
                        subtitle: "Search train schedules and live status",
                        isLink: true
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
        .navigationTitle("Amtrak Cascades")
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
    }
}

struct AmtrakMenuCard: View {
    let icon: String
    let title: String
    let subtitle: String
    var isLink: Bool = false
    var action: (() -> Void)?

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isLink {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .wsdotCard()
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
}

#Preview {
    NavigationStack {
        AmtrakHome()
    }
}
