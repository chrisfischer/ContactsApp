//
//  DetailsViewController.swift
//  Caffinator
//
//  Created by Chris Fischer on 3/19/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    var userLocation: CLLocationCoordinate2D? {
        didSet {
            if let userLocation = userLocation {
                let request = MKDirectionsRequest()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation, addressDictionary: nil))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: (shop?.coordinate)!, addressDictionary: nil))
                request.transportType = .walking
                request.requestsAlternateRoutes = false
                let directions = MKDirections(request: request)
                directions.calculate { response, error in
                    if let route = response?.routes.first, error == nil {
                        self.etaLabel.text = "\(Int(route.distance * 3.28084)) ft away, \(Int(route.expectedTravelTime / 60)) min walk"
                    }
                }
            }

        }
    }
    
    var shop: ShopAnnotation? {
        didSet {
            shopNameLabel.text = shop?.title
            addressLabel.text = shop?.subtitle
            phoneTextView.text = shop?.phone
            openTimeLabel.text = "Opened At: " + (shop?.openHour)! + ":00 AM"
            var closeTime = Int((shop?.closeHour)!)!
            if closeTime > 12 {
                closeTime = closeTime - 12
                closeTimeLabel.text = "Closed At: " + String(closeTime) + ":00 PM"
            } else {
                closeTimeLabel.text = "Closed At: " + String(closeTime) + ":00 AM"
            }
            
        }
    }
    
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var closeTimeLabel: UILabel!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var etaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToMaps(_ sender: Any) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        let placemark = MKPlacemark(coordinate: (shop?.coordinate)!, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = shop?.title
        mapItem.openInMaps(launchOptions: options)
    }
    
}
