import SwiftUI

enum TollRoute: CaseIterable {
    case sr16, sr99, sr167, sr509, sr520, i405

    var displayName: String {
        switch self {
        case .sr16: return "SR 16"
        case .sr99: return "SR 99"
        case .sr167: return "SR 167"
        case .sr509: return "SR 509"
        case .sr520: return "SR 520"
        case .i405: return "I-405"
        }
    }

    var fullName: String {
        switch self {
        case .sr16: return "SR 16 Tacoma Narrows Bridge"
        case .sr99: return "SR 99 Tunnel"
        case .sr167: return "SR 167 Express Toll Lanes"
        case .sr509: return "SR 509 Expressway"
        case .sr520: return "SR 520 Bridge"
        case .i405: return "I-405 Express Toll Lanes"
        }
    }

    var isDynamic: Bool {
        switch self {
        case .sr167, .i405: return true
        default: return false
        }
    }

    var staticIds: [Int] {
        switch self {
        case .sr16: return [1]
        case .sr99: return [2]
        case .sr509: return [3, 4]
        case .sr520: return [5]
        default: return []
        }
    }

    var hasDirection: Bool {
        self == .sr509
    }

    var dynamicStateRoute: String {
        switch self {
        case .sr167: return "167"
        case .i405: return "405"
        default: return ""
        }
    }

    var infoURL: String {
        switch self {
        case .sr16: return "https://wsdot.wa.gov/travel/roads-bridges/toll-roads-bridges-tunnels/tacoma-narrows-bridge-tolling"
        case .sr99: return "https://wsdot.wa.gov/travel/roads-bridges/toll-roads-bridges-tunnels/sr-99-tunnel-tolling"
        case .sr167: return "https://wsdot.wa.gov/travel/roads-bridges/toll-roads-bridges-tunnels/sr-167-express-toll-lanes"
        case .sr509: return "https://wsdot.wa.gov/travel/roads-bridges/toll-roads-bridges-tunnels/sr-509-expressway"
        case .sr520: return "https://wsdot.wa.gov/travel/roads-bridges/toll-roads-bridges-tunnels/sr-520-bridge-tolling"
        case .i405: return "https://www.wsdot.wa.gov/Tolling/405/rates.htm"
        }
    }
}

struct TollRateDetail: View {
    let route: TollRoute

    @State private var staticItems: [StaticTollRateItem] = []
    @State private var dynamicSigns: [DynamicTollSign] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedDirection = 0

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading toll rates...")
            } else if let errorMessage = errorMessage {
                Text("Failed to load: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                content
            }
        }
        .navigationTitle(route.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .wsdotFavorite(category: .tollRate, itemId: route.displayName, title: route.fullName)
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
        .task { await fetchData() }
    }

    @ViewBuilder
    private var content: some View {
        if route.isDynamic {
            dynamicContent
        } else {
            staticContent
        }
    }

    // MARK: - Static Content

    private var staticContent: some View {
        let displayItems: [StaticTollRateItem]
        if route.hasDirection {
            displayItems = staticItems.filter { $0.travelDirection == (selectedDirection == 0 ? "N" : "S") }
        } else {
            displayItems = staticItems
        }

        return ScrollView {
            VStack(spacing: 16) {
                if route.hasDirection {
                    Picker("Direction", selection: $selectedDirection) {
                        Text("Northbound").tag(0)
                        Text("Southbound").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }

                if let item = displayItems.first {
                    if !item.message.isEmpty {
                        Text(item.message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }

                    TollRateTableView(
                        rows: item.tollTable,
                        numCol: item.numCol
                    )
                }
            }
            .padding(.vertical)
        }
    }

    // MARK: - Dynamic Content

    private var dynamicContent: some View {
        let northbound = dynamicSigns.filter { $0.travelDirection == "N" }
        let southbound = dynamicSigns.filter { $0.travelDirection == "S" }
        let displayed = selectedDirection == 0 ? northbound : southbound

        return ScrollView {
            VStack(spacing: 12) {
                Picker("Direction", selection: $selectedDirection) {
                    Text("Northbound").tag(0)
                    Text("Southbound").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if displayed.isEmpty {
                    Text("No toll rate data available")
                        .foregroundColor(.secondary)
                        .padding(.top, 40)
                }

                ForEach(displayed) { sign in
                    DynamicSignCard(sign: sign)
                }
            }
            .padding(.vertical)
        }
    }

    // MARK: - Data Fetching

    private func fetchData() async {
        isLoading = true
        do {
            if route.isDynamic {
                let allSigns = try await TollService.shared.getDynamicTollRates()
                let routeInt = Int(route.dynamicStateRoute) ?? 0
                dynamicSigns = allSigns.filter { $0.stateRoute == routeInt }
            } else {
                staticItems = try await TollService.shared.getStaticTollRates()
                    .filter { route.staticIds.contains($0.id) }
            }
            isLoading = false
        } catch {
            errorMessage = "Please check your connection and try again."
            print("Toll API Error: \(error)")
            isLoading = false
        }
    }
}

// MARK: - Static Table View

struct TollRateTableView: View {
    let rows: [TollRateRow]
    let numCol: Int

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                if row.header {
                    headerRow(row)
                } else {
                    dataRow(row)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private func headerRow(_ row: TollRateRow) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(row.rows.enumerated()), id: \.offset) { _, text in
                Text(text)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
            }
        }
        .background(Color(.systemGray6))
    }

    private func dataRow(_ row: TollRateRow) -> some View {
        let isActive = isRowActive(row)
        return HStack(spacing: 0) {
            ForEach(Array(row.rows.enumerated()), id: \.offset) { index, text in
                Text(text)
                    .font(index == 0 ? .subheadline : .subheadline)
                    .fontWeight(index == 0 ? .medium : .regular)
                    .foregroundColor(isActive ? .white : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
        }
        .background(isActive ? Color.accentColor : Color(.systemBackground))
    }

    private func isRowActive(_ row: TollRateRow) -> Bool {
        guard let start = row.startTime, let end = row.endTime else { return false }
        guard TollService.isTollActive(startHour: start, endHour: end) else { return false }
        let now = Date()
        let isTodayWeekend = now.isWeekend
        if let rowWeekday = row.weekday {
            return isTodayWeekend != rowWeekday
        }
        return false
    }
}

// MARK: - Dynamic Sign Card

struct DynamicSignCard: View {
    let sign: DynamicTollSign

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(sign.startLocationName)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)

            Divider()
                .padding(.horizontal, 16)

            ForEach(Array(sign.trips.enumerated()), id: \.offset) { _, trip in
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("to \(trip.endLocationName)")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }

                        Spacer()

                        Text(trip.tollDisplay)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.accentColor)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if trip.tripName != sign.trips.last?.tripName {
                        Divider()
                            .padding(.leading, 16)
                    }
                }
            }
        }
        .glassEffect(in: .rect(cornerRadius: 16.0))
        .shadow(color: Color.accentColor.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

// MARK: - Date Extension (from TollRateTableStore)

extension Date {
    var isWeekend: Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 1 || components.weekday == 7
    }
}

#Preview {
    NavigationStack {
        TollRateDetail(route: .sr16)
    }
}
