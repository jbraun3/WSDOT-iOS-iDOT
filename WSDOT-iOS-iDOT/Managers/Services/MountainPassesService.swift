import Foundation

class MountainPassesService {
    
    static let shared = MountainPassesService()
    
    private init() {}
    
    func getMountainPasses() async throws -> [MountainPass] {
        
        let apiKey = ApiKeys.wsdotKey
        let urlString = "https://www.wsdot.wa.gov/Traffic/api/MountainPassConditions/MountainPassConditionsREST.svc/GetMountainPassConditionsAsJson?AccessCode=\(apiKey)"
        let decoder = JSONDecoder()
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // ignore local cache
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedPasses = try decoder.decode([MountainPass].self, from: data)
        
        return decodedPasses
    }
}
