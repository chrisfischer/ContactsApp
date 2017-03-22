//
//  NetworkManager.swift
//  Caffinator
//
//  Created by Chris Fischer on 3/21/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//
import Foundation

class NetworkManager {
    
    static func queryShopData (closure: @escaping (Data?) -> Void) {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        var dataTask: URLSessionDataTask?
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        let url = URL(string: "https://gist.githubusercontent.com/chrisfischer/1b68e04fb13c4375b76df3d7614257c5/raw/886817c35afcf9bf1ca746dc9c81a7c528f872f4/shopData.json")
        
        dataTask = defaultSession.dataTask(with: url!, completionHandler: {
            data, response, error in
            if error != nil {
                
                print(error!.localizedDescription)
                closure(nil)
                
            } else if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200 {
                    
                    if let shopData = data {
                        closure(shopData)
                    }
                    
                }
            }
        })
        
        dataTask?.resume()
    }
}
