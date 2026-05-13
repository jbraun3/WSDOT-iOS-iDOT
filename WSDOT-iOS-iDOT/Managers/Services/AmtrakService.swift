import Foundation

class AmtrakService {

    static let shared = AmtrakService()

    private init() {}

    func getSchedule(date: Date, originId: String, destId: String) async throws -> [[ServiceStopPair]] {
        let dateStr = formatDate(date).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? formatDate(date)
        let urlString = "https://www.wsdot.wa.gov/traffic/api/amtrak/Schedulerest.svc/GetScheduleAsJson?AccessCode=\(ApiKeys.wsdotKey)&StatusDate=\(dateStr)&TrainNumber=-1&FromLocation=\(originId)&ToLocation=\(destId)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []
        let stops = parseServiceStops(json)
        return buildPairs(stops)
    }

    private func parseServiceStops(_ json: [[String: Any]]) -> [[AmtrakServiceStop]] {
        var trips = [[AmtrakServiceStop]]()
        var currentTripNum = -1
        var currentTripIndex = -1

        for item in json {
            let tripNum = item["TripNumber"] as? Int ?? -1
            if currentTripNum != tripNum {
                trips.append([])
                currentTripNum = tripNum
                currentTripIndex += 1
            }

            let stationId = item["StationName"] as? String ?? ""
            let stationName = item["StationFullName"] as? String ?? ""
            let trainNumber = item["TrainNumber"] as? Int ?? -1
            let sortOrder = item["SortOrder"] as? Int ?? -1

            let arrivalCommentRaw = item["ArrivalComment"] as? String
            let departureCommentRaw = item["DepartureComment"] as? String

            var scheduledDepartureTime: Date? = nil
            var scheduledArrivalTime: Date? = nil

            if let depStr = item["ScheduledDepartureTime"] as? String {
                scheduledDepartureTime = parseDotNetDate(depStr)
            }
            if let arrStr = item["ScheduledArrivalTime"] as? String {
                scheduledArrivalTime = parseDotNetDate(arrStr)
            }

            if scheduledDepartureTime == nil {
                scheduledDepartureTime = scheduledArrivalTime
            }
            if scheduledArrivalTime == nil {
                scheduledArrivalTime = scheduledDepartureTime
            }

            let arrivalComment = processComment(arrivalCommentRaw, baseDate: scheduledArrivalTime)
            let departureComment = processComment(departureCommentRaw, baseDate: scheduledDepartureTime)

            var updated = Date(timeIntervalSince1970: 0)
            if let updatedStr = item["UpdateTime"] as? String {
                updated = parseDotNetDate(updatedStr) ?? Date(timeIntervalSince1970: 0)
            }

            let stop = AmtrakServiceStop(
                stationId: stationId,
                stationName: stationName,
                trainNumber: trainNumber,
                tripNumber: tripNum,
                sortOrder: sortOrder,
                arrivalComment: arrivalComment,
                departureComment: departureComment,
                scheduledArrivalTime: scheduledArrivalTime,
                scheduledDepartureTime: scheduledDepartureTime,
                updated: updated
            )

            trips[currentTripIndex].append(stop)
        }

        return trips
    }

    private func processComment(_ comment: String?, baseDate: Date?) -> String {
        guard let comment = comment, !comment.isEmpty else { return "" }
        let lower = comment.lowercased()

        if lower.contains("late") || lower.contains("early") {
            let mins = getMinsFromString(comment)
            guard let base = baseDate else { return "Estimated \(lower)" }

            let direction: TimeInterval = lower.contains("early") ? -1 : 1
            let estimatedDate = base.addingTimeInterval(mins * 60 * direction)
            let timeStr = formatTimeOfDay(estimatedDate)
            return "Estimated \(lower) at \(timeStr)"
        }

        return "Estimated \(lower)"
    }

    private func buildPairs(_ tripStops: [[AmtrakServiceStop]]) -> [[ServiceStopPair]] {
        var allPairs: [[ServiceStopPair]] = []

        for stops in tripStops {
            var pairs: [ServiceStopPair] = []
            var serviceIndex = 0

            for stop in stops {
                if stops.count == 1 {
                    pairs.append(ServiceStopPair(origin: stop, destination: nil))
                } else if serviceIndex + 1 < stops.count {
                    if stop.stationId != stops[serviceIndex + 1].stationId {
                        pairs.append(ServiceStopPair(origin: stop, destination: stops[serviceIndex + 1]))
                    }
                }
                serviceIndex += 1
            }

            allPairs.append(pairs)
        }

        return allPairs
    }

    private func parseDotNetDate(_ dateString: String) -> Date? {
        let pattern = #"\/Date\((\d+)([+-]\d{4})?\)\/"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: dateString, range: NSRange(dateString.startIndex..., in: dateString)) else {
            return nil
        }
        let msRange = match.range(at: 1)
        let msString = (dateString as NSString).substring(with: msRange)
        guard let ms = Double(msString) else { return nil }
        return Date(timeIntervalSince1970: ms / 1000)
    }

    private func getMinsFromString(_ string: String) -> Double {
        let parts = string.split(separator: " ").map(String.init)
        var mins = 0.0
        for i in 0..<parts.count {
            if let num = Double(parts[i]) {
                if i + 1 < parts.count {
                    if parts[i + 1].uppercased() == "HR" || parts[i + 1].uppercased() == "HOUR" || parts[i + 1].uppercased() == "HOURS" {
                        mins += num * 60
                    } else if parts[i + 1].uppercased() == "MIN" || parts[i + 1].uppercased() == "MINUTE" || parts[i + 1].uppercased() == "MINUTES" {
                        mins += num
                    }
                }
            }
        }
        return mins
    }

    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MM/dd/yyyy"
        f.timeZone = TimeZone(abbreviation: "PDT")
        return f.string(from: date)
    }

    private func formatTimeOfDay(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        f.timeZone = TimeZone(abbreviation: "PDT")
        return f.string(from: date)
    }
}

struct AmtrakStore {
    static let stations: [AmtrakStation] = [
        AmtrakStation(id: "VAC", name: "Vancouver, CANADA", latitude: 49.2737293, longitude: -123.0979175),
        AmtrakStation(id: "BEL", name: "Bellingham, WA", latitude: 48.720423, longitude: -122.5109386),
        AmtrakStation(id: "MVW", name: "Mount Vernon, WA", latitude: 48.4185923, longitude: -122.334973),
        AmtrakStation(id: "STW", name: "Stanwood, WA", latitude: 48.2417732, longitude: -122.3495322),
        AmtrakStation(id: "EVR", name: "Everett, WA", latitude: 47.975512, longitude: -122.197854),
        AmtrakStation(id: "EDM", name: "Edmonds, WA", latitude: 47.8111305, longitude: -122.3841639),
        AmtrakStation(id: "SEA", name: "Seattle, WA", latitude: 47.6001899, longitude: -122.3314322),
        AmtrakStation(id: "TUK", name: "Tukwila, WA", latitude: 47.461079, longitude: -122.242693),
        AmtrakStation(id: "TAC", name: "Tacoma, WA", latitude: 47.2419939, longitude: -122.4205623),
        AmtrakStation(id: "OLW", name: "Olympia/Lacey, WA", latitude: 46.9913576, longitude: -122.793982),
        AmtrakStation(id: "CTL", name: "Centralia, WA", latitude: 46.7177596, longitude: -122.9528291),
        AmtrakStation(id: "KEL", name: "Kelso/Longview, WA", latitude: 46.1422504, longitude: -122.9132438),
        AmtrakStation(id: "VAN", name: "Vancouver, USA", latitude: 45.6294472, longitude: -122.685568),
        AmtrakStation(id: "PDX", name: "Portland, OR", latitude: 45.528639, longitude: -122.676284),
        AmtrakStation(id: "ORC", name: "Oregon City, OR", latitude: 45.3659422, longitude: -122.5960671),
        AmtrakStation(id: "SLM", name: "Salem, OR", latitude: 44.9323665, longitude: -123.0281591),
        AmtrakStation(id: "ALY", name: "Albany, OR", latitude: 44.6300975, longitude: -123.1041787),
        AmtrakStation(id: "EUG", name: "Eugene, OR", latitude: 44.055506, longitude: -123.094523),
    ].sorted { $0.name < $1.name }

    static let stationIdsMap: [String: String] = [
        "Vancouver, CANADA": "VAC",
        "Bellingham, WA": "BEL",
        "Mount Vernon, WA": "MVW",
        "Stanwood, WA": "STW",
        "Everett, WA": "EVR",
        "Edmonds, WA": "EDM",
        "Seattle, WA": "SEA",
        "Tukwila, WA": "TUK",
        "Tacoma, WA": "TAC",
        "Olympia/Lacey, WA": "OLW",
        "Centralia, WA": "CTL",
        "Kelso/Longview, WA": "KEL",
        "Vancouver, USA": "VAN",
        "Portland, OR": "PDX",
        "Oregon City, OR": "ORC",
        "Salem, OR": "SLM",
        "Albany, OR": "ALY",
        "Eugene, OR": "EUG"
    ]

    static let trainNumberMap: [Int: String] = [
        7: "Empire Builder Train",
        8: "Empire Builder Train",
        11: "Coast Starlight Train",
        14: "Coast Starlight Train",
        27: "Empire Builder Train",
        28: "Empire Builder Train",
        500: "Amtrak Cascades Train",
        501: "Amtrak Cascades Train",
        502: "Amtrak Cascades Train",
        503: "Amtrak Cascades Train",
        504: "Amtrak Cascades Train",
        505: "Amtrak Cascades Train",
        506: "Amtrak Cascades Train",
        507: "Amtrak Cascades Train",
        508: "Amtrak Cascades Train",
        509: "Amtrak Cascades Train",
        510: "Amtrak Cascades Train",
        511: "Amtrak Cascades Train",
        512: "Amtrak Cascades Train",
        513: "Amtrak Cascades Train",
        516: "Amtrak Cascades Train",
        517: "Amtrak Cascades Train",
        518: "Amtrak Cascades Train",
        519: "Amtrak Cascades Train"
    ]

    static var stationNames: [String] {
        stations.map { $0.name }
    }
}
