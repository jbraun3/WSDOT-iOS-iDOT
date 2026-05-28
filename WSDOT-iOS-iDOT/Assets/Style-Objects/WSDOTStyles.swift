//
//  WSDOTStyles.swift
//  WSDOT-iOS-iDOT
//
//  Centralised design tokens and view modifiers for the WSDOT app.
//  Edit view modifier functions to change element styling across whole app.

import SwiftUI
import SwiftData

//  Design variables
//  Static let enum to store fixed, universal values in a group
enum WSDOTStyle {
    
    // colors
    static let primaryGreen  = Color("WSDOTprimarygreen")
    static let background    = Color("WSDOTbackground")
    static let accent        = Color.accentColor
    
    // glass surface card
    static let cardCornerRadius: CGFloat  = 16
    static let cardShadowRadius: CGFloat  = 4
    static let cardShadowOpacity: Double  = 0.10
    static let cardShadowOffset: CGSize   = CGSize(width: 0, height: 2)
    
    // home screen buttons
    static let featureButtonSize: CGFloat = 80
    static let featureIconSize: CGFloat   = 40
    static let featureIconSpacing: CGFloat = 90
    static let featureLabelSize: CGFloat  = 10
}

//  MARK: -Universal View Modifiers

//  glass card surface
//  apply with '.wsdotCard()'
struct WSDOTCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        // liquid glass
        if #available(iOS 26.0, *) {
            content
                .glassEffect(in: .rect(cornerRadius: WSDOTStyle.cardCornerRadius))
                .shadow(
                    color: WSDOTStyle.accent.opacity(WSDOTStyle.cardShadowOpacity),
                    radius: WSDOTStyle.cardShadowRadius,
                    x: WSDOTStyle.cardShadowOffset.width,
                    y: WSDOTStyle.cardShadowOffset.height
                )
        // if not iOS 26
        } else {
            content
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: WSDOTStyle.cardCornerRadius))
                .shadow(
                    color: WSDOTStyle.accent.opacity(WSDOTStyle.cardShadowOpacity),
                    radius: WSDOTStyle.cardShadowRadius,
                    x: WSDOTStyle.cardShadowOffset.width,
                    y: WSDOTStyle.cardShadowOffset.height
                )
        }
    }
}

//  Feature navigation tile on home screen
//  apply with '.wsdotFeatureTile()
struct WSDOTFeatureTileModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .frame(
                    width:  WSDOTStyle.featureButtonSize,
                    height: WSDOTStyle.featureButtonSize
                )
                .glassEffect(
                    .regular.interactive(),
                    in: .rect(cornerRadius: WSDOTStyle.cardCornerRadius)
                )
        // if not iOS 26
        } else {
            content
                .frame(
                    width:  WSDOTStyle.featureButtonSize,
                    height: WSDOTStyle.featureButtonSize
                )
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: WSDOTStyle.cardCornerRadius))
        }
    }
}

//  WSDOT header for toolbar
//  apply with '.wsdotToolBar()'
struct WSDOTToolbarModifier: ViewModifier {
    func body(content: Content) -> some View {
        // automatically adaptive to iOS version
        content
            .toolbarBackground(WSDOTStyle.primaryGreen, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

//  Favorite star in trailing toolbar position
//  apply with '.wsdotFavorite(category:itemId:title:)'
//  @Query lives here (not inside the ToolbarItem closure) because SwiftData
//  environment propagation into toolbar-hosted views is unreliable.
struct WSDOTFavoriteModifier: ViewModifier {
    let category: FavoriteCategory
    let itemId: String
    let title: String
    let subtitle: String?

    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteItem]

    private var isFavorited: Bool {
        favorites.contains { $0.category == category && $0.itemId == itemId }
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: isFavorited ? "star.fill" : "star")
                    }
                }
            }
    }

    private func toggleFavorite() {
        if let existing = favorites.first(where: { $0.category == category && $0.itemId == itemId }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(FavoriteItem(category: category, itemId: itemId, title: title, subtitle: subtitle))
        }
    }
}

//  MARK: -View Extension functions for style application
extension View {
 
    func wsdotCard() -> some View {
        modifier(WSDOTCardModifier())
    }
 
    func wsdotFeatureTile() -> some View {
        modifier(WSDOTFeatureTileModifier())
    }
 
    func wsdotToolbar() -> some View {
        modifier(WSDOTToolbarModifier())
    }

    func wsdotFavorite(category: FavoriteCategory, itemId: String, title: String, subtitle: String? = nil) -> some View {
        modifier(WSDOTFavoriteModifier(category: category, itemId: itemId, title: title, subtitle: subtitle))
    }
}
