//
//  MountainPassesHome.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
import SwiftUI

struct MountainPassesHome: View {
    // 1. Our State Variables
    @State private var passes: [MountainPass] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    var body: some View {
        // VStack with spacing: 0 keeps the banner flush against the scroll list
        VStack(spacing: 0) {
            
            // 2. The Fixed Banner
            HStack {
                Image(systemName: "mountain.2.fill")
                    .font(.title)
                Text("Mountain Passes")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.wsdoTprimarygreen) // You can change this to a custom WSDOT color later
            
            // 3. The Scrollable Content Area
            if isLoading {
                // Show a spinner while the network call is happening
                Spacer()
                ProgressView("Fetching live conditions...")
                Spacer()
            } else if let errorMessage = errorMessage {
                // Show an error if the network call fails
                Spacer()
                Text("Failed to load: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
                Spacer()
            } else {
                // 4. The Scrollable List of Cards
                ScrollView {
                    // LazyVStack only renders cards when they scroll onto the screen (great for performance)
                    LazyVStack(spacing: 16) {
                        ForEach(passes) { pass in
                            PassCardView(pass: pass)
                        }
                    }
                    .padding()
                }
            }
        }
        // 5. The modern "useEffect" that triggers our API Service
        .task {
            await fetchPassData()
        }
    }
    
    // MARK: - Network Helper
    private func fetchPassData() async {
        isLoading = true
        do {
            // Calling the singleton service we built earlier!
            passes = try await MountainPassesService.shared.getMountainPasses()
            isLoading = false
        } catch {
            errorMessage = "Please check your connection and try again."
            print("API Error: \(error)") // Prints the exact error to your Xcode console
            isLoading = false
        }
    }
}

// MARK: sub-views

struct PassCardView: View {
    let pass: MountainPass
    
    var body: some View {
        HStack(alignment: .top) {
            
            // Left Side: Text Data
            VStack(alignment: .leading, spacing: 8) {
                Text(pass.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // We use 'if let' because restrictions are optional in our model
                if let r1 = pass.restrictionOne {
                    Text("\(r1.travelDirection): \(r1.restrictionText)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let r2 = pass.restrictionTwo {
                    Text("\(r2.travelDirection): \(r2.restrictionText)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer() // Pushes the text left and the icon right
            
            // Right Side: Weather Icon
            // This perfectly uses the computed property we built in your model!
            Image(systemName: pass.weatherSymbol)
                .font(.system(size: 32))
                .foregroundColor(.accentColor)
                .padding(.top, 4)
        }
        
        .padding()
        // These modifiers create the "Card" look
        .background(Color(UIColor.systemBackground)) // Adapts to Light/Dark mode
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


#Preview {
    MountainPassesHome()
}
