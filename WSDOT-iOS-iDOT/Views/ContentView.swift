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
    let icons = ["map.fill", "ferry.fill", "mountain.2.fill", "bridge.fill", "creditcard.fill", "flag.fill", "tram.fill", "road.lanes"]
    let labels = ["Traffic Map", "Ferries", "Mountain Passes", "Bridge Alerts", "Toll Rates", "Border Waits", "Amtrak", "My Routes"]
    
    // get favorites data
    @Query(sort: \FavoriteItem.addedDate) private var favorites: [FavoriteItem]

    private var categoriesWithFavorites: [(FavoriteCategory, [FavoriteItem])] {
        FavoriteCategory.allCases.compactMap { category in
            let items = favorites.filter { $0.category == category }
            return items.isEmpty ? nil : (category, items)
        }
    }

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
                
                RadialGradient(
                    colors: [
                        Color(red: 0.0, green: 0.812, blue: 0.627),
                        Color("WSDOTbackground")
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 170
                )
                .opacity(0.30)
                .offset(y: isSwipedUp ? -320 : 0)
                
                // favorite items
                if isSwipedUp {
                    VStack {
                        Text("Favorites")
                            .font(.title2).bold()
                            .offset(x: -135)

                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 16) {
                                ForEach(categoriesWithFavorites, id: \.0) { category, items in
                                    Section {
                                        ForEach(items) { item in
                                            HStack {
                                                Image(item.category.icon)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 28, height: 28)
                                                VStack(alignment: .leading) {
                                                    Text(item.title)
                                                        .font(.headline)
                                                    if let subtitle = item.subtitle {
                                                        Text(subtitle)
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                            .wsdotCard()
                                        }
                                    } header: {
                                        Text(category.label)
                                            .font(.subheadline).bold()
                                            .foregroundColor(.secondary)
                                            .padding(.top, 4)
                                    }
                                }

                                if favorites.isEmpty {
                                    Text("No favorites yet")
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 20)
                                }
                            }
                            .padding([.leading, .trailing, .bottom])
                        }
                    }
                    .transition(.opacity)
                    .offset(y: 200)
                    .padding(.top)
                }
                
                // Feature icons
                ForEach(0..<features.count, id: \.self) { index in
                    NavigationLink(destination: features[index].destination) {
                        VStack {
                            Image(features[index].icon)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: WSDOTStyle.featureIconSize,
                                    height: WSDOTStyle.featureIconSize
                                )
                            
                            Text(features[index].label)
                                .font(.system(size: WSDOTStyle.featureLabelSize))
                                .foregroundColor(WSDOTStyle.accent)
                                .multilineTextAlignment(.center)
                        }
                        .wsdotFeatureTile()
                    }
                    .buttonStyle(.plain)
                    .offset(x: xOffset(for: index), y: yOffset(for: index))                }
                
                // swipe as toggle
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isSwipedUp.toggle()
                    }
                }) {
                    if !isSwipedUp {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(WSDOTStyle.primaryGreen)
                    }
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
            .wsdotToolbar()
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
    // In-memory SwiftData container seeded with sample favorites
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: FavoriteItem.self, SavedRoute.self,
        configurations: config
    )

    let samples: [FavoriteItem] = [
        FavoriteItem(category: .mountainPass, itemId: "1",   title: "Snoqualmie Pass"),
        FavoriteItem(category: .mountainPass, itemId: "2",   title: "Stevens Pass"),
        FavoriteItem(category: .trafficCamera, itemId: "100", title: "I-5 at Northgate",  subtitle: "I-5"),
        FavoriteItem(category: .trafficCamera, itemId: "101", title: "SR 520 at Montlake", subtitle: "SR 520"),
        FavoriteItem(category: .borderWait,   itemId: "5",   title: "Peace Arch"),
        FavoriteItem(category: .tollRate,     itemId: "SR 520", title: "SR 520 Bridge"),
        FavoriteItem(category: .route,        itemId: UUID().uuidString, title: "Home → Work"),
        FavoriteItem(category: .ferryRoute,   itemId: "sea-bi", title: "Seattle ↔ Bainbridge")
    ]
    for fav in samples {
        container.mainContext.insert(fav)
    }

    return ContentView()
        .modelContainer(container)
}
