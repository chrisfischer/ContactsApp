//
//  CreateNewsViewController.swift
//  NewsFeed
//
//  Created by Akash Subramanian
//  Copyright © 2016 CIS 195 University of Pennsylvania. All rights reserved.
//

import UIKit

class CreateNewsViewController: UIViewController {

    @IBOutlet weak var newsTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // bring keyboard up
        newsTextView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        // remove keyboard
        newsTextView.resignFirstResponder()
        // remove as first responder
    }
    
    
    @IBAction func updateNewsFeed(_ sender: UIBarButtonItem) {
        if (newsTextView.text! == "") {
            showAlert()
        } else {
            NewsData.addNewItem(item: newsTextView.text!)
            dismiss()
        }
        
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss()
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // When do we call this method?
    
    func showAlert() {
        let alert = UIAlertController(title: "Oops", message: "Can't submit empty posts", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
