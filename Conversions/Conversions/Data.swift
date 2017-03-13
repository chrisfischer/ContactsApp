//
//  Data.swift
//  Conversions
//
//  Created by Q Kalantary on 9/4/16.
//  Copyright © 2016 CIS 195 University of Pennsylvania. All rights reserved.
//

import Foundation

// Setup hard coded exchange rates

// Relative to the USD
let exchangeRates: [String: Double] = [ "USD": 1, "Euro": 0.94, "British Pound": 0.79, "Japanese Yen": 114.43 ]

let currencyArr = Array(exchangeRates.keys)

class Data {
    static func getExchangeRate(inputUnit: String, outputUnit: String) -> Double {
        
        return exchangeRates[outputUnit]!/exchangeRates[inputUnit]!
        
    }
}


