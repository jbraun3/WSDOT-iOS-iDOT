import SwiftUI
import MapKit

struct TravelTimeGroup: Identifiable {
    let id: String
    var times: [TravelTime]
    var center: CLLocationCoordinate2D
    var label: String { times.first?.startPoint.description ?? "Travel Times" }
}

struct TravelTimeListView: View {
    let group: TravelTimeGroup

    var body: some View {
        let filteredTimes = group.times.filter { !$0.name.localizedCaseInsensitiveContains("HOV") && !$0.description.localizedCaseInsensitiveContains("HOV") }
        List {
            ForEach(filteredTimes) { time in
                NavigationLink(destination: TravelTimeDetailView(travelTime: time)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(time.description.replacingOccurrences(of: "Downtown ", with: ""))
                            .font(.headline)
                        HStack {
                            Label("\(time.currentTime) min", systemImage: "clock")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Label("\(String(format: "%.1f", time.dist)) mi", systemImage: "arrow.left.and.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(group.label)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
