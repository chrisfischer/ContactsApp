//
//  ContactDatabase.swift
//  Contacts
//
//  Created by Chris Fischer on 2/16/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import UIKit

class ContactDatabase {
    
    static var contacts = [Person]()
    
    static func addContact(person: Person) {
        contacts.append(person)
    }
    
    static func removeContact(person: Person) {
        let index = contacts.index(of: person)
        contacts.remove(at: index!)
    }
    
    static func getNumOfContacts () -> Int {
        return contacts.count
    }
    
    static func getContact (index: Int) -> Person {
        return contacts[index]
    }
    
}
