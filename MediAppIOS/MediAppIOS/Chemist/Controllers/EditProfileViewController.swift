//
//  EditProfileViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 31/03/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit
import  Toast_Swift
class EditProfileViewController: UIViewController, UITextFieldDelegate {

    var prefrences = UserDefaults.standard
    var sv = UIView()
    var resp = Editing()
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var shopname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phno: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var result = Editing()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(keyoardChange), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyoardChange), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        name.text = prefrences.string(forKey: "name")
        shopname.text = prefrences.string(forKey: "shopname")
        email.text = prefrences.string(forKey: "EmailId")
        phno.text = prefrences.string(forKey: "mobile")
        name.delegate = self
        shopname.delegate = self
        email.delegate = self
        phno.delegate = self
        newPassword.delegate = self
        
     
    }
    
    //This is for disabling keyboard IMP --
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   @objc func keyoardChange(notification:Notification){
    
    let userInfo = notification.userInfo
    let keyBoardEndframe = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let viewEndFrame = view.convert(keyBoardEndframe, from: view.window)
    
    if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
    }else{
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: viewEndFrame.height, right: 0)
    }
    scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    
   // ----------disabling keyboard end ------
    
    @IBAction func UpdateProfile(_ sender: Any) {
        DispatchQueue.main.async {
            
        if Reachability.isConnectedToNetwork(){
//            self.sv = UIViewController.displaySpinner(onView: self.view)
            if self.password.text != "" {
                if self.password.text == self.prefrences.string(forKey: "Password") {
                    if self.newPassword.text != "" {
                        self.update_values(fild: "PASSWORD", value: self.newPassword.text!)
                }else{
//                    UIViewController.removeSpinner(spinner: self.sv)
                    self.view.makeToast("Enter New Password!!")
                }
            }else{
                self.view.makeToast("Password Not Match!!")
            }
        }
            if self.name.text != "" && self.shopname.text != "" && self.phno.text != "" && self.email.text != ""{
//             self.sv = UIViewController.displaySpinner(onView: self.view)
                self.update_values(fild: "FST_NAME", value: self.name.text!)
                self.update_values(fild: "SHOP_NAME", value: self.shopname.text!)
                self.update_values(fild: "EMAIL", value: self.email.text!)
                self.update_values(fild: "MOBILE", value: self.phno.text!)
        }else{
            
            self.view.makeToast("Please Fill data!")
        }
        
        }else{
            self.view.makeToast("Please connect to internet!")
        }
    }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.buildNavigationDrawer(drawer: "chemist")
    }


    func update_values(fild:String,value:String) {
        self.sv = UIViewController.displaySpinner(onView: self.view)
        let emp_id = self.prefrences.string(forKey: "EMP_ID")!
        let urlstr = "\(Constants.liveurlAll)edit_profile.php?user_id=\(emp_id)&field_name=\(fild)&field_value=\(value)&flag=4"
        
        FetchHttpData.updateDataModels(url: urlstr, type: Editing.self){
            response in
            self.result = response as! Editing
            if self.result.status?.uppercased() == "SUCCESS"{
               DispatchQueue.main.async() {
                    self.prefrences.set(self.name.text, forKey: "name")
                    self.prefrences.set(self.shopname.text, forKey: "shopname")
                    self.prefrences.set(self.email.text, forKey: "EmailId")
                    self.prefrences.set(self.phno.text, forKey: "mobile")
                
                    self.view.makeToast(" Data Updated!!")
                }
            }else{
                DispatchQueue.main.async() { self.view.makeToast(" Not Updated!!")
                }
            }
            
            }
        UIViewController.removeSpinner(spinner: self.sv)
    }
}
