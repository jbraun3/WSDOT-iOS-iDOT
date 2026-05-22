//
//  SearchCompleter.swift
//  WSDOT-iOS-iDOT
//
//
// creating autocomplete options for route location search

import Combine
import MapKit

class SearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate{
    
    private let completer = MKLocalSearchCompleter()
    
    @Published var results: [MKLocalSearchCompletion] = []
    
    override init(){
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
    }
    
    func search(_ queary: String){
        completer.queryFragment = queary
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = Array(completer.results.prefix(5))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error){
        results = []
    }
}
