//
//  WSDOTFeature.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 5/11/26.
//
import SwiftUI

struct WSDOTFeature: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let destination: AnyView

}
