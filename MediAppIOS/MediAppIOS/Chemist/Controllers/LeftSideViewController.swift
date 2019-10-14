//
//  LeftSideViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 20/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import Toast_Swift

class LeftSideViewController: UIViewController {
    var prefrences = UserDefaults.standard
    @IBOutlet weak var emailId: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emid = prefrences.string(forKey: "EmailId")
        emailId.text = emid
//        self.navigationController?.navigationBar.topItem?.title = "Profile"
//        let gold = UIColor.orange
//       navigationController?.navigationBar.barTintColor = gold
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editProfile(_ sender: Any) {
     performSegue(withIdentifier: "toEditProfile", sender: nil)
    }
    
    @IBAction func dilevered_order(_ sender: Any) {
        performSegue(withIdentifier: "toDeliveredOrderes", sender: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        prefrences.set("", forKey: "EmailId")
        prefrences.set("", forKey: "Password")
        prefrences.set("", forKey: "which_login")
        
        performSegue(withIdentifier: "logOut", sender: nil)

    }
    
    
}
extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
