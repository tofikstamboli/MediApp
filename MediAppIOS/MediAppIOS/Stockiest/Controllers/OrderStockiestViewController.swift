//
//  OrderStockiestViewController.swift
//  MediAppIOS
//
//  Created by iMac on 30/05/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class OrderStockiestViewController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        segment.selectedSegmentIndex = 1
        segment.setTitle("Connections", forSegmentAt: 0)
        segment.setTitle("Orderes", forSegmentAt: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.buildNavigationDrawer(drawer: "stockiest1")
    }

    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            performSegue(withIdentifier: "toStockiestConn", sender: nil)
        }
    }

}
