import Foundation

struct AmtrakStation: Identifiable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
}

struct AmtrakServiceStop: Identifiable {
    let id = UUID()
    let stationId: String
    let stationName: String
    let trainNumber: Int
    let tripNumber: Int
    let sortOrder: Int
    let arrivalComment: String
    let departureComment: String
    let scheduledArrivalTime: Date?
    let scheduledDepartureTime: Date?
    let updated: Date

    var trainName: String {
        if let name = AmtrakStore.trainNumberMap[trainNumber] {
            return "\(trainNumber) \(name)"
        }
        return "\(trainNumber) Bus Service"
    }
}

struct ServiceStopPair: Identifiable {
    let id = UUID()
    let origin: AmtrakServiceStop
    let destination: AmtrakServiceStop?
}
