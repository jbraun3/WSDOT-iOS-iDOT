//
//  FerriesScheduleService.swift
//  WSDOT-iOS-iDOT
//
//  For the WSDOT Ferries Schedule API:
//    https://www.wsdot.wa.gov/ferries/api/schedule/rest/help
//
//

import Foundation

class FerriesScheduleService {

    static let shared = FerriesScheduleService()
    private init() {}

    private let baseURL = "https://www.wsdot.wa.gov/ferries/api/schedule/rest"

    func getRouteDetails(for date: Date = Date()) async throws -> [FerryRoute] {
        let dateString = Self.urlDateFormatter.string(from: date)
        let urlString  = "\(baseURL)/routedetails/\(dateString)?apiaccesscode=\(ApiKeys.wsdotKey)"

        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([FerryRoute].self, from: data)
    }

    // MARK: - Date formatting

    private static let urlDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone   = TimeZone(identifier: "America/Los_Angeles")
        f.locale     = Locale(identifier: "en_US_POSIX")
        return f
    }()
}
