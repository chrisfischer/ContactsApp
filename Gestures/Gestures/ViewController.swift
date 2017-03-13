//
//  ViewController.swift
//  Gestures
//
//  Created by Yagil Burowski on 19/09/2016.
//  Copyright © 2016 CIS 195 University of Pennsylvania. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // We've put these here for your convenience
    
    var temperatureValue : Float?
    var lightValue : Float?
    var volumeValue : Float?
    var currentState : String = "temp"
    
    @IBOutlet weak var touchPad: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var lockSwitch: UISwitch!
    @IBOutlet weak var lightBox: UILabel!
    @IBOutlet weak var tempBox: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // TODO: implement setupGestures()
        
        setupGestures()
        
        // Default temperature arbitrarily set to 73.
        
        temperatureValue = 73
        
        // We chowse to indicate light level as a color. 
        // Colors in RGB have value ranging 0-255.
        // Learn more about UIColor to figure out how to programtically set a new color.
        
        lightValue = 0
        
        // Max volume is arbitrarily set to 50. 
        // You can adjust this by changing the '.maximumValue' property of the UISlider
        // Can be found under the Attributes Inspector in the Interface Builder.
        volumeValue = 0
        
    }
    
    func setupGestures() {
        
        // triple tap
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(tripleTapped(recognizer:)))
        tripleTap.numberOfTapsRequired = 3
        tripleTap.delegate = self
        
        // double touch tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.require(toFail: tripleTap)
        doubleTap.delegate = self
        
        // pan up and down
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(recognizer:)))
        pan.delegate = self
        
        // rotate
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotated(recognizer:)))
        rotate.delegate = self
        
        
        touchPad.addGestureRecognizer(tripleTap)
        touchPad.addGestureRecognizer(doubleTap)
        touchPad.addGestureRecognizer(pan)
        touchPad.addGestureRecognizer(rotate)
        
    }
    
    func updateHeader(message: String) {
        headerLabel.text = message
    }
    
    
    // MARK: Gesture Functions

    func tripleTapped(recognizer : UITapGestureRecognizer){
        let current = lockSwitch.isOn
        lockSwitch.setOn(!current, animated: true)
        if (current) {
            updateHeader(message: "Main Lock is Now Unlocked!")
        } else {
            updateHeader(message: "Main Lock is Now Locked!")

        }
    }
    
    func doubleTapped(recognizer : UITapGestureRecognizer){
        if (currentState == "temp"){
            updateHeader(message: "Lighting Selected")
            currentState = "light"
        } else if (currentState == "light") {
            updateHeader(message: "Temperature Selected")
            currentState = "temp"
        }
    }
    
    func panned(recognizer : UIPanGestureRecognizer){
        let vol = Float(recognizer.velocity(in: touchPad).y) * -0.01 + Float(volumeValue!)
        volumeValue = min(100, max(0, vol))
        volumeSlider.value = Float(volumeValue!)
    }
    
    func rotated(recognizer : UIRotationGestureRecognizer){
        if(currentState == "light"){
            let light = Float(recognizer.velocity) * 0.01 + Float(lightValue!)
            lightValue = min(1, max(0, light))
            lightBox.backgroundColor = UIColor(white: CGFloat(lightValue!), alpha: 1)
        }else {
            temperatureValue = Float(recognizer.velocity) * 0.1 + Float(temperatureValue!)
            tempBox.text = "\(Int(temperatureValue!))°F"
        }
    }
    
   
}

