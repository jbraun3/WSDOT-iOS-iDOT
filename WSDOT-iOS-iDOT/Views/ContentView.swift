//
//  ContentView.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/27/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    let icons = ["icHomeTraffic", "icHomeFerries", "icBridgeAlerts", "icHomeAmtrakCascades", "icHomeMyRoutes", "icHomePasses", "icHomeTollRates", "icHomeBorderWaits"]
    
    let radius: CGFloat = 145
    
    @State private var offset: CGFloat = 0
    @State private var isSwipedUp = false
    
    let row1: [(icon: String, view: AnyView)] = [
        ("icHomeTraffic", AnyView(TrafficMapHome())),
        ("icHomeFerries", AnyView(FerriesHome())),
        ("icBridgeAlerts", AnyView(BridgeAlertsHome())),
        ("icHomeAmtrakCascades", AnyView(AmtrakHome()))
    ]
    
    let row2: [(icon: String, view: AnyView)] = [
        ("icHomePasses", AnyView(MountainPassesHome())),
        ("icHomeMyRoutes", AnyView(MyRoutesHome())),
        ("icHomeTollRates", AnyView(TollRatesHome())),
        ("icHomeBorderWaits", AnyView(BorderWaitsHome()))
    ]
    
    let row1Positions: [(x: CGFloat, y: CGFloat)] = [(11, 31), (111, 31), (211, 31), (311, 31)]
    let row2Positions: [(x: CGFloat, y: CGFloat)] = [(11, 131), (111, 131), (211, 131), (311, 131)]
    
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
                Color(red: 0.11, green: 0.11, blue: 0.114)
                    .ignoresSafeArea()
                
                RadialGradient(
                    colors: [
                        Color(red: 0.0, green: 0.812, blue: 0.627),
                        Color(red: 0.039, green: 0.255, blue: 0.204),
                        Color(red: 0.11, green: 0.11, blue: 0.114)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 170
                )
                .frame(width: 344, height: 336)
                .opacity(0.10)
                
                if isSwipedUp {
                    gridView
                } else {
                    circularView
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height < -50 && !isSwipedUp {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                isSwipedUp = true
                            }
                        } else if value.translation.height > 50 && isSwipedUp {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                isSwipedUp = false
                            }
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
        }
    }
    
    var circularView: some View {
        ZStack {
            ForEach(0 ..< icons.count, id :\.self){index in
                let angle = Double(index) * (360/Double(icons.count))
                NavigationLink(destination: destinations[index]) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 90, height: 90)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color.white.opacity(0), location: 0),
                                                .init(color: Color.white.opacity(0.35), location: 0.12),
                                                .init(color: Color.white.opacity(0), location: 0.37),
                                                .init(color: Color.white.opacity(0.35), location: 0.62),
                                                .init(color: Color.white.opacity(0), location: 0.87),
                                                .init(color: Color.white.opacity(0), location: 1)
                                            ]),
                                            center: .center
                                        ),
                                        lineWidth: 1
                                    )
                            )
                        
                        VStack{
                            Image(icons[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            Text(labels[index])
                                .font(.caption)
                        }
                    }
                }
                .buttonStyle(.plain)
                .rotationEffect(.degrees(-angle))
                .offset(y: -radius)
                .rotationEffect(.degrees(angle))
            }
            
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isSwipedUp = true
                }
            }) {
                Image(systemName: "chevron.up")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.wsdoTprimarygreen)
            }
            .frame(maxWidth: .infinity)
            .position(x: UIScreen.main.bounds.width / 2, y: 605)
        }
    }
    
    var gridView: some View {
        ZStack {
            ForEach(0 ..< row1.count, id :\.self){index in
                NavigationLink(destination: row1[index].view) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 90, height: 90)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color.white.opacity(0), location: 0),
                                                .init(color: Color.white.opacity(0.35), location: 0.12),
                                                .init(color: Color.white.opacity(0), location: 0.37),
                                                .init(color: Color.white.opacity(0.35), location: 0.62),
                                                .init(color: Color.white.opacity(0), location: 0.87),
                                                .init(color: Color.white.opacity(0), location: 1)
                                            ]),
                                            center: .center
                                        ),
                                        lineWidth: 1
                                    )
                            )
                        
                        Image(row1[index].icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    .position(x: row1Positions[index].x + 45, y: row1Positions[index].y + 45)
                }
                .buttonStyle(.plain)
            }
            
            ForEach(0 ..< row2.count, id :\.self){index in
                NavigationLink(destination: row2[index].view) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 90, height: 90)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color.white.opacity(0), location: 0),
                                                .init(color: Color.white.opacity(0.35), location: 0.12),
                                                .init(color: Color.white.opacity(0), location: 0.37),
                                                .init(color: Color.white.opacity(0.35), location: 0.62),
                                                .init(color: Color.white.opacity(0), location: 0.87),
                                                .init(color: Color.white.opacity(0), location: 1)
                                            ]),
                                            center: .center
                                        ),
                                        lineWidth: 1
                                    )
                            )
                        
                        Image(row2[index].icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    .position(x: row2Positions[index].x + 45, y: row2Positions[index].y + 45)
                }
                .buttonStyle(.plain)
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
    
    let labels = ["Traffic Map", "Ferries", "Bridge Alerts", "Amtrak", "My Routes", "Mountain Passes", "Toll Rates", "Border Waits"]
}


#Preview {
    ContentView()
}
