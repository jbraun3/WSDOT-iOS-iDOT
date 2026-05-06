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
    
    // global nav styling
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.wsdoTprimarygreen
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UINavigationBar.appearance().tintColor = UIColor.white

    }
    
    var body: some View {
        NavigationStack {
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("WSDOT-logo-white")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
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
