//
//  MountainPassesHome.swift
//  WSDOT-iOS-iDOT
//
//  Created by iDOT
//

// FINISHED?

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
            passes = try await MountainPassesService.shared.getMountainPasses()
            isLoading = false
        } catch {
            // error handling
            errorMessage = "Please check your connection and try again."
            print("API Error: \(error)")
            isLoading = false
        }
    }
}

// MARK: - Sub-Views
struct PassCardView: View {
    let pass: MountainPass
    
    var body: some View {
        HStack(alignment: .top) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text(pass.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
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
            
            Spacer()
            
            Image(systemName: pass.weatherSymbol)
                .font(.system(size: 32))
                .foregroundColor(.accentColor)
                .padding(.top, 4)
        }
        
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
        .shadow(color: Color.accentColor.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
