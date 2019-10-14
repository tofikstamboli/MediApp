//
//  NewPasswordViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 02/04/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit
import Toast_Swift
class NewPasswordViewController: UIViewController,UITextFieldDelegate {

    var sv = UIView()
    var resp = OTPData()
    var prefrences = UserDefaults.standard
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let email = self.prefrences.string(forKey: "forgotPassEmail")
        let pass = passwordTF.text
        if pass != "" {
        changePass(email: email!,pass: pass!)
        }else{
            self.view.makeToast("Please Enter Password!")
        }
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
    
    func changePass(email:String , pass:String){
        self.sv = UIViewController.displaySpinner(onView: self.view)
        let urlstr = "http://13.127.182.214/mediapp/SeedApp/forgot_password.php?&email=\(String(email))&Newpassword=\(String(pass))&flag=2&user_pos=4"
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
                let response = try decoder.decode(OTPData.self, from: data!)
                self.resp = response
                if self.resp.status == "success" {
                    
                    DispatchQueue.main.async {
                        UIViewController.removeSpinner(spinner: self.sv)
                        self.toastGenrate(message: self.resp.message!)
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        UIViewController.removeSpinner(spinner: self.sv)
                        self.toastGenrate(message: self.resp.message!)
                    
                    }
                }
            }
                
            catch _ {
                
                print("Error at getting wallet data!")
                
                DispatchQueue.main.async {
                    UIViewController.removeSpinner(spinner: self.sv)
                    self.view.makeToast("Please Enter Correct Email!!")
                }
                
            }
        }
        task.resume()
    }
    
    func toastGenrate(message : String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                self.performSegue(withIdentifier: "toLogin", sender: nil)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
}
