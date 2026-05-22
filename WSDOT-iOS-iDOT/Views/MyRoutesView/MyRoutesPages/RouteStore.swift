//
//  RouteStore.swift
//  WSDOT-iOS-iDOT
//
//
// store routes 

import Foundation
import Combine

class RouteStore: ObservableObject{
    @Published var savedRoutes: [SavedRoute] = []
}
