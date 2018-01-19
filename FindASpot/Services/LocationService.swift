//
//  LocationService.swift
//  FindASpot
//
//  Created by Alex Paul on 1/19/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {    
    // singleton manager
    // NB: Apple highly recommends having one instance of the location manager
    private override init(){
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    static let manager = LocationService()
    private var locationManager: CLLocationManager!
}

// MARK: Helper Functions
extension LocationService {
    public func checkForLocationServices() -> CLAuthorizationStatus {
        var status: CLAuthorizationStatus!
        // check if location services is enabled
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined: // intial state on first launch
                    print("not determined")
                    locationManager.requestWhenInUseAuthorization()
                case .denied: // user could potentially deny access
                    print("denied")
                case .authorizedAlways:
                    print("authorizedAlways")
                case .authorizedWhenInUse:
                    print("authorizedWhenInUse")
                default:
                    break
            }
        }
        else {
            // update UI accordinly
            status = CLLocationManager.authorizationStatus()
        }
        status = CLLocationManager.authorizationStatus()
        return status
    }
    
}

// MARK: CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations: \(locations)")
        
        guard let location = locations.last else { print("no location data"); return }
        
        // update user preferences
        UserPreference.manager.setLatitude(latitude: location.coordinate.latitude)
        UserPreference.manager.setLongitude(longitude: location.coordinate.longitude)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization: \(status)") // e.g .denied, .notDetermined
    }
}
