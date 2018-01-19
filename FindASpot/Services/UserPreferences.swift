//
//  UserPreferences.swift
//  FindASpot
//
//  Created by Alex Paul on 1/19/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

struct UserKeys {
    static let currentLatitudeKey = "Current Latitude Key"
    static let currentLongitudeKey = "Current Longitude Key"
    static let currentAddressKey = "Current Address Key"
}

class UserPreference {
    private init(){}
    static let manager = UserPreference()
}

// MARK:- Setters
extension UserPreference {
    public func setLatitude(latitude: Double) {
        UserDefaults.standard.set(latitude, forKey: UserKeys.currentLatitudeKey)
    }
    
    public func setLongitude(longitude: Double) {
        UserDefaults.standard.set(longitude, forKey: UserKeys.currentLongitudeKey)
    }
    
    public func setAddress(address: String) {
        UserDefaults.standard.set(address, forKey: UserKeys.currentAddressKey)
    }
}

// MARK:- Getters
extension UserPreference {
    public func getLatitude() -> Double {
        guard let latitude = UserDefaults.standard.object(forKey: UserKeys.currentLatitudeKey) as? Double else { print("no stored latitude"); return 0.0 }
        return latitude
    }
    
    public func getLongitude() -> Double {
        guard let longitude = UserDefaults.standard.object(forKey: UserKeys.currentLongitudeKey) as? Double else { print("no stored longitude"); return 0.0 }
        return longitude
    }
    
    public func getAddress() -> String {
        guard let address = UserDefaults.standard.object(forKey: UserKeys.currentAddressKey) as? String else { print("no address found"); return "Queens, NY" }
        return address
    }
}
