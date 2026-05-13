import SwiftUI

struct AmtrakScheduleView: View {
    @State private var selectedDay = 0
    @State private var originIndex = 0
    @State private var destIndex = 1

    @State private var trips: [[ServiceStopPair]] = []
    @State private var isLoading = false
    @State private var hasSearched = false
    @State private var errorMessage: String? = nil

    private let dayOptions: [String] = {
        let weekdays = DateFormatter().weekdaySymbols ?? []
        let today = Calendar.current.component(.weekday, from: Date()) - 1
        return Array(weekdays[today...] + weekdays[..<today])
    }()

    private var selectedDate: Date {
        Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * selectedDay))
    }

    private var stationNames: [String] { AmtrakStore.stationNames }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    Text("Find Schedules")
                        .font(.title2).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 12) {
                        PickerRow(label: "Day", selection: $selectedDay, options: dayOptions)

                        PickerRow(label: "Origin", selection: $originIndex, options: stationNames)

                        PickerRow(label: "Destination", selection: $destIndex, options: stationNames)
                    }

                    Button(action: searchSchedules) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text("Search Schedules")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color("WSDOTprimarygreen"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(isLoading || originIndex == destIndex)
                    .opacity((isLoading || originIndex == destIndex) ? 0.6 : 1)
                }
                .padding()
                .glassEffect(in: .rect(cornerRadius: 16.0))
                .shadow(color: Color.accentColor.opacity(0.1), radius: 4, x: 0, y: 2)

                if originIndex == destIndex && hasSearched {
                    Text("Please select different origin and destination stations.")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }

                if let errorMessage = errorMessage {
                    Text("Failed to load: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }

                if !trips.isEmpty {
                    VStack(spacing: 24) {
                        ForEach(Array(trips.enumerated()), id: \.offset) { tripIndex, pairs in
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Trip \(tripIndex + 1)")
                                    .font(.title3).bold()
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 4)

                                ForEach(pairs) { pair in
                                    ScheduleCard(pair: pair)
                                }
                            }
                        }
                    }
                } else if hasSearched && !isLoading && errorMessage == nil {
                    Text("No schedules found for the selected route.")
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            }
            .padding()
        }
        .navigationTitle("Schedules")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func searchSchedules() {
        guard originIndex != destIndex else { return }

        isLoading = true
        hasSearched = true
        errorMessage = nil
        trips = []

        let originId = AmtrakStore.stationIdsMap[stationNames[originIndex]] ?? ""
        let destId = AmtrakStore.stationIdsMap[stationNames[destIndex]] ?? ""

        Task {
            do {
                let result = try await AmtrakService.shared.getSchedule(
                    date: selectedDate,
                    originId: originId,
                    destId: destId
                )
                trips = result
                isLoading = false
            } catch {
                errorMessage = "Please check your connection and try again."
                print("API Error: \(error)")
                isLoading = false
            }
        }
    }
}

struct PickerRow: View {
    let label: String
    @Binding var selection: Int
    let options: [String]

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)

            Picker(label, selection: $selection) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    Text(option).tag(index)
                }
            }
            .pickerStyle(.menu)
            .tint(.primary)
        }
    }
}

struct ScheduleCard: View {
    let pair: ServiceStopPair

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "arrow.up.circle")
                            .foregroundColor(.green)
                            .font(.caption)
                        Text(pair.origin.stationName)
                            .font(.subheadline).bold()
                    }

                    Text(timeStr(pair.origin.scheduledDepartureTime))
                        .font(.title3).bold()
                        .foregroundColor(.primary)

                    if !pair.origin.departureComment.isEmpty {
                        Text(pair.origin.departureComment)
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }

                Spacer()

                if let dest = pair.destination {
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack {
                            Text(dest.stationName)
                                .font(.subheadline).bold()
                            Image(systemName: "arrow.down.circle")
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        Text(timeStr(dest.scheduledArrivalTime))
                            .font(.title3).bold()
                            .foregroundColor(.primary)

                        if !dest.arrivalComment.isEmpty {
                            Text(dest.arrivalComment)
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }

            Divider()

            HStack {
                Label(pair.origin.trainName, systemImage: "train.side.front.car")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text(timeAgo(pair.origin.updated))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
        .shadow(color: Color.accentColor.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    private func timeStr(_ date: Date?) -> String {
        guard let date = date else { return "--" }
        let f = DateFormatter()
        f.timeStyle = .short
        f.timeZone = TimeZone(abbreviation: "PDT")
        return f.string(from: date)
    }

    private func timeAgo(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        if minutes < 1 { return "Just now" }
        if minutes < 60 { return "\(minutes) min ago" }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        if hours < 24 { return "\(hours)h \(remainingMinutes)m ago" }
        return "\(hours / 24)d ago"
    }
}

#Preview {
    NavigationStack {
        AmtrakScheduleView()
    }
}
