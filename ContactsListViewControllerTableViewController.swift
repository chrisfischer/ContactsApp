//
//  ContactsListViewControllerTableViewController.swift
//  Contacts
//
//  Created by Chris Fischer on 2/16/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import UIKit

class ContactsListViewControllerTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactDatabase.getNumOfContacts()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)

        // Configure the cell...
        let row : Int = indexPath.row
        let person : Person = ContactDatabase.getContact(index: row)
        
        cell.detailTextLabel?.text = person.company!
        cell.textLabel?.text = "\(person.firstName!) \(person.lastName!)"

        return cell
    }
    
    @IBAction func saveContact(segue: UIStoryboardSegue) {
        if let addContactViewControllerInstance = segue.source as? AddContactViewController {
            if let person = addContactViewControllerInstance.person {
                // Update the model
                ContactDatabase.addContact(person: person)
                ContactDatabase.contacts.sort {
                    ($0.lastName! + $0.firstName!) < ($1.lastName! + $1.firstName!)
                }
                let pathIndex = IndexPath(row: ContactDatabase.getNumOfContacts() - 1, section: 0)
                tableView.insertRows(at: [pathIndex], with: .automatic)
                tableView.reloadData()
            }
        }
        
    }
    @IBAction func cancelToContactList(segue: UIStoryboardSegue) {
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let destination = segue.destination as? InfoDisplayViewController {
            // Pass the selected object to the new view controller.
            let row = tableView.indexPathForSelectedRow?.row
            destination.dataRow = row
        }
        
    }
    

}
