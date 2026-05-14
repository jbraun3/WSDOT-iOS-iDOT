//
//  WSDOTStyles.swift
//  WSDOT-iOS-iDOT
//
//  Centralised design tokens and view modifiers for the WSDOT app.
//  Edit view modifier functions to change element styling across whole app.

import SwiftUI

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
}
