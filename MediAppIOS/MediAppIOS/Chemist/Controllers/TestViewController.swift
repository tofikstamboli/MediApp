//
//  TestViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 25/03/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func send(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.buildNavigationDrawer(drawer: "chemist")
    }
    }
    @IBAction func newfunc(_ sender: Any) {
        performSegue(withIdentifier: "toCart", sender: nil)
    }
}
