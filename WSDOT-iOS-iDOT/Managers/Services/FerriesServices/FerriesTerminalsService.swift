//
//  FerriesTerminalsService.swift
//  WSDOT-iOS-iDOT
//
//  Wraps the WSDOT Ferries Terminals API:
//    https://www.wsdot.wa.gov/ferries/api/terminals/rest/help
//
//  Skeleton — endpoints will be filled in when the detail page needs
//  terminal-level data

import Foundation

class FerriesTerminalsService {

    static let shared = FerriesTerminalsService()
    private init() {}

    private let baseURL = "https://www.wsdot.wa.gov/ferries/api/terminals/rest"

    // TODO: getTerminalBasics() — /terminalbasics
    // TODO: getTerminalLocations() — /terminallocations
    // TODO: getTerminalWaitTimes() — /terminalwaittimes
    // TODO: getTerminalSailingSpace() — /terminalsailingspace
}
