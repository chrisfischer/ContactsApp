//
//  InfoDisplayViewController.swift
//  Contacts
//
//  Created by Chris Fischer on 2/17/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import UIKit

class InfoDisplayViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var dataRow : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let person = ContactDatabase.getContact(index: dataRow!)
        self.title = "\(person.firstName!) \(person.lastName!)"
        companyLabel.text = person.company!
        phoneNumberLabel.text = person.phoneNumber
        emailLabel.text = person.email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
