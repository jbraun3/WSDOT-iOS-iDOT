import Testing
import Foundation
import CoreLocation
import SwiftUI
@testable import WSDOT_iOS_iDOT

@MainActor
struct WSDOT_iOS_iDOTTests {

    // MARK: - Traffic Map Tests

    @Test("TrafficCameraItem decodes from JSON")
    func trafficCameraDecoding() {
        let json = """
        {
            "id": 100,
            "url": "https://images.wsdot.wa.gov/nw/005vc16324.jpg",
            "title": "I-5 at Northgate",
            "roadName": "I-5",
            "direction": "N",
            "milepost": 172.5,
            "lat": 47.706,
            "lon": -122.327,
            "video": 0
        }
        """.data(using: .utf8)!
        let camera = try! JSONDecoder().decode(TrafficCameraItem.self, from: json)

        #expect(camera.id == 100)
        #expect(camera.title == "I-5 at Northgate")
        #expect(camera.roadName == "I-5")
        #expect(camera.direction == "N")
        #expect(camera.milepost == 172.5)
        #expect(camera.lat == 47.706)
        #expect(camera.lon == -122.327)
        #expect(camera.video == 0)
        #expect(camera.isVideo == false)
    }

    
    @Test("TrafficCameraItem directionDisplay maps correctly")
    func trafficCameraDirectionDisplay() {
        let base = """
        {"id":1,"url":"","title":"","roadName":"","milepost":0,"lat":0,"lon":0,"video":0}
        """
        let decoder = JSONDecoder()

        let cases: [(String, String)] = [
            ("N", "North"), ("S", "South"), ("E", "East"),
            ("W", "West"), ("B", "This camera moves to point in more than one direction.")
        ]
        for (code, expected) in cases {
            let json = base.replacingOccurrences(
                of: "\"roadName\":\"\"",
                with: "\"roadName\":\"\",\"direction\":\"\(code)\""
            )
            let camera = try! decoder.decode(TrafficCameraItem.self, from: json.data(using: .utf8)!)
            #expect(camera.directionDisplay == expected)
        }
    }

    @Test("TrafficCameraItem coordinate returns correct CLLocationCoordinate2D")
    func trafficCameraCoordinate() {
        let json = """
        {"id":2,"url":"","title":"","roadName":"","milepost":0,"lat":47.5,"lon":-122.3,"video":0}
        """.data(using: .utf8)!
        let camera = try! JSONDecoder().decode(TrafficCameraItem.self, from: json)
        #expect(camera.coordinate.latitude == 47.5)
        #expect(camera.coordinate.longitude == -122.3)
    }
    
    @Test("CamerasResponse decodes nested camera list")
    func camerasResponseDecoding() {
        let json = """
        {
            "cameras": {
                "items": [
                    {"id":1,"url":"","title":"Cam1","roadName":"I-5","milepost":10,"lat":47,"lon":-122,"video":0},
                    {"id":2,"url":"","title":"Cam2","roadName":"I-5","milepost":20,"lat":48,"lon":-123,"video":1}
                ]
            }
        }
        """.data(using: .utf8)!
        let response = try! JSONDecoder().decode(CamerasResponse.self, from: json)
        #expect(response.cameras.items.count == 2)
        #expect(response.cameras.items[0].title == "Cam1")
        #expect(response.cameras.items[1].isVideo == true)
    }

    @Test("HighwayAlertItem decodes from JSON")
    func highwayAlertDecoding() {
        let json = """
        {
            "AlertID": 5001,
            "Priority": "High",
            "Region": "Northwest",
            "EventCategory": "Incident",
            "EventCategoryType": "Incident",
            "EventCategoryTypeDescription": "Incident",
            "HeadlineDescription": "Collision on I-5 southbound at MP 172",
            "ExtendedDescription": "Right lane blocked",
            "EventStatus": "Active",
            "County": "King",
            "TravelCenterPriorityId": 2,
            "DisplayLatitude": 47.706,
            "DisplayLongitude": -122.327,
            "StartRoadwayLocation": {
                "RoadName": "I-5",
                "Direction": "Southbound",
                "Latitude": 47.706,
                "Longitude": -122.327,
                "MilePost": 172.0
            },
            "EndRoadwayLocation": null,
            "LastUpdatedTime": "/Date(1700000000000)/",
            "StartTime": "/Date(1699000000000)/",
            "EndTime": null
        }
        """.data(using: .utf8)!
        let alert = try! JSONDecoder().decode(HighwayAlertItem.self, from: json)

        #expect(alert.alertId == 5001)
        #expect(alert.priority == "High")
        #expect(alert.region == "Northwest")
        #expect(alert.eventCategoryType == "Incident")
        #expect(alert.headlineDescription == "Collision on I-5 southbound at MP 172")
        #expect(alert.extendedDescription == "Right lane blocked")
        #expect(alert.county == "King")
        #expect(alert.travelCenterPriorityId == 2)
        #expect(alert.displayLatitude == 47.706)
        #expect(alert.displayLongitude == -122.327)
        #expect(alert.roadName == "I-5")
        #expect(alert.startDirection == "Southbound")
        #expect(alert.hasValidLocation == true)
    }

    @Test("HighwayAlertItem hasValidLocation returns false for 0,0")
    func highwayAlertInvalidLocation() {
        let json = """
        {
            "AlertID": 1, "Priority": "", "Region": "",
            "EventCategory": "", "EventCategoryType": "",
            "EventCategoryTypeDescription": "", "HeadlineDescription": "",
            "TravelCenterPriorityId": 4,
            "DisplayLatitude": 0, "DisplayLongitude": 0,
            "StartRoadwayLocation": {
                "RoadName": "", "Direction": "", "Latitude": 0, "Longitude": 0
            },
            "LastUpdatedTime": "", "StartTime": ""
        }
        """.data(using: .utf8)!
        let alert = try! JSONDecoder().decode(HighwayAlertItem.self, from: json)
        #expect(alert.hasValidLocation == false)
    }

    @Test("HighwayAlertItem mapIconName maps priority and category correctly")
    func highwayAlertMapIcon() {
        let base = """
        {"AlertID":1,"Priority":"","Region":"","EventCategory":"","EventCategoryType":"__CAT__","EventCategoryTypeDescription":"","HeadlineDescription":"","TravelCenterPriorityId":__PRI__,"DisplayLatitude":47,"DisplayLongitude":-122,"StartRoadwayLocation":{"RoadName":"","Direction":"","Latitude":0,"Longitude":0},"LastUpdatedTime":"","StartTime":""}
        """
        let decoder = JSONDecoder()

        let cases: [(Int, String, String)] = [
            (1, "Construction", "constructionClosureAlert"),
            (2, "Construction", "constructionHighAlert"),
            (3, "Construction", "constructionMediumAlert"),
            (4, "Construction", "constructionLowAlert"),
            (1,  "Incident", "incidentClosureAlert"),
            (2,  "Incident", "incidentHighAlert"),
            (3,  "Incident", "incidentMediumAlert"),
            (4,  "Incident", "incidentLowAlert"),
        ]

        for (priority, category, expected) in cases {
            let raw = base
                .replacingOccurrences(of: "__PRI__", with: "\(priority)")
                .replacingOccurrences(of: "__CAT__", with: category)
            let alert = try! decoder.decode(HighwayAlertItem.self, from: raw.data(using: .utf8)!)
            #expect(alert.mapIconName == expected)
        }
    }

    @Test("HighwayAlertItem parseDotNetDate returns correct date")
    func highwayAlertDotNetDateParsing() {
        let json = """
        {
            "AlertID": 1, "Priority": "", "Region": "",
            "EventCategory": "", "EventCategoryType": "",
            "EventCategoryTypeDescription": "", "HeadlineDescription": "",
            "TravelCenterPriorityId": 4,
            "DisplayLatitude": 47, "DisplayLongitude": -122,
            "StartRoadwayLocation": {"RoadName":"","Direction":"","Latitude":0,"Longitude":0},
            "LastUpdatedTime": "/Date(1700000000000)/",
            "StartTime": "/Date(1700000000000)/"
        }
        """.data(using: .utf8)!
        let alert = try! JSONDecoder().decode(HighwayAlertItem.self, from: json)
        #expect(alert.lastUpdatedDate != nil)
        #expect(alert.lastUpdatedDate!.timeIntervalSince1970 == 1700000000)
    }

    @Test("RestAreaItem decodes from JSON in bundle format")
    func restAreaDecoding() {
        let json = """
        {
            "route": "I-5",
            "location": "North Creek",
            "description": "Milepost 23",
            "milepost": 23,
            "direction": "Northbound",
            "latitude": "47.85",
            "longitude": "-122.20",
            "notes": null,
            "hasDump": true,
            "isOpen": true,
            "amenities": ["Restrooms", "Picnic Areas"]
        }
        """.data(using: .utf8)!
        let area = try! JSONDecoder().decode(RestAreaItem.self, from: json)

        #expect(area.route == "I-5")
        #expect(area.location == "North Creek")
        #expect(area.milepost == 23)
        #expect(area.direction == "Northbound")
        #expect(area.hasDump == true)
        #expect(area.isOpen == true)
        #expect(area.amenities.count == 2)
        #expect(area.amenities.first == "Restrooms")
        #expect(area.coordinate.latitude == 47.85)
        #expect(area.coordinate.longitude == -122.20)
    }

    @Test("RestAreaItem id is unique compound key")
    func restAreaId() {
        let a = """
        {"route":"I-5","location":"A","description":"","milepost":10,"direction":"NB","latitude":"0","longitude":"0","hasDump":false,"isOpen":true,"amenities":[]}
        """.data(using: .utf8)!
        let b = """
        {"route":"I-5","location":"B","description":"","milepost":10,"direction":"SB","latitude":"0","longitude":"0","hasDump":false,"isOpen":true,"amenities":[]}
        """.data(using: .utf8)!
        let area1 = try! JSONDecoder().decode(RestAreaItem.self, from: a)
        let area2 = try! JSONDecoder().decode(RestAreaItem.self, from: b)
        #expect(area1.id != area2.id)
    }

    @Test("TravelTime decodes from JSON")
    func travelTimeDecoding() {
        let json = """
        {
            "TravelTimeID": 101,
            "Name": "I-5 North: Seattle to Lynnwood",
            "AverageTime": 20,
            "CurrentTime": 25,
            "Description": "I-5 Northbound",
            "Distance": 14.5,
            "StartPoint": {
                "Description": "Seattle",
                "Direction": "Northbound",
                "Latitude": 47.61,
                "Longitude": -122.34,
                "MilePost": 165.0,
                "RoadName": "I-5"
            },
            "EndPoint": {
                "Description": "Lynnwood",
                "Direction": "Northbound",
                "Latitude": 47.82,
                "Longitude": -122.31,
                "MilePost": 179.0,
                "RoadName": "I-5"
            },
            "TimeUpdated": "2026-05-29T10:00:00"
        }
        """.data(using: .utf8)!
        let time = try! JSONDecoder().decode(TravelTime.self, from: json)

        #expect(time.id == 101)
        #expect(time.name == "I-5 North: Seattle to Lynnwood")
        #expect(time.avgTime == 20)
        #expect(time.currentTime == 25)
        #expect(time.description == "I-5 Northbound")
        #expect(time.dist == 14.5)
        #expect(time.startPoint.description == "Seattle")
        #expect(time.endPoint.description == "Lynnwood")
    }

    // MARK: - My Routes Tests

    @Test("SavedRoute model creates correctly")
    func savedRouteCreation() {
        let id = UUID()
        let start = CLLocationCoordinate2D(latitude: 47.61, longitude: -122.34)
        let end = CLLocationCoordinate2D(latitude: 47.82, longitude: -122.31)

        let route = SavedRoute(
            id: id, name: "Seattle → Lynnwood",
            startLocationName: "Seattle", startLocation: start,
            endLocationName: "Lynnwood", endLocation: end
        )

        #expect(route.id == id)
        #expect(route.name == "Seattle → Lynnwood")
        #expect(route.startLocationName == "Seattle")
        #expect(route.endLocationName == "Lynnwood")
        #expect(route.startLatitude == 47.61)
        #expect(route.startLongitude == -122.34)
        #expect(route.endLatitude == 47.82)
        #expect(route.endLongitude == -122.31)
    }

    @Test("SavedRoute start/end computed properties return correct coordinates")
    func savedRouteCoordinates() {
        let route = SavedRoute(
            id: UUID(), name: "",
            startLocationName: "",
            startLocation: CLLocationCoordinate2D(latitude: 47.0, longitude: -122.0),
            endLocationName: "",
            endLocation: CLLocationCoordinate2D(latitude: 48.0, longitude: -123.0)
        )
        #expect(route.start.latitude == 47.0)
        #expect(route.start.longitude == -122.0)
        #expect(route.end.latitude == 48.0)
        #expect(route.end.longitude == -123.0)
    }

    @Test("FavoriteItem model creates correctly")
    func favoriteItemCreation() {
        let fav = FavoriteItem(category: .trafficCamera, itemId: "100", title: "I-5 at Northgate", subtitle: "I-5")
        #expect(fav.category == .trafficCamera)
        #expect(fav.itemId == "100")
        #expect(fav.title == "I-5 at Northgate")
        #expect(fav.subtitle == "I-5")
    }

    @Test("FavoriteCategory label and icon map correctly")
    func favoriteCategoryMappings() {
        let cases: [(FavoriteCategory, String, String)] = [
            (.mountainPass, "Mountain Passes", "icHomePasses"),
            (.trafficCamera, "Traffic Cameras", "icHomeTraffic"),
            (.borderWait, "Border Waits", "icHomeBorderWaits"),
            (.travelTime, "Travel Times", "icHomeMyRoutes"),
            (.tollRate, "Toll Rates", "icHomeTollRates"),
            (.route, "My Routes", "icHomeMyRoutes"),
            (.ferryRoute, "Ferries", "icHomeFerries"),
        ]
        for (cat, label, icon) in cases {
            #expect(cat.label == label)
            #expect(cat.icon == icon)
        }
    }

    @Test("HighwayAlertItem isActive uses parseDotNetDate")
    func alertIsActive() throws {
        let now = Date()
        let startMs = Int64((now.timeIntervalSince1970 - 86400) * 1000)
        let endMs   = Int64((now.timeIntervalSince1970 + 2 * 86400) * 1000)

        let json = """
        {
            "AlertID": 1, "Priority": "", "Region": "",
            "EventCategory": "", "EventCategoryType": "",
            "EventCategoryTypeDescription": "", "HeadlineDescription": "",
            "TravelCenterPriorityId": 4,
            "DisplayLatitude": 47, "DisplayLongitude": -122,
            "StartRoadwayLocation": {"RoadName":"","Direction":"","Latitude":0,"Longitude":0},
            "LastUpdatedTime": "/Date(\(startMs))/",
            "StartTime": "/Date(\(startMs))/",
            "EndTime": "/Date(\(endMs))/"
        }
        """.data(using: .utf8)!
        let alert = try JSONDecoder().decode(HighwayAlertItem.self, from: json)
        #expect(alert.isActive)
    }

    // MARK: - Ferries Tests

    @Test("FerryRoute decodes from JSON")
    func ferryRouteDecoding() {
        let json = """
        {
            "RouteID": 100,
            "RouteAbbrev": "SEA-BI",
            "Description": "Seattle / Bainbridge Island",
            "RegionID": 1,
            "CrossingTime": "35",
            "ReservationFlag": false,
            "InternationalFlag": false,
            "PassengerOnlyFlag": false,
            "AdaNotes": null,
            "GeneralRouteNotes": "General notes",
            "SeasonalRouteNotes": null
        }
        """.data(using: .utf8)!
        let route = try! JSONDecoder().decode(FerryRoute.self, from: json)

        #expect(route.routeID == 100)
        #expect(route.routeAbbrev == "SEA-BI")
        #expect(route.description == "Seattle / Bainbridge Island")
        #expect(route.regionID == 1)
        #expect(route.crossingTime == "35")
        #expect(route.reservationFlag == false)
        #expect(route.internationalFlag == false)
        #expect(route.passengerOnlyFlag == false)
        #expect(route.generalRouteNotes == "General notes")
        #expect(route.seasonalRouteNotes == nil)
    }

    @Test("FerryRoute displayName joins with ↔ symbol")
    func ferryRouteDisplayName() {
        let json = """
        {"RouteID":1,"RouteAbbrev":"SEA-BI","Description":"Seattle / Bainbridge Island","RegionID":1,"CrossingTime":"35"}
        """.data(using: .utf8)!
        let route = try! JSONDecoder().decode(FerryRoute.self, from: json)
        #expect(route.displayName == "Seattle ↔ Bainbridge Island")
    }

    @Test("FerryRoute displayName returns raw description when no slash separator")
    func ferryRouteDisplayNameNoSlash() {
        let json = """
        {"RouteID":2,"RouteAbbrev":"PTA","Description":"Port Townsend","RegionID":1,"CrossingTime":"20"}
        """.data(using: .utf8)!
        let route = try! JSONDecoder().decode(FerryRoute.self, from: json)
        #expect(route.displayName == "Port Townsend")
    }

    @Test("FerryRoute crossingTimeDisplay formats minutes correctly")
    func ferryRouteCrossingTimeDisplay() {
        let pairs: [(String?, String)] = [
            ("35", "~35 min"),
            ("120", "~2 hr"),
            ("90", "~1 hr 30 min"),
            ("60", "~1 hr"),
            (nil, "—"),
            ("", "—"),
        ]
        for (input, expected) in pairs {
            let json: String
            if let val = input {
                json = """
                {"RouteID":1,"RouteAbbrev":"X","Description":"A / B","RegionID":1,"CrossingTime":"\(val)"}
                """
            } else {
                json = """
                {"RouteID":1,"RouteAbbrev":"X","Description":"A / B","RegionID":1,"CrossingTime":null}
                """
            }
            let route = try! JSONDecoder().decode(FerryRoute.self, from: json.data(using: .utf8)!)
            #expect(route.crossingTimeDisplay == expected)
        }
    }


    @Test("FerriesScheduleService decodes a real-shaped /routedetails response")
    func ferriesScheduleResponseDecoding() throws {
        let json = """
        [
            {
                "RouteID": 14,
                "RouteAbbrev": "sea-bi",
                "Description": "Seattle / Bainbridge Island",
                "RegionID": 1,
                "VesselWatchID": 1,
                "ReservationFlag": false,
                "InternationalFlag": false,
                "PassengerOnlyFlag": false,
                "CrossingTime": "35",
                "AdaNotes": null,
                "GeneralRouteNotes": "ADA accessible.",
                "SeasonalRouteNotes": null
            },
            {
                "RouteID": 5,
                "RouteAbbrev": "ed-king",
                "Description": "Edmonds / Kingston",
                "RegionID": 1,
                "VesselWatchID": 2,
                "ReservationFlag": false,
                "InternationalFlag": false,
                "PassengerOnlyFlag": false,
                "CrossingTime": "30",
                "AdaNotes": null,
                "GeneralRouteNotes": null,
                "SeasonalRouteNotes": null
            },
            {
                "RouteID": 9,
                "RouteAbbrev": "pt-key",
                "Description": "Port Townsend / Coupeville",
                "RegionID": 1,
                "VesselWatchID": 4,
                "ReservationFlag": true,
                "InternationalFlag": false,
                "PassengerOnlyFlag": false,
                "CrossingTime": "35",
                "AdaNotes": null,
                "GeneralRouteNotes": "Reservations recommended.",
                "SeasonalRouteNotes": "Reduced schedule in winter."
            }
        ]
        """.data(using: .utf8)!

        let routes = try JSONDecoder().decode([FerryRoute].self, from: json)
        
        // round trip array
        #expect(routes.count == 3)

        let seattle = try #require(routes.first { $0.routeID == 14 })
        #expect(seattle.description == "Seattle / Bainbridge Island")
        #expect(seattle.routeAbbrev == "sea-bi")
        #expect(seattle.crossingTime == "35")
        #expect(seattle.reservationFlag == false)
        #expect(seattle.generalRouteNotes == "ADA accessible.")
        #expect(seattle.adaNotes == nil)
        #expect(seattle.seasonalRouteNotes == nil)

        #expect(seattle.displayName == "Seattle ↔ Bainbridge Island")
        #expect(seattle.crossingTimeDisplay == "~35 min")

        let portTownsend = try #require(routes.first { $0.routeID == 9 })
        #expect(portTownsend.reservationFlag == true)
        #expect(portTownsend.seasonalRouteNotes == "Reduced schedule in winter.")
    }

    // MARK: - Shared / Cross-Feature Tests - used throughout entire project
    @Test("WSDOTStyle formatting constants are non-zero")
    func wsdotStyleConstants() {
        #expect(WSDOTStyle.cardCornerRadius > 0)
        #expect(WSDOTStyle.cardShadowRadius > 0)
        #expect(WSDOTStyle.featureButtonSize > 0)
        #expect(WSDOTStyle.featureIconSize > 0)
        #expect(WSDOTStyle.featureLabelSize > 0)
    }

    @Test("Map Shows up on screen")
    func wsdotFeatureIdentifiable() {
        let feature = WSDOTFeature(icon: "map.fill", label: "Test", destination: AnyView(EmptyView()))
        #expect(feature.icon == "map.fill")
        #expect(feature.label == "Test")
    }
}
