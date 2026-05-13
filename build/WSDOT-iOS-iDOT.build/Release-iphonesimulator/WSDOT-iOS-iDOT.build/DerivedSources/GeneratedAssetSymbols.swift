import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "AccentColor" asset catalog color resource.
    static let accent = DeveloperToolsSupport.ColorResource(name: "AccentColor", bundle: resourceBundle)

    /// The "WSDOTbackground" asset catalog color resource.
    static let wsdoTbackground = DeveloperToolsSupport.ColorResource(name: "WSDOTbackground", bundle: resourceBundle)

    /// The "WSDOTbackground2" asset catalog color resource.
    static let wsdoTbackground2 = DeveloperToolsSupport.ColorResource(name: "WSDOTbackground2", bundle: resourceBundle)

    /// The "WSDOTbrightgreen" asset catalog color resource.
    static let wsdoTbrightgreen = DeveloperToolsSupport.ColorResource(name: "WSDOTbrightgreen", bundle: resourceBundle)

    /// The "WSDOTbrightgreen25" asset catalog color resource.
    static let wsdoTbrightgreen25 = DeveloperToolsSupport.ColorResource(name: "WSDOTbrightgreen25", bundle: resourceBundle)

    /// The "WSDOTbrightgreen50" asset catalog color resource.
    static let wsdoTbrightgreen50 = DeveloperToolsSupport.ColorResource(name: "WSDOTbrightgreen50", bundle: resourceBundle)

    /// The "WSDOTbrightgreen75" asset catalog color resource.
    static let wsdoTbrightgreen75 = DeveloperToolsSupport.ColorResource(name: "WSDOTbrightgreen75", bundle: resourceBundle)

    /// The "WSDOTdarkgreen" asset catalog color resource.
    static let wsdoTdarkgreen = DeveloperToolsSupport.ColorResource(name: "WSDOTdarkgreen", bundle: resourceBundle)

    /// The "WSDOTdarkgreen25" asset catalog color resource.
    static let wsdoTdarkgreen25 = DeveloperToolsSupport.ColorResource(name: "WSDOTdarkgreen25", bundle: resourceBundle)

    /// The "WSDOTdarkgreen50" asset catalog color resource.
    static let wsdoTdarkgreen50 = DeveloperToolsSupport.ColorResource(name: "WSDOTdarkgreen50", bundle: resourceBundle)

    /// The "WSDOTdarkgreen75" asset catalog color resource.
    static let wsdoTdarkgreen75 = DeveloperToolsSupport.ColorResource(name: "WSDOTdarkgreen75", bundle: resourceBundle)

    /// The "WSDOTgrey" asset catalog color resource.
    static let wsdoTgrey = DeveloperToolsSupport.ColorResource(name: "WSDOTgrey", bundle: resourceBundle)

    /// The "WSDOTgrey25" asset catalog color resource.
    static let wsdoTgrey25 = DeveloperToolsSupport.ColorResource(name: "WSDOTgrey25", bundle: resourceBundle)

    /// The "WSDOTgrey50" asset catalog color resource.
    static let wsdoTgrey50 = DeveloperToolsSupport.ColorResource(name: "WSDOTgrey50", bundle: resourceBundle)

    /// The "WSDOTgrey75" asset catalog color resource.
    static let wsdoTgrey75 = DeveloperToolsSupport.ColorResource(name: "WSDOTgrey75", bundle: resourceBundle)

    /// The "WSDOTlightgreen" asset catalog color resource.
    static let wsdoTlightgreen = DeveloperToolsSupport.ColorResource(name: "WSDOTlightgreen", bundle: resourceBundle)

    /// The "WSDOTlightgreen25" asset catalog color resource.
    static let wsdoTlightgreen25 = DeveloperToolsSupport.ColorResource(name: "WSDOTlightgreen25", bundle: resourceBundle)

    /// The "WSDOTlightgreen50" asset catalog color resource.
    static let wsdoTlightgreen50 = DeveloperToolsSupport.ColorResource(name: "WSDOTlightgreen50", bundle: resourceBundle)

    /// The "WSDOTlightgreen75" asset catalog color resource.
    static let wsdoTlightgreen75 = DeveloperToolsSupport.ColorResource(name: "WSDOTlightgreen75", bundle: resourceBundle)

    /// The "WSDOTlimegreen" asset catalog color resource.
    static let wsdoTlimegreen = DeveloperToolsSupport.ColorResource(name: "WSDOTlimegreen", bundle: resourceBundle)

    /// The "WSDOTlimegreen25" asset catalog color resource.
    static let wsdoTlimegreen25 = DeveloperToolsSupport.ColorResource(name: "WSDOTlimegreen25", bundle: resourceBundle)

    /// The "WSDOTlimegreen50" asset catalog color resource.
    static let wsdoTlimegreen50 = DeveloperToolsSupport.ColorResource(name: "WSDOTlimegreen50", bundle: resourceBundle)

    /// The "WSDOTlimegreen75" asset catalog color resource.
    static let wsdoTlimegreen75 = DeveloperToolsSupport.ColorResource(name: "WSDOTlimegreen75", bundle: resourceBundle)

    /// The "WSDOTprimarygreen" asset catalog color resource.
    static let wsdoTprimarygreen = DeveloperToolsSupport.ColorResource(name: "WSDOTprimarygreen", bundle: resourceBundle)

    /// The "WSDOTprimarygreen25" asset catalog color resource.
    static let wsdoTprimarygreen25 = DeveloperToolsSupport.ColorResource(name: "WSDOTprimarygreen25", bundle: resourceBundle)

    /// The "WSDOTprimarygreen50" asset catalog color resource.
    static let wsdoTprimarygreen50 = DeveloperToolsSupport.ColorResource(name: "WSDOTprimarygreen50", bundle: resourceBundle)

    /// The "WSDOTprimarygreen75" asset catalog color resource.
    static let wsdoTprimarygreen75 = DeveloperToolsSupport.ColorResource(name: "WSDOTprimarygreen75", bundle: resourceBundle)

    /// The "WSDOTtext" asset catalog color resource.
    static let wsdoTtext = DeveloperToolsSupport.ColorResource(name: "WSDOTtext", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "WSDOT-logo-black" asset catalog image resource.
    static let wsdotLogoBlack = DeveloperToolsSupport.ImageResource(name: "WSDOT-logo-black", bundle: resourceBundle)

    /// The "WSDOT-logo-white" asset catalog image resource.
    static let wsdotLogoWhite = DeveloperToolsSupport.ImageResource(name: "WSDOT-logo-white", bundle: resourceBundle)

    /// The "bridgealerttype" asset catalog image resource.
    static let bridgealerttype = DeveloperToolsSupport.ImageResource(name: "bridgealerttype", bundle: resourceBundle)

    /// The "closurealertseverity" asset catalog image resource.
    static let closurealertseverity = DeveloperToolsSupport.ImageResource(name: "closurealertseverity", bundle: resourceBundle)

    /// The "conealerttype" asset catalog image resource.
    static let conealerttype = DeveloperToolsSupport.ImageResource(name: "conealerttype", bundle: resourceBundle)

    /// The "highalertseverity" asset catalog image resource.
    static let highalertseverity = DeveloperToolsSupport.ImageResource(name: "highalertseverity", bundle: resourceBundle)

    /// The "icBridgeAlerts" asset catalog image resource.
    static let icBridgeAlerts = DeveloperToolsSupport.ImageResource(name: "icBridgeAlerts", bundle: resourceBundle)

    /// The "icHomeAmtrakCascades" asset catalog image resource.
    static let icHomeAmtrakCascades = DeveloperToolsSupport.ImageResource(name: "icHomeAmtrakCascades", bundle: resourceBundle)

    /// The "icHomeBorderWaits" asset catalog image resource.
    static let icHomeBorderWaits = DeveloperToolsSupport.ImageResource(name: "icHomeBorderWaits", bundle: resourceBundle)

    /// The "icHomeFavorites" asset catalog image resource.
    static let icHomeFavorites = DeveloperToolsSupport.ImageResource(name: "icHomeFavorites", bundle: resourceBundle)

    /// The "icHomeFerries" asset catalog image resource.
    static let icHomeFerries = DeveloperToolsSupport.ImageResource(name: "icHomeFerries", bundle: resourceBundle)

    /// The "icHomeMyRoutes" asset catalog image resource.
    static let icHomeMyRoutes = DeveloperToolsSupport.ImageResource(name: "icHomeMyRoutes", bundle: resourceBundle)

    /// The "icHomePasses" asset catalog image resource.
    static let icHomePasses = DeveloperToolsSupport.ImageResource(name: "icHomePasses", bundle: resourceBundle)

    /// The "icHomeSocialMedia" asset catalog image resource.
    static let icHomeSocialMedia = DeveloperToolsSupport.ImageResource(name: "icHomeSocialMedia", bundle: resourceBundle)

    /// The "icHomeTollRates" asset catalog image resource.
    static let icHomeTollRates = DeveloperToolsSupport.ImageResource(name: "icHomeTollRates", bundle: resourceBundle)

    /// The "icHomeTraffic" asset catalog image resource.
    static let icHomeTraffic = DeveloperToolsSupport.ImageResource(name: "icHomeTraffic", bundle: resourceBundle)

    /// The "legendinfoicon" asset catalog image resource.
    static let legendinfoicon = DeveloperToolsSupport.ImageResource(name: "legendinfoicon", bundle: resourceBundle)

    /// The "lowalertseverity" asset catalog image resource.
    static let lowalertseverity = DeveloperToolsSupport.ImageResource(name: "lowalertseverity", bundle: resourceBundle)

    /// The "maintenancealerttype" asset catalog image resource.
    static let maintenancealerttype = DeveloperToolsSupport.ImageResource(name: "maintenancealerttype", bundle: resourceBundle)

    /// The "mediumalertseverity" asset catalog image resource.
    static let mediumalertseverity = DeveloperToolsSupport.ImageResource(name: "mediumalertseverity", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "AccentColor" asset catalog color.
    static var accent: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .accent)
#else
        .init()
#endif
    }

    /// The "WSDOTbackground" asset catalog color.
    static var wsdoTbackground: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTbackground)
#else
        .init()
#endif
    }

    /// The "WSDOTbackground2" asset catalog color.
    static var wsdoTbackground2: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTbackground2)
#else
        .init()
#endif
    }

    /// The "WSDOTbrightgreen" asset catalog color.
    static var wsdoTbrightgreen: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTbrightgreen)
#else
        .init()
#endif
    }

    /// The "WSDOTbrightgreen25" asset catalog color.
    static var wsdoTbrightgreen25: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTbrightgreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTbrightgreen50" asset catalog color.
    static var wsdoTbrightgreen50: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTbrightgreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTbrightgreen75" asset catalog color.
    static var wsdoTbrightgreen75: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTbrightgreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTdarkgreen" asset catalog color.
    static var wsdoTdarkgreen: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTdarkgreen)
#else
        .init()
#endif
    }

    /// The "WSDOTdarkgreen25" asset catalog color.
    static var wsdoTdarkgreen25: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTdarkgreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTdarkgreen50" asset catalog color.
    static var wsdoTdarkgreen50: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTdarkgreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTdarkgreen75" asset catalog color.
    static var wsdoTdarkgreen75: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTdarkgreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTgrey" asset catalog color.
    static var wsdoTgrey: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTgrey)
#else
        .init()
#endif
    }

    /// The "WSDOTgrey25" asset catalog color.
    static var wsdoTgrey25: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTgrey25)
#else
        .init()
#endif
    }

    /// The "WSDOTgrey50" asset catalog color.
    static var wsdoTgrey50: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTgrey50)
#else
        .init()
#endif
    }

    /// The "WSDOTgrey75" asset catalog color.
    static var wsdoTgrey75: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTgrey75)
#else
        .init()
#endif
    }

    /// The "WSDOTlightgreen" asset catalog color.
    static var wsdoTlightgreen: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTlightgreen)
#else
        .init()
#endif
    }

    /// The "WSDOTlightgreen25" asset catalog color.
    static var wsdoTlightgreen25: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTlightgreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTlightgreen50" asset catalog color.
    static var wsdoTlightgreen50: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTlightgreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTlightgreen75" asset catalog color.
    static var wsdoTlightgreen75: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTlightgreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTlimegreen" asset catalog color.
    static var wsdoTlimegreen: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTlimegreen)
#else
        .init()
#endif
    }

    /// The "WSDOTlimegreen25" asset catalog color.
    static var wsdoTlimegreen25: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTlimegreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTlimegreen50" asset catalog color.
    static var wsdoTlimegreen50: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTlimegreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTlimegreen75" asset catalog color.
    static var wsdoTlimegreen75: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTlimegreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTprimarygreen" asset catalog color.
    static var wsdoTprimarygreen: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTprimarygreen)
#else
        .init()
#endif
    }

    /// The "WSDOTprimarygreen25" asset catalog color.
    static var wsdoTprimarygreen25: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTprimarygreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTprimarygreen50" asset catalog color.
    static var wsdoTprimarygreen50: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTprimarygreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTprimarygreen75" asset catalog color.
    static var wsdoTprimarygreen75: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTprimarygreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTtext" asset catalog color.
    static var wsdoTtext: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdoTtext)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "AccentColor" asset catalog color.
    static var accent: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .accent)
#else
        .init()
#endif
    }

    /// The "WSDOTbackground" asset catalog color.
    static var wsdoTbackground: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTbackground)
#else
        .init()
#endif
    }

    /// The "WSDOTbackground2" asset catalog color.
    static var wsdoTbackground2: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTbackground2)
#else
        .init()
#endif
    }

    /// The "WSDOTbrightgreen" asset catalog color.
    static var wsdoTbrightgreen: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTbrightgreen)
#else
        .init()
#endif
    }

    /// The "WSDOTbrightgreen25" asset catalog color.
    static var wsdoTbrightgreen25: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTbrightgreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTbrightgreen50" asset catalog color.
    static var wsdoTbrightgreen50: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTbrightgreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTbrightgreen75" asset catalog color.
    static var wsdoTbrightgreen75: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTbrightgreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTdarkgreen" asset catalog color.
    static var wsdoTdarkgreen: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTdarkgreen)
#else
        .init()
#endif
    }

    /// The "WSDOTdarkgreen25" asset catalog color.
    static var wsdoTdarkgreen25: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTdarkgreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTdarkgreen50" asset catalog color.
    static var wsdoTdarkgreen50: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTdarkgreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTdarkgreen75" asset catalog color.
    static var wsdoTdarkgreen75: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTdarkgreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTgrey" asset catalog color.
    static var wsdoTgrey: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTgrey)
#else
        .init()
#endif
    }

    /// The "WSDOTgrey25" asset catalog color.
    static var wsdoTgrey25: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTgrey25)
#else
        .init()
#endif
    }

    /// The "WSDOTgrey50" asset catalog color.
    static var wsdoTgrey50: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTgrey50)
#else
        .init()
#endif
    }

    /// The "WSDOTgrey75" asset catalog color.
    static var wsdoTgrey75: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTgrey75)
#else
        .init()
#endif
    }

    /// The "WSDOTlightgreen" asset catalog color.
    static var wsdoTlightgreen: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTlightgreen)
#else
        .init()
#endif
    }

    /// The "WSDOTlightgreen25" asset catalog color.
    static var wsdoTlightgreen25: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTlightgreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTlightgreen50" asset catalog color.
    static var wsdoTlightgreen50: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTlightgreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTlightgreen75" asset catalog color.
    static var wsdoTlightgreen75: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTlightgreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTlimegreen" asset catalog color.
    static var wsdoTlimegreen: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTlimegreen)
#else
        .init()
#endif
    }

    /// The "WSDOTlimegreen25" asset catalog color.
    static var wsdoTlimegreen25: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTlimegreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTlimegreen50" asset catalog color.
    static var wsdoTlimegreen50: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTlimegreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTlimegreen75" asset catalog color.
    static var wsdoTlimegreen75: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTlimegreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTprimarygreen" asset catalog color.
    static var wsdoTprimarygreen: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTprimarygreen)
#else
        .init()
#endif
    }

    /// The "WSDOTprimarygreen25" asset catalog color.
    static var wsdoTprimarygreen25: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTprimarygreen25)
#else
        .init()
#endif
    }

    /// The "WSDOTprimarygreen50" asset catalog color.
    static var wsdoTprimarygreen50: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTprimarygreen50)
#else
        .init()
#endif
    }

    /// The "WSDOTprimarygreen75" asset catalog color.
    static var wsdoTprimarygreen75: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTprimarygreen75)
#else
        .init()
#endif
    }

    /// The "WSDOTtext" asset catalog color.
    static var wsdoTtext: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .wsdoTtext)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

    /// The "WSDOTbackground" asset catalog color.
    static var wsdoTbackground: SwiftUI.Color { .init(.wsdoTbackground) }

    /// The "WSDOTbackground2" asset catalog color.
    static var wsdoTbackground2: SwiftUI.Color { .init(.wsdoTbackground2) }

    /// The "WSDOTbrightgreen" asset catalog color.
    static var wsdoTbrightgreen: SwiftUI.Color { .init(.wsdoTbrightgreen) }

    /// The "WSDOTbrightgreen25" asset catalog color.
    static var wsdoTbrightgreen25: SwiftUI.Color { .init(.wsdoTbrightgreen25) }

    /// The "WSDOTbrightgreen50" asset catalog color.
    static var wsdoTbrightgreen50: SwiftUI.Color { .init(.wsdoTbrightgreen50) }

    /// The "WSDOTbrightgreen75" asset catalog color.
    static var wsdoTbrightgreen75: SwiftUI.Color { .init(.wsdoTbrightgreen75) }

    /// The "WSDOTdarkgreen" asset catalog color.
    static var wsdoTdarkgreen: SwiftUI.Color { .init(.wsdoTdarkgreen) }

    /// The "WSDOTdarkgreen25" asset catalog color.
    static var wsdoTdarkgreen25: SwiftUI.Color { .init(.wsdoTdarkgreen25) }

    /// The "WSDOTdarkgreen50" asset catalog color.
    static var wsdoTdarkgreen50: SwiftUI.Color { .init(.wsdoTdarkgreen50) }

    /// The "WSDOTdarkgreen75" asset catalog color.
    static var wsdoTdarkgreen75: SwiftUI.Color { .init(.wsdoTdarkgreen75) }

    /// The "WSDOTgrey" asset catalog color.
    static var wsdoTgrey: SwiftUI.Color { .init(.wsdoTgrey) }

    /// The "WSDOTgrey25" asset catalog color.
    static var wsdoTgrey25: SwiftUI.Color { .init(.wsdoTgrey25) }

    /// The "WSDOTgrey50" asset catalog color.
    static var wsdoTgrey50: SwiftUI.Color { .init(.wsdoTgrey50) }

    /// The "WSDOTgrey75" asset catalog color.
    static var wsdoTgrey75: SwiftUI.Color { .init(.wsdoTgrey75) }

    /// The "WSDOTlightgreen" asset catalog color.
    static var wsdoTlightgreen: SwiftUI.Color { .init(.wsdoTlightgreen) }

    /// The "WSDOTlightgreen25" asset catalog color.
    static var wsdoTlightgreen25: SwiftUI.Color { .init(.wsdoTlightgreen25) }

    /// The "WSDOTlightgreen50" asset catalog color.
    static var wsdoTlightgreen50: SwiftUI.Color { .init(.wsdoTlightgreen50) }

    /// The "WSDOTlightgreen75" asset catalog color.
    static var wsdoTlightgreen75: SwiftUI.Color { .init(.wsdoTlightgreen75) }

    /// The "WSDOTlimegreen" asset catalog color.
    static var wsdoTlimegreen: SwiftUI.Color { .init(.wsdoTlimegreen) }

    /// The "WSDOTlimegreen25" asset catalog color.
    static var wsdoTlimegreen25: SwiftUI.Color { .init(.wsdoTlimegreen25) }

    /// The "WSDOTlimegreen50" asset catalog color.
    static var wsdoTlimegreen50: SwiftUI.Color { .init(.wsdoTlimegreen50) }

    /// The "WSDOTlimegreen75" asset catalog color.
    static var wsdoTlimegreen75: SwiftUI.Color { .init(.wsdoTlimegreen75) }

    /// The "WSDOTprimarygreen" asset catalog color.
    static var wsdoTprimarygreen: SwiftUI.Color { .init(.wsdoTprimarygreen) }

    /// The "WSDOTprimarygreen25" asset catalog color.
    static var wsdoTprimarygreen25: SwiftUI.Color { .init(.wsdoTprimarygreen25) }

    /// The "WSDOTprimarygreen50" asset catalog color.
    static var wsdoTprimarygreen50: SwiftUI.Color { .init(.wsdoTprimarygreen50) }

    /// The "WSDOTprimarygreen75" asset catalog color.
    static var wsdoTprimarygreen75: SwiftUI.Color { .init(.wsdoTprimarygreen75) }

    /// The "WSDOTtext" asset catalog color.
    static var wsdoTtext: SwiftUI.Color { .init(.wsdoTtext) }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

    /// The "WSDOTbackground" asset catalog color.
    static var wsdoTbackground: SwiftUI.Color { .init(.wsdoTbackground) }

    /// The "WSDOTbackground2" asset catalog color.
    static var wsdoTbackground2: SwiftUI.Color { .init(.wsdoTbackground2) }

    /// The "WSDOTbrightgreen" asset catalog color.
    static var wsdoTbrightgreen: SwiftUI.Color { .init(.wsdoTbrightgreen) }

    /// The "WSDOTbrightgreen25" asset catalog color.
    static var wsdoTbrightgreen25: SwiftUI.Color { .init(.wsdoTbrightgreen25) }

    /// The "WSDOTbrightgreen50" asset catalog color.
    static var wsdoTbrightgreen50: SwiftUI.Color { .init(.wsdoTbrightgreen50) }

    /// The "WSDOTbrightgreen75" asset catalog color.
    static var wsdoTbrightgreen75: SwiftUI.Color { .init(.wsdoTbrightgreen75) }

    /// The "WSDOTdarkgreen" asset catalog color.
    static var wsdoTdarkgreen: SwiftUI.Color { .init(.wsdoTdarkgreen) }

    /// The "WSDOTdarkgreen25" asset catalog color.
    static var wsdoTdarkgreen25: SwiftUI.Color { .init(.wsdoTdarkgreen25) }

    /// The "WSDOTdarkgreen50" asset catalog color.
    static var wsdoTdarkgreen50: SwiftUI.Color { .init(.wsdoTdarkgreen50) }

    /// The "WSDOTdarkgreen75" asset catalog color.
    static var wsdoTdarkgreen75: SwiftUI.Color { .init(.wsdoTdarkgreen75) }

    /// The "WSDOTgrey" asset catalog color.
    static var wsdoTgrey: SwiftUI.Color { .init(.wsdoTgrey) }

    /// The "WSDOTgrey25" asset catalog color.
    static var wsdoTgrey25: SwiftUI.Color { .init(.wsdoTgrey25) }

    /// The "WSDOTgrey50" asset catalog color.
    static var wsdoTgrey50: SwiftUI.Color { .init(.wsdoTgrey50) }

    /// The "WSDOTgrey75" asset catalog color.
    static var wsdoTgrey75: SwiftUI.Color { .init(.wsdoTgrey75) }

    /// The "WSDOTlightgreen" asset catalog color.
    static var wsdoTlightgreen: SwiftUI.Color { .init(.wsdoTlightgreen) }

    /// The "WSDOTlightgreen25" asset catalog color.
    static var wsdoTlightgreen25: SwiftUI.Color { .init(.wsdoTlightgreen25) }

    /// The "WSDOTlightgreen50" asset catalog color.
    static var wsdoTlightgreen50: SwiftUI.Color { .init(.wsdoTlightgreen50) }

    /// The "WSDOTlightgreen75" asset catalog color.
    static var wsdoTlightgreen75: SwiftUI.Color { .init(.wsdoTlightgreen75) }

    /// The "WSDOTlimegreen" asset catalog color.
    static var wsdoTlimegreen: SwiftUI.Color { .init(.wsdoTlimegreen) }

    /// The "WSDOTlimegreen25" asset catalog color.
    static var wsdoTlimegreen25: SwiftUI.Color { .init(.wsdoTlimegreen25) }

    /// The "WSDOTlimegreen50" asset catalog color.
    static var wsdoTlimegreen50: SwiftUI.Color { .init(.wsdoTlimegreen50) }

    /// The "WSDOTlimegreen75" asset catalog color.
    static var wsdoTlimegreen75: SwiftUI.Color { .init(.wsdoTlimegreen75) }

    /// The "WSDOTprimarygreen" asset catalog color.
    static var wsdoTprimarygreen: SwiftUI.Color { .init(.wsdoTprimarygreen) }

    /// The "WSDOTprimarygreen25" asset catalog color.
    static var wsdoTprimarygreen25: SwiftUI.Color { .init(.wsdoTprimarygreen25) }

    /// The "WSDOTprimarygreen50" asset catalog color.
    static var wsdoTprimarygreen50: SwiftUI.Color { .init(.wsdoTprimarygreen50) }

    /// The "WSDOTprimarygreen75" asset catalog color.
    static var wsdoTprimarygreen75: SwiftUI.Color { .init(.wsdoTprimarygreen75) }

    /// The "WSDOTtext" asset catalog color.
    static var wsdoTtext: SwiftUI.Color { .init(.wsdoTtext) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "WSDOT-logo-black" asset catalog image.
    static var wsdotLogoBlack: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdotLogoBlack)
#else
        .init()
#endif
    }

    /// The "WSDOT-logo-white" asset catalog image.
    static var wsdotLogoWhite: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wsdotLogoWhite)
#else
        .init()
#endif
    }

    /// The "bridgealerttype" asset catalog image.
    static var bridgealerttype: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bridgealerttype)
#else
        .init()
#endif
    }

    /// The "closurealertseverity" asset catalog image.
    static var closurealertseverity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .closurealertseverity)
#else
        .init()
#endif
    }

    /// The "conealerttype" asset catalog image.
    static var conealerttype: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .conealerttype)
#else
        .init()
#endif
    }

    /// The "highalertseverity" asset catalog image.
    static var highalertseverity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .highalertseverity)
#else
        .init()
#endif
    }

    /// The "icBridgeAlerts" asset catalog image.
    static var icBridgeAlerts: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icBridgeAlerts)
#else
        .init()
#endif
    }

    /// The "icHomeAmtrakCascades" asset catalog image.
    static var icHomeAmtrakCascades: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icHomeAmtrakCascades)
#else
        .init()
#endif
    }

    /// The "icHomeBorderWaits" asset catalog image.
    static var icHomeBorderWaits: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icHomeBorderWaits)
#else
        .init()
#endif
    }

    /// The "icHomeFavorites" asset catalog image.
    static var icHomeFavorites: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icHomeFavorites)
#else
        .init()
#endif
    }

    /// The "icHomeFerries" asset catalog image.
    static var icHomeFerries: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icHomeFerries)
#else
        .init()
#endif
    }

    /// The "icHomeMyRoutes" asset catalog image.
    static var icHomeMyRoutes: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icHomeMyRoutes)
#else
        .init()
#endif
    }

    /// The "icHomePasses" asset catalog image.
    static var icHomePasses: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icHomePasses)
#else
        .init()
#endif
    }

    /// The "icHomeSocialMedia" asset catalog image.
    static var icHomeSocialMedia: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icHomeSocialMedia)
#else
        .init()
#endif
    }

    /// The "icHomeTollRates" asset catalog image.
    static var icHomeTollRates: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icHomeTollRates)
#else
        .init()
#endif
    }

    /// The "icHomeTraffic" asset catalog image.
    static var icHomeTraffic: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .icHomeTraffic)
#else
        .init()
#endif
    }

    /// The "legendinfoicon" asset catalog image.
    static var legendinfoicon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .legendinfoicon)
#else
        .init()
#endif
    }

    /// The "lowalertseverity" asset catalog image.
    static var lowalertseverity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .lowalertseverity)
#else
        .init()
#endif
    }

    /// The "maintenancealerttype" asset catalog image.
    static var maintenancealerttype: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .maintenancealerttype)
#else
        .init()
#endif
    }

    /// The "mediumalertseverity" asset catalog image.
    static var mediumalertseverity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mediumalertseverity)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "WSDOT-logo-black" asset catalog image.
    static var wsdotLogoBlack: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .wsdotLogoBlack)
#else
        .init()
#endif
    }

    /// The "WSDOT-logo-white" asset catalog image.
    static var wsdotLogoWhite: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .wsdotLogoWhite)
#else
        .init()
#endif
    }

    /// The "bridgealerttype" asset catalog image.
    static var bridgealerttype: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bridgealerttype)
#else
        .init()
#endif
    }

    /// The "closurealertseverity" asset catalog image.
    static var closurealertseverity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .closurealertseverity)
#else
        .init()
#endif
    }

    /// The "conealerttype" asset catalog image.
    static var conealerttype: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .conealerttype)
#else
        .init()
#endif
    }

    /// The "highalertseverity" asset catalog image.
    static var highalertseverity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .highalertseverity)
#else
        .init()
#endif
    }

    /// The "icBridgeAlerts" asset catalog image.
    static var icBridgeAlerts: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icBridgeAlerts)
#else
        .init()
#endif
    }

    /// The "icHomeAmtrakCascades" asset catalog image.
    static var icHomeAmtrakCascades: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icHomeAmtrakCascades)
#else
        .init()
#endif
    }

    /// The "icHomeBorderWaits" asset catalog image.
    static var icHomeBorderWaits: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icHomeBorderWaits)
#else
        .init()
#endif
    }

    /// The "icHomeFavorites" asset catalog image.
    static var icHomeFavorites: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icHomeFavorites)
#else
        .init()
#endif
    }

    /// The "icHomeFerries" asset catalog image.
    static var icHomeFerries: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icHomeFerries)
#else
        .init()
#endif
    }

    /// The "icHomeMyRoutes" asset catalog image.
    static var icHomeMyRoutes: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icHomeMyRoutes)
#else
        .init()
#endif
    }

    /// The "icHomePasses" asset catalog image.
    static var icHomePasses: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icHomePasses)
#else
        .init()
#endif
    }

    /// The "icHomeSocialMedia" asset catalog image.
    static var icHomeSocialMedia: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icHomeSocialMedia)
#else
        .init()
#endif
    }

    /// The "icHomeTollRates" asset catalog image.
    static var icHomeTollRates: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icHomeTollRates)
#else
        .init()
#endif
    }

    /// The "icHomeTraffic" asset catalog image.
    static var icHomeTraffic: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .icHomeTraffic)
#else
        .init()
#endif
    }

    /// The "legendinfoicon" asset catalog image.
    static var legendinfoicon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .legendinfoicon)
#else
        .init()
#endif
    }

    /// The "lowalertseverity" asset catalog image.
    static var lowalertseverity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .lowalertseverity)
#else
        .init()
#endif
    }

    /// The "maintenancealerttype" asset catalog image.
    static var maintenancealerttype: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .maintenancealerttype)
#else
        .init()
#endif
    }

    /// The "mediumalertseverity" asset catalog image.
    static var mediumalertseverity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mediumalertseverity)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

