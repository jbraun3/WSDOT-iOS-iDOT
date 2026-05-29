//
//  FavoriteDestinationView.swift
//  WSDOT-iOS-iDOT
//


import SwiftUI
import SwiftData

struct FavoriteDestinationView: View {
    let item: FavoriteItem

    var body: some View {
        switch item.category {
        case .mountainPass:
            MountainPassFavoriteLoader(passId: Int(item.itemId) ?? -1)
        case .trafficCamera:
            TrafficCameraFavoriteLoader(cameraId: Int(item.itemId) ?? -1)
        case .tollRate:
            if let route = TollRoute.allCases.first(where: { $0.displayName == item.itemId }) {
                TollRateDetail(route: route)
            } else {
                FavoriteUnavailableView(title: item.title, message: "Toll route not found.")
            }
        case .route:
            SavedRouteFavoriteLoader(uuidString: item.itemId)
        case .travelTime:
            TravelTimeFavoriteLoader(travelTimeId: Int(item.itemId) ?? -1)
        case .borderWait:
            FavoriteUnavailableView(title: item.title, message: "Border wait details aren't available yet.")
        case .ferryRoute:
            FerryRouteFavoriteLoader(routeId: Int(item.itemId) ?? -1)
        }
    }
}

// MARK: - Loaders for categories whose detail view needs an async fetch
// fetches all mountain passes and searches for correct one, so if it ever gets slow we can change it

private struct MountainPassFavoriteLoader: View {
    let passId: Int
    @State private var pass: MountainPass?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let pass = pass {
                MountainPassesDetail(pass: pass)
            } else if let errorMessage = errorMessage {
                FavoriteUnavailableView(title: "Mountain Pass", message: errorMessage)
            } else {
                ProgressView("Loading pass…")
            }
        }
        .task {
            do {
                let all = try await MountainPassesService.shared.getMountainPasses()
                if let match = all.first(where: { $0.id == passId }) {
                    pass = match
                } else {
                    errorMessage = "Pass not found."
                }
            } catch {
                errorMessage = "Couldn't load. Check your connection."
            }
        }
    }
}

private struct TrafficCameraFavoriteLoader: View {
    let cameraId: Int
    @State private var camera: TrafficCameraItem?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let camera = camera {
                CameraDetailView(camera: camera)
            } else if let errorMessage = errorMessage {
                FavoriteUnavailableView(title: "Camera", message: errorMessage)
            } else {
                ProgressView("Loading camera…")
            }
        }
        .task {
            do {
                let all = try await TrafficCameraService.shared.getCameras()
                if let match = all.first(where: { $0.id == cameraId }) {
                    camera = match
                } else {
                    errorMessage = "Camera not found."
                }
            } catch {
                errorMessage = "Couldn't load. Check your connection."
            }
        }
    }
}

private struct TravelTimeFavoriteLoader: View {
    let travelTimeId: Int
    @State private var travelTime: TravelTime?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let travelTime = travelTime {
                TravelTimeDetailView(travelTime: travelTime)
            } else if let errorMessage = errorMessage {
                FavoriteUnavailableView(title: "Travel Time", message: errorMessage)
            } else {
                ProgressView("Loading travel time…")
            }
        }
        .task {
            do {
                let all = try await TravelTimeServices.shared.getTravelTimes()
                if let match = all.first(where: { $0.id == travelTimeId }) {
                    travelTime = match
                } else {
                    errorMessage = "Travel time not found."
                }
            } catch {
                errorMessage = "Couldn't load. Check your connection."
            }
        }
    }
}

private struct FerryRouteFavoriteLoader: View {
    let routeId: Int
    @State private var route: FerryRoute?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let route = route {
                FerryDetail(route: route)
            } else if let errorMessage = errorMessage {
                FavoriteUnavailableView(title: "Ferry Route", message: errorMessage)
            } else {
                ProgressView("Loading ferry route…")
            }
        }
        .task {
            do {
                let all = try await FerriesScheduleService.shared.getRouteDetails()
                if let match = all.first(where: { $0.routeID == routeId }) {
                    route = match
                } else {
                    errorMessage = "Ferry route not found."
                }
            } catch {
                errorMessage = "Couldn't load. Check your connection."
            }
        }
    }
}

private struct SavedRouteFavoriteLoader: View {
    let uuidString: String
    @Query private var routes: [SavedRoute]

    var body: some View {
        if let route = routes.first(where: { $0.id.uuidString == uuidString }) {
            RouteDetailView(route: route)
        } else {
            FavoriteUnavailableView(title: "Route", message: "Route not found.")
        }
    }
}

// MARK: - Fallback view for categories without a detail view yet

private struct FavoriteUnavailableView: View {
    let title: String
    var message: String = "Detail view isn't available for this favorite."

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
    }
}
