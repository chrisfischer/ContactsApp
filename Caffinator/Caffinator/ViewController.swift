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
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    var detailsChildView: DetailsViewController?
    var menuChildView: MenuViewController?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var shopInfoView: UIView!
    @IBOutlet var mapPortraitConstraint: NSLayoutConstraint!
    
    var mapLandscapeContraint: NSLayoutConstraint?
    //var annotations = [ShopAnnotation]()
    
//    var annotationsSet = Set<ShopAnnotation>()
//    
//    // search
//    var matchingItems: [MKMapItem] = [MKMapItem]()
//    var lastSearchLocation: CLLocation?
    
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
        
        if (setUpFlag) {
            mapView.setRegion(region, animated: false)
            setUpFlag = false
        }
        
        mapView.addAnnotations(annotations!)
        
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
            annotationView?.canShowCallout = false // MARK: - TODO
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
        if UIDevice.current.orientation.isLandscape {
            return
        }
        
        view.alpha = 0.5
        detailsChildView?.shop = view.annotation as? ShopAnnotation
        menuChildView?.shop = view.annotation as? ShopAnnotation
        segmentedController.selectedSegmentIndex = 0
        detailsView.isHidden = false
        menuView.isHidden = true
        
        // show details pane
        UIView.animate(withDuration: 0.25) {
            self.mapPortraitConstraint.isActive = true
            self.mapLandscapeContraint?.isActive = false
            self.view.layoutIfNeeded()
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
    
    // MARK: - Updating annotations
    
    func updateShops(data: Data?) {
        ShopAnnotation.dataToShops(data)
        
//        let frequency = 20.0 // meters
//        let mapLocation = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
//        
//        if (mapLocation.distance(from: lastSearchLocation!) > frequency) {
//            search()
//        }
    }
    
//    func search() {
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = "coffee"
//        request.region = mapView.region
//        lastSearchLocation = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
//        
//        
//        let search = MKLocalSearch(request: request)
//        search.start { response, _ in
//            guard let response = response else {
//                return
//            }
//            self.matchingItems = response.mapItems
//            self.updateAnnotations(items: response.mapItems)
//            
//        }
//    }
    
//    func updateAnnotations(items: [MKMapItem]) {
//        var newAnnotations = Set<ShopAnnotation>()
//        for item in items {
//            let newAnnotation = ShopAnnotation(title: item.name ?? "", subtitle: item.placemark.title ?? "", coordinate: item.placemark.coordinate)
//            let newAnnotationView = MKPinAnnotationView(annotation: newAnnotation, reuseIdentifier: "coffeeAnnotation")
//            newAnnotations.insert(newAnnotationView.annotation as! ShopAnnotation)
//        }
//        newAnnotations.subtract(annotationsSet)
//        mapView.addAnnotations(Array(newAnnotations))
//        annotationsSet = annotationsSet.union(newAnnotations)
//    }
    
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

