//
//  CodableCoord.swift
//  Planter
//
//  Created by Kory Arfania on 12/4/23.
//

import Foundation
import CoreLocation

// CodableCoord: wrapper for CLLocationCoordinate2D to enable encode/decode functionality
struct CodableCoord: Codable {
    var lat: CLLocationDegrees
    var long: CLLocationDegrees
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.lat = coordinate.latitude
        self.long = coordinate.longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
