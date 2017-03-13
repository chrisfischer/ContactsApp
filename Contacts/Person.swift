//
//  Person.swift
//  Contacts
//
//  Created by Chris Fischer on 2/16/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import UIKit

class Person: NSObject {
    var firstName : String?
    var lastName : String?
    var company : String?
    var email : String?
    var phoneNumber : String?
    
    init(firstName: String, lastName: String, company: String, email: String, phoneNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
