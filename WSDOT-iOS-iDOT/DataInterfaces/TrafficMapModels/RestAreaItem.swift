import Foundation
import CoreLocation

struct RestAreaItem: Codable, Identifiable {
    let route: String
    let location: String
    let description: String
    let milepost: Int
    let direction: String
    let latitude: String
    let longitude: String
    let notes: String?
    let hasDump: Bool
    let isOpen: Bool
    let amenities: [String]

    var id: String { "\(route)-\(milepost)-\(direction)" }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: Double(latitude) ?? 0,
            longitude: Double(longitude) ?? 0
        )
    }
}
