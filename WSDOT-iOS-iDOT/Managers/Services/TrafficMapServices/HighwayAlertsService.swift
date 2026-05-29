import Foundation

class HighwayAlertsService {

    static let shared = HighwayAlertsService()

    private init() {}

    func getAlerts() async throws -> [HighwayAlertItem] {
        let urlString = "https://data.wsdot.wa.gov/mobile/HighwayAlerts.json"
        let decoder = JSONDecoder()

        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try decoder.decode(HighwayAlertsResponse.self, from: data)
        return decoded.alerts.items
    }
}
