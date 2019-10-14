//
//  LogOutViewController.swift
//  MediAppIOS
//
//  Created by iMac on 04/10/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.MoveToMain()
    }
}
