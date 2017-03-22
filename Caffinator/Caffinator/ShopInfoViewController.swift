//
//  ShopInfoViewController.swift
//  Caffinator
//
//  Created by Chris Fischer on 3/19/17.
//  Copyright © 2017 Chris Fischer. All rights reserved.
//

import UIKit

class ShopInfoViewController: UIViewController {

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            menuView.isHidden = true
            detailsView.isHidden = false
        case 1:
            menuView.isHidden = false
            detailsView.isHidden = true
        default:
            break;
        }
    }
    

}
