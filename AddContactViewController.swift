//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Chris Fischer on 2/17/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    var person : Person?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "cancelToContactList") {
            return true
        } else if (identifier == "saveContact") {
            let firstName = firstNameField?.text
            let lastName = lastNameField?.text
            let company = companyField?.text
            let email = emailField?.text
            let phoneNumber = phoneNumberField?.text
            if (firstName!.isEmpty || lastName!.isEmpty || company!.isEmpty || email!.isEmpty || phoneNumber!.isEmpty) {
                showAlert()
                return false
            } else {
                self.person = Person(firstName: firstName!, lastName: lastName!, company: company!, email: email!,phoneNumber: phoneNumber!)
                return true
            }
        }
        return false
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Oops", message: "All fields must be filled", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
 

}
