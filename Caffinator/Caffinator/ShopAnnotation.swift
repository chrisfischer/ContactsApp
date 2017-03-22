//
//  Shop.swift
//  Caffinator
//
//  Created by Chris Fischer on 3/16/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import MapKit
import CoreLocation

var annotations: [ShopAnnotation]? = [ShopAnnotation]()

class ShopAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var phone: String?
    var openHour: String?
    var closeHour: String?
    var menu: [[String: String]]?
    
    init(title: String, coordinate: CLLocationCoordinate2D, address: String, phone: String, openHour: String, closeHour: String, menu: [[String: String]]) {
        
        self.title = title
        self.coordinate = coordinate
        self.subtitle = address
        self.phone = phone
        self.openHour = openHour
        self.closeHour = closeHour
        self.menu = menu
    }
    
    
    // had these functions because I was originally using Apple's search interface and needed to avoid duplicates
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? ShopAnnotation {
            return self.coordinate.latitude == object.coordinate.latitude && self.coordinate.longitude == object.coordinate.longitude
        } else {
            return false
        }
    }
    
    override var hash: Int {
        return (String(coordinate.latitude) + String(coordinate.longitude)).hashValue
    }
    
    static func dataToShops(_ data : Data?) {

        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                
                // Get the results array
                if let array: AnyObject = response["locations"] {
                    for shopDictonary in array as! [AnyObject] {
                        if let shopDictonary = shopDictonary as? [String: AnyObject] {
                            // Parse the search result
                            let name = shopDictonary["name"] as? String
                            let address = shopDictonary["address"] as? String
                            let phone = shopDictonary["phone"] as? String
                            let openHour = shopDictonary["openHour"] as? String
                            let closeHour = shopDictonary["closeHour"] as? String
                            
                            var menu = [[String: String]]()
                            
                            if let menuArray = shopDictonary["menu"] as? [[String: String]] {
                                menu = menuArray
                            }
                            
                            let geoCoder = CLGeocoder()
                            geoCoder.geocodeAddressString(address!, completionHandler: { (placemarks, error) -> Void in
                                if error == nil, let placemarks = placemarks {
                                    if placemarks.count != 0 {
                                        let coordinate = placemarks.first?.location?.coordinate
                                        
                                        annotations?.append(ShopAnnotation(title: name!, coordinate: coordinate!, address: address!, phone: phone!, openHour: openHour!, closeHour: closeHour!, menu: menu))
                                    }
                                }
                            })
                            
                            
                        } else {
                            print("Not a dictionary")
                        }
                    }
                } else {
                    print("Results key not found in dictionary")
                }
                
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
            annotations = nil
        }
        
    }

}
