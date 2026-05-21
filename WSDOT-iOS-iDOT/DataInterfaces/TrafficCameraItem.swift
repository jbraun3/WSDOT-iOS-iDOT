import Foundation
import CoreLocation

struct CamerasResponse: Codable {
    let cameras: CameraContainer
}

struct CameraContainer: Codable {
    let items: [TrafficCameraItem]
}

struct TrafficCameraItem: Codable, Identifiable {
    let id: Int
    let url: String
    let title: String
    let roadName: String
    let direction: String?
    let milepost: Double
    let lat: Double
    let lon: Double
    let video: Int

    var isVideo: Bool { video == 1 }
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    var directionDisplay: String {
        guard let dir = direction else { return "" }
        switch dir {
        case "N": return "North"
        case "S": return "South"
        case "E": return "East"
        case "W": return "West"
        case "B": return "This camera moves to point in more than one direction."
        default: return dir
        }
    }
}
