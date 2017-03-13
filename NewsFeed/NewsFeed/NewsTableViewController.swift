//
//  NewsTableViewController.swift
//  NewsFeed
//
//  Created by Akash Subramanian
//  Copyright © 2016 CIS 195 University of Pennsylvania. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    @IBOutlet var newsTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //populate table: refresh view
        if (NewsData.getNewsItemsLength() != newsTableView.numberOfRows(inSection: 0)) {
            newsTableView.beginUpdates()
            newsTableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
            newsTableView.endUpdates()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsData.getNewsItemsLength();
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)

        // Configure the cell...
        
        let row : Int = indexPath.row
        
        cell.textLabel?.text =  NewsData.getRowItem(row: row)

        return cell
    }
}
