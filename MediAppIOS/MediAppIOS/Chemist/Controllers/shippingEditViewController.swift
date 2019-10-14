//
//  shippingEditViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 31/03/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit
import Toast_Swift
class shippingEditViewController: UIViewController,UITextFieldDelegate {

    var prefrences = UserDefaults.standard
    var sv = UIView()
    
    @IBOutlet weak var store_name: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var postal_code: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store_name.text = prefrences.string(forKey: "shopname")
        city.text = prefrences.string(forKey: "city")
        address.text = prefrences.string(forKey: "landmark")
        state.text = prefrences.string(forKey: "state")
        postal_code.text = prefrences.string(forKey: "postalcode")
        store_name.delegate = self
        city.delegate = self
        address.delegate = self
        state.delegate = self
        postal_code.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.buildNavigationDrawer(drawer: "chemist")
        
    }
    //This is for disabling keyboard IMP --
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // ----------disabling keyboard end ------
    
    @IBAction func update(_ sender: Any) {
        let emp_id = prefrences.string(forKey: "EMP_ID")!
        let add = store_name.text! + "~" + address.text! + "~" + city.text! + "~" + state.text! + "~" + postal_code.text!
        if address.text != "" && store_name.text != "" && city.text != "" && state.text != "" && postal_code.text != "" {
        update_data(emp_id: emp_id, add: add)
        }else{
            self.view.makeToast("Please Fill All Values!")
        }
    }
    
    func update_data(emp_id:String,add:String){
        self.sv = UIViewController.displaySpinner(onView: self.view)
        let urlstr = "\(Constants.liveurlAll)edit_profile.php?user_id=\(emp_id)&shipping_address=\(add)&edit_flag=edit_address&flag=4"
        guard let url = URL(string:urlstr)
            else {
                print("URL Error!")
                DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: self.sv)
                }
                return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                
                // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(Editing.self, from: data!)
                
                if response.status == "success" {
                    DispatchQueue.main.async {
                        
                        self.prefrences.set(self.store_name.text, forKey: "shopname")
                        self.prefrences.set(self.city.text, forKey: "city")
                        self.prefrences.set(self.state.text, forKey: "state")
                        self.prefrences.set(self.postal_code.text, forKey: "postalcode")
                        self.prefrences.set(self.address.text, forKey: "landmark")
                        
                        UIViewController.removeSpinner(spinner: self.sv)
                        self.view.makeToast("Data Updated Successfully!!")
                    }
                }
            }
                
            catch _ {
                
                print("Error at getting wallet data!")
                
                DispatchQueue.main.async {
                    UIViewController.removeSpinner(spinner: self.sv)
                    self.view.makeToast("Password Not Updated!!")
                }
                
            }
        }
        task.resume()
    }
    
}
