import Foundation

class TollService {

    static let shared = TollService()

    private init() {}

    private let staticURL = "https://data.wsdot.wa.gov/mobile/StaticTollRates.json"
    private let dynamicURL = "https://wsdot.wa.gov/traffic/api/TollRates/TollRatesREST.svc/GetTollRatesAsJson"

    // MARK: - Static Toll Rates

    func getStaticTollRates() async throws -> [StaticTollRateItem] {
        let decoder = JSONDecoder()
        guard let url = URL(string: staticURL) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try decoder.decode(StaticTollRatesResponse.self, from: data)
        return decoded.tollRates
    }

    // MARK: - Dynamic Toll Rates

    func getDynamicTollRates() async throws -> [DynamicTollSign] {
        let decoder = JSONDecoder()
        let urlString = dynamicURL + "?AccessCode=" + ApiKeys.wsdotKey
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let items = try decoder.decode([DynamicTollRateItem].self, from: data)
        let filtered = items.filter { !shouldSkipTrip($0) }
        return groupIntoSigned(filtered)
    }

    // MARK: - Skip Logic

    private func shouldSkipTrip(_ item: DynamicTollRateItem) -> Bool {
        if item.startLocationName == "NE 6th" && item.travelDirection == "N" { return true }
        if item.startLocationName == "216th ST SE" && item.travelDirection == "S" { return true }
        if item.startLocationName == "NE 145th" && item.travelDirection == "S" { return true }
        if item.startLocationName == "NE 108th" && item.travelDirection == "S" { return true }
        if item.startLocationName == "James St" && item.travelDirection == "N" { return true }
        if item.startLocationName == "S 204th St" && item.travelDirection == "N" { return true }
        if item.startLocationName == "1st Ave S" && item.travelDirection == "S" { return true }
        if item.startLocationName == "12th St NW" && item.travelDirection == "S" { return true }
        if item.startLocationName == "37th St NW" && item.travelDirection == "S" { return true }
        if item.startLocationName == "Green River" && item.travelDirection == "S" { return true }
        if item.startLocationName == "S 23rd St" && item.travelDirection == "S" { return true }
        if item.startLocationName == "S 192nd St" && item.travelDirection == "S" { return true }
        if item.startLocationName == "4th Ave N" && item.travelDirection == "S" { return true }
        if item.startLocationName == "15th St SW" && item.travelDirection == "N" { return true }
        if item.startLocationName == "30th St NW" && item.travelDirection == "N" { return true }
        if item.startLocationName == "S 265th St" && item.travelDirection == "N" { return true }
        if item.startLocationName == "7th St NW" && item.travelDirection == "N" { return true }
        return false
    }

    // MARK: - Grouping

    private func groupIntoSigned(_ items: [DynamicTollRateItem]) -> [DynamicTollSign] {
        var signsDict: [String: DynamicTollSign] = [:]

        for item in items {
            let key = "\(item.startLocationName)-\(item.travelDirection)"
            let trip = DynamicTollTrip(
                tripName: item.tripName,
                endLocationName: item.endLocationName,
                toll: item.currentToll / 100.0,
                endMilepost: item.endMilepost,
                message: item.currentMessage,
                endLatitude: item.endLatitude,
                endLongitude: item.endLongitude
            )

            if var existing = signsDict[key] {
                existing.trips.append(trip)
                signsDict[key] = existing
            } else {
                let sign = DynamicTollSign(
                    startLocationName: item.startLocationName,
                    travelDirection: item.travelDirection,
                    stateRoute: item.stateRoute,
                    milepost: item.startMilepost,
                    startLatitude: item.startLatitude,
                    startLongitude: item.startLongitude,
                    trips: [trip]
                )
                signsDict[key] = sign
            }
        }

        var signs = Array(signsDict.values)

        for i in signs.indices {
            if signs[i].travelDirection == "N" {
                signs[i].trips.sort { $0.endMilepost < $1.endMilepost }
            } else {
                signs[i].trips.sort { $0.endMilepost > $1.endMilepost }
            }
        }

        signs.sort { a, b in
            if a.startLocationName != b.startLocationName {
                return a.startLocationName < b.startLocationName
            }
            return a.travelDirection < b.travelDirection
        }

        return signs
    }

    // MARK: - Time Check

    static func isTollActive(startHour: String, endHour: String) -> Bool {
        let startParts = startHour.split(separator: ":")
        let endParts = endHour.split(separator: ":")
        guard startParts.count == 2, endParts.count == 2,
              let startH = Int(startParts[0]), let startM = Int(startParts[1]),
              let endH = Int(endParts[0]), let endM = Int(endParts[1]) else {
            return false
        }

        let calendar = Calendar.current
        let now = Date()

        guard let tollStart = calendar.date(bySettingHour: startH, minute: startM, second: 0, of: now),
              let tollEnd = calendar.date(bySettingHour: endH, minute: endM, second: 0, of: now) else {
            return false
        }

        return now >= tollStart && now <= tollEnd
    }
}
