import Foundation

class BorderWaitsService {

    static let shared = BorderWaitsService()

    private init() {}

    func getBorderWaits() async throws -> [BorderWaitItem] {
        let urlString = "https://data.wsdot.wa.gov/mobile/BorderCrossings.json"
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

        let decoded = try decoder.decode(BorderWaitsResponse.self, from: data)
        let northbound = decoded.waitTimes.items.filter { $0.direction.lowercased() == "northbound" }
        return northbound
    }
}
