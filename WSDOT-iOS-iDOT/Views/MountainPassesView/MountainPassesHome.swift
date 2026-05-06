//
//  MountainPassesHome.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
import SwiftUI

struct MountainPassesHome: View {
    @State private var passes: [MountainPass] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    var body: some View {
        
        Group {
            if isLoading {
                ProgressView("Fetching live conditions...")
            } else if let errorMessage = errorMessage {
                Text("Failed to load: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(passes) { pass in
                            NavigationLink(destination: MountainPassesDetail(pass: pass)) {
                                PassCardView(pass: pass)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }

        .navigationTitle("Mountain Passes")
        .navigationBarTitleDisplayMode(.inline)
        
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
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.accentColor.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
