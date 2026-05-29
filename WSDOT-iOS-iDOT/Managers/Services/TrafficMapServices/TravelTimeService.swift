//
//  TravelTimeServices.swift
//  WSDOT-iOS-iDOT
//
//  Created by Arohee Kumar

import Foundation

class TravelTimeServices{
    static let shared = TravelTimeServices()
    
    private init() {}
    
    func getTravelTimes() async throws -> [TravelTime] {
        
        let apiKey = ApiKeys.wsdotKey
        
        let urlString =
            "https://wsdot.wa.gov/Traffic/api/TravelTimes/TravelTimesREST.svc/GetTravelTimesAsJson?AccessCode=\(apiKey)"
        let decoder = JSONDecoder()
        
        guard let url = URL(string: urlString) else{
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
        
        let decodedTravelTimes = try decoder.decode([TravelTime].self, from: data)
        
        return decodedTravelTimes
        
    }
}
