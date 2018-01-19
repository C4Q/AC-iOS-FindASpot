//
//  DetailViewController.swift
//  FindASpot
//
//  Created by Alex Paul on 1/19/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {
    
    private var place: Place!
    
    init(place: Place) {
        super.init(nibName: nil, bundle: nil)
        self.place = place
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        configureNavBar()
        
        // FOR TESTING PURPOSES ONLY - THIS SHOULD BE IN A VIEW CLASS
        // create a button in the center of the view
        let directionsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        directionsButton.center = view.center
        directionsButton.setTitle("Get Directions", for: .normal)
        directionsButton.addTarget(self, action: #selector(showDirections), for: .touchUpInside)
        view.addSubview(directionsButton)
        
    }
    
    @objc private func showDirections() {
        let userCoordinate = CLLocationCoordinate2DMake(UserPreference.manager.getLatitude(), UserPreference.manager.getLongitude())
        let placeCoordinate = CLLocationCoordinate2DMake(place.coordinates.latitude, place.coordinates.longitude)
        
        let directionsURLString = "http://maps.apple.com/?saddr=\(userCoordinate.latitude),\(userCoordinate.longitude)&daddr=\(placeCoordinate.latitude),\(placeCoordinate.longitude)"
        
        UIApplication.shared.open(URL(string: directionsURLString)!, options: [:]) { (done) in
            print("launched apple maps")
        }
    }
    
    private func configureNavBar() {
        navigationItem.title = place.name
        navigationItem.largeTitleDisplayMode = .always
    }
}
