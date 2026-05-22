//
//  MountainPassesDetail.swift
//  WSDOT-iOS-iDOT
//
//  Created by iDOT
//

// TO DO: cameras, weather

import SwiftUI

struct MountainPassesDetail: View {
    
    let pass: MountainPass
    
    @State private var showAllCameras = false
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 24) {
                
                Text(pass.name)
                    .font(.largeTitle).bold()
                
                // conditions
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Restrictions")
                        .font(.title2).bold()
                    
                    if let r1 = pass.restrictionOne {
                        Text("\(r1.travelDirection): \(r1.restrictionText)")
                    }
                    
                    if let r2 = pass.restrictionTwo {
                        Text("\(r2.travelDirection): \(r2.restrictionText)")
                    }
                    
                    Spacer()
                
                    if !pass.roadCondition.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Conditions")
                                .font(.title2).bold()
                            Text(pass.roadCondition)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        if let elevation = pass.elevationInFeet {
                            Label("\(elevation) ft", systemImage: "arrow.up.and.down")
                        }
                        Spacer()
                        if let temp = pass.temperatureInFahrenheit {
                            Label("\(temp)°F", systemImage: "thermometer")
                        }
                    }
                    .foregroundColor(.secondary)
                    
                }
                .padding()
                .wsdotCard()
                
                // cameras
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Cameras")
                        .font(.title2).bold()
                    
                    if let r1 = pass.restrictionOne {
                        Text("\(r1.travelDirection): \(r1.restrictionText)")
                    }
                    
                    if let r2 = pass.restrictionTwo {
                        Text("\(r2.travelDirection): \(r2.restrictionText)")
                    }
                    
                    Spacer()
                
                    if !pass.roadCondition.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Conditions")
                                .font(.title2).bold()
                            Text(pass.roadCondition)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        if let elevation = pass.elevationInFeet {
                            Label("\(elevation) ft", systemImage: "arrow.up.and.down")
                        }
                        Spacer()
                        if let temp = pass.temperatureInFahrenheit {
                            Label("\(temp)°F", systemImage: "thermometer")
                        }
                    }
                    .foregroundColor(.secondary)
                    
                }
                .padding()
                .wsdotCard()
                
                // decode date format
                Text("Last updated: \(pass.dateUpdated)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
            }
            .padding()
        }
        
        .navigationTitle("\(pass.name)")
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
        
    }
}
