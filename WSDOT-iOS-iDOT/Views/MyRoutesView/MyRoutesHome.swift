//
//  MyRoutesHome.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
//  Home page for MyRoutes
//
import SwiftUI

struct MyRoutesHome: View {
    @State private var travelTime: [TravelTime] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    

    var body: some View {
        List(travelTime) { travelTime in
            VStack(){
                Text(travelTime.name)
                Text("\(travelTime.currentTime) min")
            }
        }
        .navigationTitle("My Routes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        
        .task {
            await fetchPassData()
        }
    }
    
    // MARK: - Network Helper
    private func fetchPassData() async {
        isLoading = true
        do {
            travelTime = try await TravelTimeServices.shared.getTravelTimes()
            isLoading = false
        } catch {
            // error handling
            errorMessage = "Please check your connection and try again."
            print("API Error: \(error)")
            isLoading = false
        }
    }
}

#Preview {
    MyRoutesHome()
}
