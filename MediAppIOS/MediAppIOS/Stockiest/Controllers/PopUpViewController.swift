//
//  PopUpViewController.swift
//  MediAppIOS
//
//  Created by iMac on 03/06/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController{

    @IBOutlet weak var titleLbl: UILabel!
    var mytitle : String!
    override func viewDidLoad() {
        super.viewDidLoad()
       titleLbl.text = mytitle
    }
 
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
}
