//
//  PlaceViewController.swift
//  FindASpot
//
//  Created by Alex Paul on 1/19/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import MapKit

class PlaceViewController: UIViewController {
    
    let placeView = PlaceView()
    
    var currentSelectedPlace: Place!
    
    private var places = [Place]() {
        didSet {
            // creating annotations
            for place in places {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(place.coordinates.latitude, place.coordinates.longitude)
                annotation.title = place.name
                annotations.append(annotation)
            }
            // adding annotations to mapview - update ui
            DispatchQueue.main.async {
                self.placeView.mapView.addAnnotations(self.annotations)
                self.placeView.mapView.showAnnotations(self.annotations, animated: true)
            }
        }
    }
    
    private var annotations = [MKAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(placeView)
        placeView.mapView.delegate = self
        
        // set the two search bar delegates
        placeView.venueSearchBar.delegate = self
        placeView.locationSearchBar.delegate = self
        
        configureNavBar()
        
        let _ = LocationService.manager.checkForLocationServices()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Find A Spot"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = placeView.venueSearchBar
    }
}

// MARK:- MKMapViewDelegate
extension PlaceViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // show user blue default dot
        if annotation is MKUserLocation {
            return nil
        }
        
        // setup annotation view for map
        // we can fully customize the marker annotation view
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceAnnotationView") as? MKMarkerAnnotationView
        if annotationView == nil { // setup annotation view
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PlaceAnnotationView")
            annotationView?.canShowCallout = true
            
            let index = annotations.index{$0 === annotation}
            if let annotationIndex = index {
                let place = places[annotationIndex]
                annotationView?.glyphText = place.price
            }
            
            
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // find place selected
        
        let index = annotations.index{$0 === view.annotation}
        guard let annotationIndex = index else { print("index is nil"); return }
        let place = places[annotationIndex]
        
        currentSelectedPlace = place
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let detailVC = DetailViewController(place: currentSelectedPlace)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension PlaceViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // validate venue search
        guard let text = placeView.venueSearchBar.text else { print("venue search is nil"); return }
        guard !text.isEmpty else { print("venue text is empty"); return }
        guard let encodedVenueSearch = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { print("spaces not allowed"); return }
        
        // check for empty address field. i.e placeholder text
        var address: String!
        if let value = placeView.locationSearchBar.text {
            if value.isEmpty {
                address = nil
            } else {
                address = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            }
        }
    
        // calls out Yelp API with search query
        YelpAPI.searchVenue(placename: encodedVenueSearch, addressString: address, coordinate: nil) { (error, places) in
            if let error = error {
                // TODO: handle error
                print(error)
            } else if let places = places {
                DispatchQueue.main.async {
                    // housecleaning
                    self.places.removeAll()
                    self.placeView.mapView.removeAnnotations(self.annotations)
                    self.annotations.removeAll()
                    self.places = places
                }
            }
        }
    }
}





