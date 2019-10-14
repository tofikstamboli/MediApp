//
//  ViewChemistInfoViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 07/01/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class ViewChemistInfoViewController: UIViewController {

    var chemInfo : ChemInfo!
    @IBOutlet var name: UILabel!
    @IBOutlet var add: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var mobno: UILabel!
    @IBOutlet var dlno: UILabel!
    @IBOutlet var gstno: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = chemInfo.FST_NAME
        add.text = chemInfo.ADDRESS
        email.text = chemInfo.EMAIL
        mobno.text = chemInfo.MOBILE
        
    }
 
    @IBAction func okAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
