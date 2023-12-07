//
//  LocationManager.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation
import CoreLocation

/* Wrapper & manager for Core Location */
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isAllowed = false
    @Published var location: CLLocationCoordinate2D?
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        print(locationManager.location!)
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func checkLocationAuthorization() {
        authorizationStatus = CLLocationManager.authorizationStatus()
        
        switch authorizationStatus {
        case .notDetermined:
            requestLocationAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            isAllowed = true
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            isAllowed = true
        case .authorized:
            locationManager.startUpdatingLocation()
            isAllowed = true
        @unknown default:
            break
        }
    }
    
}
