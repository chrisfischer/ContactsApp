//
//  ViewController.swift
//  Caffinator
//
//  Created by Chris Fischer on 3/16/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var setUpFlag = true
    
    @IBOutlet weak var centerLocationButton: UIButton!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    var detailsChildView: DetailsViewController?
    var menuChildView: MenuViewController?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var shopInfoView: UIView!
    @IBOutlet var mapPortraitConstraint: NSLayoutConstraint!
    
    var mapLandscapeContraint: NSLayoutConstraint?
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.queryShopData(closure: updateShops)
        
        // contraint that will become active when phone is in landscape mode
        mapLandscapeContraint = NSLayoutConstraint(item: mapView, attribute:
            .height, relatedBy: .equal, toItem: view,
                     attribute: .height, multiplier: 1.0,
                     constant: 0)
        mapLandscapeContraint?.isActive = true
        mapPortraitConstraint.isActive = false
        hideDetails()
        
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
    }
    
    // MARK: - Rotation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            mapPortraitConstraint.isActive = false
            mapLandscapeContraint?.isActive = true
        } else {
            if !mapView.selectedAnnotations.isEmpty {
                mapPortraitConstraint.isActive = true
                mapLandscapeContraint?.isActive = false
            }
        }
    }
    
    // MARK: - CoreLocationDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: (locations.last?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        // center the user's location once at startup
        if (setUpFlag) {
            mapView.setRegion(region, animated: false)
            setUpFlag = false
        }
        
        // show the button if the user's location is not centered
        if (mapView.centerCoordinate.longitude != locations.last?.coordinate.longitude && mapView.centerCoordinate.latitude != locations.last?.coordinate.latitude) {
            centerLocationButton.isHidden = false
        }
        
        let mapLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        // only add annotations that are within 200 meters from the center of the map
        if let annotations = annotations {
            for annotation in annotations {
                let radius = 200.0 // meters
                
                let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                
                if (mapLocation.distance(from: annotationLocation) > radius) {
                    mapView.addAnnotation(annotation)
                }
            }
        }
        
        // remove annotations farther than 400 meters away from the center of the map
        for annotation in mapView.annotations {
            let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            if (mapLocation.distance(from: annotationLocation) > 400.0) {
                mapView.removeAnnotation(annotation)
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status != .authorizedWhenInUse) {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let reuseIdentifier = "coffeeAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = #imageLiteral(resourceName: "coffee_icon")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !(view.annotation is MKUserLocation) else {
            return
        }
        
        
        view.alpha = 0.5
        
        detailsChildView?.shop = view.annotation as? ShopAnnotation
        detailsChildView?.userLocation = mapView.userLocation.coordinate
        menuChildView?.shop = view.annotation as? ShopAnnotation
        
        segmentedController.selectedSegmentIndex = 0
        detailsView.isHidden = false
        menuView.isHidden = true
        
        if !UIDevice.current.orientation.isLandscape {
            
            // show details pane
            UIView.animate(withDuration: 0.25) {
                self.mapPortraitConstraint.isActive = true
                self.mapLandscapeContraint?.isActive = false
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.alpha = 1.0
        
        // hide details pane
        UIView.animate(withDuration: 0.25) {
            self.mapPortraitConstraint.isActive = false
            self.mapLandscapeContraint?.isActive = true
            self.view.layoutIfNeeded()
        }
        hideDetails()
        
    }
    
    func hideDetails() {
        detailsView.isHidden = true
        menuView.isHidden = true
    }
    
    func showDetails() {
        detailsView.isHidden = false
        menuView.isHidden = false
    }
    
    // MARK: - IBActions
    
    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            menuView.isHidden = true
            detailsView.isHidden = false
        case 1:
            menuView.isHidden = false
            detailsView.isHidden = true
        default:
            break;
        }
    }
    
    @IBAction func centerUserLocation(_ sender: Any) {
        mapView.centerCoordinate = mapView.userLocation.coordinate
        
        centerLocationButton.isHidden = true
    }
    
    
    // MARK: - Updating annotations
    
    func updateShops(data: Data?) {
        ShopAnnotation.dataToShops(data)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embededDetailsSegue" {
            if let dvc = segue.destination as?  DetailsViewController {
                detailsChildView = dvc
            }
        } else if segue.identifier == "embededMenuSegue" {
            if let dvc = segue.destination as?  MenuViewController {
                menuChildView = dvc
            }
        }
    }
    
}

