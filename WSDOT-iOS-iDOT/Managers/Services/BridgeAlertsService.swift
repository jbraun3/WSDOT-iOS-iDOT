import Foundation

class BridgeAlertsService {

    static let shared = BridgeAlertsService()

    private init() {}

    func getBridgeAlerts() async throws -> [BridgeAlertItem] {
        let urlString = "https://data.wsdot.wa.gov/mobile/BridgeOpenings.json"
        let decoder = JSONDecoder()

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

        let alerts = try decoder.decode([BridgeAlertItem].self, from: data)
        return alerts
    }
}
