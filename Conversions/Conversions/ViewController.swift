//
//  ViewController.swift
//  Conversions
//
//  Created by Q Kalantary on 9/4/16.
//  Copyright © 2016 CIS 195 University of Pennsylvania. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet weak var outputText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self

        // Setup code
        inputTextField.becomeFirstResponder()
        
    }
    @IBAction func textFieldChanged(_ sender: Any) {
        reloadDisplay()
    }
    
    //MARK: -  UIPickerView data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArr.count
    }
    
    //MARK: -  UIPickerView delegate
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reloadDisplay()
    }
    
    func reloadDisplay() {
        if (inputTextField.text == "") {
            outputText.text = "0.00"
        }
        if let text = inputTextField.text {
            if let amount = Double(text) {
                let inputCurrency = currencyArr[pickerView.selectedRow(inComponent: 0)]
                let outputCurrency = currencyArr[pickerView.selectedRow(inComponent: 1)]
                let conversionRate = Data.getExchangeRate(inputUnit: inputCurrency, outputUnit: outputCurrency)
                outputText.text = String(format: "%.2f", conversionRate * amount)
            }
        }
    }
    
    
}

