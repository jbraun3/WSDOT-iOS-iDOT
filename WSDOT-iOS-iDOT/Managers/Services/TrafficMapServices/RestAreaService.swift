import Foundation

class RestAreaService {
    static let shared = RestAreaService()

    private init() {}

    func getRestAreas() -> [RestAreaItem] {
        guard let url = Bundle.main.url(forResource: "restareas", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let areas = try? JSONDecoder().decode([RestAreaItem].self, from: data)
        else {
            return []
        }
        return areas
    }
}
