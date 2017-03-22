//
//  MenuViewController.swift
//  Caffinator
//
//  Created by Chris Fischer on 3/19/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
}


class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var shop: ShopAnnotation? {
        didSet {
            self.menu = shop?.menu
            self.tableView.reloadData()
        }
    }
    
    var menu: [[String: String]]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -  TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell", for: indexPath) as! MenuItemCell
        
        // Configure the cell...
        let row : Int = indexPath.row
        
        guard let _ = menu else {
            return cell
        }
        
        cell.itemLabel.text = menu?[row]["item"]
        cell.priceLabel.text = "$" + (menu?[row]["price"])!
        
        return cell

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

}
