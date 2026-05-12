//
//  ContentView.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/27/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    let features: [WSDOTFeature] = [
        WSDOTFeature(icon: "icHomeTraffic", label: "Traffic Map", destination: AnyView(TrafficMapHome())),
        WSDOTFeature(icon: "icHomeFerries", label: "Ferries", destination: AnyView(FerriesHome())),
        WSDOTFeature(icon: "icBridgeAlerts", label: "Bridge Alerts", destination: AnyView(BridgeAlertsHome())),
        WSDOTFeature(icon: "icHomeAmtrakCascades", label: "Amtrak", destination: AnyView(AmtrakHome())),
        WSDOTFeature(icon: "icHomePasses", label: "Mountain Passes", destination: AnyView(MountainPassesHome())),
        WSDOTFeature(icon: "icHomeMyRoutes", label: "My Routes", destination: AnyView(MyRoutesHome())),
        WSDOTFeature(icon: "icHomeTollRates", label: "Toll Rates", destination: AnyView(TollRatesHome())),
        WSDOTFeature(icon: "icHomeBorderWaits", label: "Border Waits", destination: AnyView(BorderWaitsHome()))
    ]
    
    let radius: CGFloat = 145
    
    @State private var isSwipedUp = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                // body styling
                Color("WSDOTbackground")
                    .ignoresSafeArea()
                
                RadialGradient(
                    colors: [
                        Color(red: 0.0, green: 0.812, blue: 0.627),
                        Color("WSDOTbackground")
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 170
                )
                //                .frame(width: 344, height: 336)
                .opacity(0.30)
                .offset(y: isSwipedUp ? -320 : 0)
                
                // favorite items
                
                if isSwipedUp {
                    VStack {
                        Spacer().frame(height: 250)
                        Text("Favorites")
                            .font(.title2).bold()
                        
                        // favorites objects

                    }
                    .transition(.opacity)
                }
                
                // loop through icons
                ForEach(0..<features.count, id: \.self) { index in
                    NavigationLink(destination: features[index].destination) {
                        VStack {
                            Image(features[index].icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text(features[index].label)
                                .font(.system(size: 10))
                                .foregroundColor(Color( "AccentColor"))
                            // line limit?
                        }
                        .frame(width: 80, height: 80)
                        .glassEffect(
                            .regular.interactive(), in: .rect(cornerRadius: 16.0)
                        )
                    }
                    .buttonStyle(.plain)
                    .offset(x: xOffset(for: index), y: yOffset(for: index))                }
                
                // swipe as toggle
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isSwipedUp.toggle()
                    }
                }) {
                    Image(systemName: isSwipedUp ? "chevron.down" : "chevron.up")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color("WSDOTprimarygreen"))
                }
                .offset(y: 250)
            }
            .gesture(DragGesture()
                .onEnded { value in
                    if value.translation.height < -50 && !isSwipedUp {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { isSwipedUp = true }
                    } else if value.translation.height > 50 && isSwipedUp {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { isSwipedUp = false }
                    }
                }
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("WSDOT-logo-white")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                }
            }
            .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        
    }
    
    // MARK: -layout helpers
    
    // calculate horezontal positions
    func xOffset(for index: Int) -> CGFloat {
        if isSwipedUp {
            let col = index % 4
            return CGFloat(col) * 90 - 135
        } else {
            let angle = Double(index) * (360 / Double(features.count))
            let radian = angle * .pi / 180
            return CGFloat(sin(radian)) * radius
        }
    }
    
    func yOffset(for index: Int) -> CGFloat {
        if isSwipedUp {
            let row = index / 4
            return CGFloat(row) * 90 - 300
        } else {
            let angle = Double(index) * (360 / Double(features.count))
            let radian = Angle(degrees: angle).radians
            return -CGFloat(cos(radian)) * radius
        }
    }
}

#Preview {
    ContentView()
}
