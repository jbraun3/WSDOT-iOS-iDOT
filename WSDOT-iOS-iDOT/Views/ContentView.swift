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
    let icons = ["icHomeTraffic", "icHomeFerries", "icHomePasses", "icBridgeAlerts", "icHomeTollRates", "icHomeBorderWaits", "icHomeAmtrakCascades", "icHomeMyRoutes"]
    let labels = ["Traffic Map", "Ferries", "Mountain Passes", "Bridge Alerts", "Toll Rates", "Border Waits", "Amtrak", "My Routes"]
    
    let radius: CGFloat = 120
    
    var body: some View {
        NavigationView {
            ZStack{
                ForEach(0 ..< icons.count, id :\.self){index in
                    let angle = Double(index) * (360/Double(icons.count))
                    NavigationLink(destination: destinations[index]) {
                        VStack{
                            Image(icons[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            Text(labels[index])
                                .font(.caption)
                        }
                    }
                    .buttonStyle(.plain)
                    .rotationEffect(.degrees(-angle))
                    .offset(y: -radius)
                    .rotationEffect(.degrees(angle))
                }
            }
        }
    }
    
    let destinations: [AnyView] = [
        AnyView(TrafficMapHome()),
        AnyView(FerriesHome()),
        AnyView(MountainPassesHome()),
        AnyView(BridgeAlertsHome()),
        AnyView(TollRatesHome()),
        AnyView(BorderWaitsHome()),
        AnyView(AmtrakHome()),
        AnyView(MyRoutesHome())
    ]
}


#Preview {
    ContentView()
}
