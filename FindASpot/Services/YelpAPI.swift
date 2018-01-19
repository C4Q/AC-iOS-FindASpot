//
//  YelpAPI.swift
//  FindASpot
//
//  Created by Alex Paul on 1/19/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation
import CoreLocation

class YelpAPI {
    static let urlSession = URLSession(configuration: .default)
    
    static func searchVenue(placename: String, addressString: String?, coordinate: CLLocationCoordinate2D?,  completion: @escaping (Error?, [Place]?) -> Void) {
        
        var urlRequest: URLRequest!
        
        //var urlRequest = URLRequest(url: URL(string:"\(YelpAPIKeys.baseSearchURL)\(placename)&location=11375")!)
        
        // using an address
        if let address = addressString { // e.g "Queens, NY"
            urlRequest = URLRequest(url: URL(string:"\(YelpAPIKeys.baseSearchURL)\(placename)&location=\(address)")!)
        }
        
        // use coordinate
        else {
            let coordinate = CLLocationCoordinate2DMake(UserPreference.manager.getLatitude(), UserPreference.manager.getLongitude())
            urlRequest = URLRequest(url: URL(string:"\(YelpAPIKeys.baseSearchURL)\(placename)&latitude=\(coordinate.latitude)&longitude=\(coordinate.longitude)")!)
        }
        
        
        // TODO: we could have an addressString or coordinate
        // TODO: coordinate is user location coordinate
        // TODO: update our location with coordinate
        
        urlRequest.setValue("Bearer \(YelpAPIKeys.apiKey)", forHTTPHeaderField: "Authorization")
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(Results.self, from: data)
                    let places = results.businesses // an array of places
                    completion(nil, places)
                } catch {
                    print("decoding error: \(error)")
                    completion(error, nil)
                }
            }
        }.resume()
    }
}
