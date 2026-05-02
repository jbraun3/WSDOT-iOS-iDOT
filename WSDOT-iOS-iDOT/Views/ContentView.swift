//
//  ContentView.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/27/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    //Traffic Map, Ferries, Mountain Passes, Bridge Alerts, Toll Rates, Border Waits, Amtrak, My Routes
    let icons = ["map.fill", "ferry.fill", "mountain.2.fill", "person.fill", "creditcard.fill", "flag.fill", "tram.fill", "road.lanes"]
    let labels = ["Traffic Map", "Ferries", "Mountain Passes", "Bridge Alerts", "Toll Rates", "Border Waits", "Amtrak", "My Routes"]
    
    let radius: CGFloat = 120
    
    var body: some View {
        ZStack{
            ForEach(0 ..< icons.count, id :\.self){index in
                let angle = Double(index) * (360/Double(icons.count))
                VStack{
                    Image(systemName: icons[index])
                        .font(.system(size:60))
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    Text(labels[index])
                        .font(.caption)

                }
                .rotationEffect(.degrees(-angle))

                .offset(y: -radius)
                .rotationEffect(.degrees(angle))
            }
        }
    }
}


#Preview {
    ContentView()
}
