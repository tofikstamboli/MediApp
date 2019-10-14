//
//  ForgotPasswordViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 01/04/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit
import Toast_Swift
class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var resend_btn: UIButton!
    @IBOutlet weak var otp: UITextField!
    var resendflag = false
    var OTP = String()
    var sv = UIView()
    var resp = OTPData()
    var prefrences = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        view2.isHidden = true
        email.delegate = self
        otp.delegate = self
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
    
    @IBAction func emailSubmit(_ sender: Any) {
        if email.text != "" {
        self.sv = UIViewController.displaySpinner(onView: self.view)
        sendForOTP(email: email.text!)
        }else{
            self.view.makeToast("Please Enter email!")
        }
        
        
    }
    func animate(){
        view2.isHidden = false
        view1.isHidden = true
        let xPosition = view2.frame.origin.x
        
        //View will slide 20px up
        let yPosition = view2.frame.origin.y - 200
        
        let height = view2.frame.size.height
        let width = view2.frame.size.width
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.view2.frame = CGRect.init(x: xPosition, y: yPosition, width: width, height: height)
            
        })
    }
    
    @IBAction func resend_otp(_ sender: Any) {
        self.view.makeToast("You can resend OTP after 60 Seconds !")
        resendflag = true
        sendForOTP(email: self.prefrences.string(forKey: "forgotPassEmail")!)
        resend_btn.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { _ in
            self.resend_btn.isEnabled = true
        })

    }
    
    func sendForOTP(email:String) {
        
        let urlstr = "\(Constants.liveurlAll)forgot_password.php?&email=\(email)&flag=1&user_pos=4"
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
                    self.OTP = self.resp.message!
                    self.prefrences.set(email, forKey: "forgotPassEmail")
                    DispatchQueue.main.async {
                        self.view.makeToast("OTP send successfully!!")
                         UIViewController.removeSpinner(spinner: self.sv)
                        if self.resendflag == false {
                        self.animate()
                        }
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
    
    func enableButton() {
        self.view.makeToast("resend OTP if any problem !")
        self.resend_btn.isEnabled = true
    }

    @IBAction func submitOTP(_ sender: Any) {
        if otp.text != "" {
            
            if otp.text == OTP {
                self.view.makeToast("OTP Matched!")
                performSegue(withIdentifier: "newPassword", sender: nil)
            }else{
                self.view.makeToast("Please Enter Valid OTP !")
            }
            
        }else{
            self.view.makeToast("Please Enter OTP !")
            
        }
    }
    
    
    
}
