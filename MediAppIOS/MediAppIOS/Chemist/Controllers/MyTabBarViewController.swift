//
//  MyTabBarViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 20/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class MyTabBarViewController: UITabBarController {


    @IBOutlet weak var myTab: UITabBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
