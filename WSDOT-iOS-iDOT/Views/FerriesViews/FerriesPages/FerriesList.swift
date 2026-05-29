//
//  FerriesList.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
import SwiftUI

struct FerriesList: View {
    @State private var routes: [FerryRoute] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading ferry routes…")
            } else if let errorMessage {
                Text("Failed to load: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if routes.isEmpty {
                Text("No ferry routes available")
                    .foregroundColor(.secondary)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(routes) { route in
                            NavigationLink {
                                FerryDetail(route: route)
                            } label: {
                                FerryRouteRow(route: route)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .task { await fetchRoutes() }
    }

    private func fetchRoutes() async {
        isLoading = true
        do {
            routes = try await FerriesScheduleService.shared.getRouteDetails()
            isLoading = false
        } catch {
            errorMessage = "Please check your connection and try again."
            print("Ferries API Error: \(error)")
            isLoading = false
        }
    }
}

private struct FerryRouteRow: View {
    let route: FerryRoute

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "ferry.fill")
                .font(.title2)
                .foregroundStyle(WSDOTStyle.primaryGreen)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(route.displayName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(route.crossingTimeDisplay)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .wsdotCard()
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        FerriesList()
    }
}
