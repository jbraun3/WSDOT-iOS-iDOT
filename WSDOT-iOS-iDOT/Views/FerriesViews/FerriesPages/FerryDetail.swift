//
//  FerryDetail.swift
//  WSDOT-iOS-iDOT
//
//  Skeleton detail page for a ferry route work to fill in later with other
//  get ferry services
//

import SwiftUI

struct FerryDetail: View {
    let route: FerryRoute

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // crossing time card
                VStack(alignment: .leading, spacing: 8) {
                    Text("Approximate Crossing Time")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(route.crossingTimeDisplay)
                        .font(.title2).bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .wsdotCard()

                // flags
                if route.reservationFlag == true
                    || route.internationalFlag == true
                    || route.passengerOnlyFlag == true {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Route Info")
                            .font(.title3).bold()
                        if route.reservationFlag == true {
                            Label("Reservations available", systemImage: "calendar")
                        }
                        if route.internationalFlag == true {
                            Label("International route", systemImage: "globe")
                        }
                        if route.passengerOnlyFlag == true {
                            Label("Passenger-only", systemImage: "person.fill")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .wsdotCard()
                }

                // Notes
                if let notes = route.generalRouteNotes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.title3).bold()
                        Text(notes)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .wsdotCard()
                }

                if let seasonal = route.seasonalRouteNotes, !seasonal.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Seasonal Notes")
                            .font(.title3).bold()
                        Text(seasonal)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .wsdotCard()
                }
            }
            .padding()
        }
        .navigationTitle(route.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
        .wsdotFavorite(
            category: .ferryRoute,
            itemId: String(route.routeID),
            title: route.displayName
        )
    }
}
