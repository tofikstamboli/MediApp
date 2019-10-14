//
//  OwnerRegistrationViewController.swift
//  LoginDemo
//
//  Created by abhishek on 30/06/18.
//  Copyright © 2018 abhishek. All rights reserved.
//

import UIKit
import Foundation

class ChemistRegistrationViewController: UIViewController {

    @IBOutlet weak var shop_name: UITextField!
    
    @IBOutlet weak var owner_name: UITextField!
    
    @IBOutlet weak var mob_no: UITextField!
    
    @IBOutlet weak var alt_mob_no: UITextField!
    
    @IBOutlet weak var email_id: UITextField!
  
    @IBOutlet weak var s_l_l: UITextField!
    
    @IBOutlet weak var pin_code: UITextField!
    
    @IBOutlet weak var city_name: UITextField!
    
    @IBOutlet weak var state_name: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var cpassword: UITextField!
    
    @IBOutlet weak var drug_license_no: UITextField!
    
    var state_val = 0
    
    var activityindicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var prefrences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    let dispatchGroup = DispatchGroup()
    
    func runThread(after sec:Int, completion: @escaping() -> Void) {
        let deadline = DispatchTime.now() + .seconds(sec)
         DispatchQueue.main.asyncAfter(deadline: deadline){
            completion()
        }
    }
    
    
    @IBAction func owner_register_action(_ sender: AnyObject) {
        
        activityindicator.center = self.view.center
        activityindicator.hidesWhenStopped = true
        
        activityindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityindicator.startAnimating()
        view.addSubview(activityindicator)
        
        let shnm = shop_name.text
        let ownnm = owner_name.text
        let mobno = mob_no.text
        let amobno = alt_mob_no.text
        let eid = email_id.text
        let sll = s_l_l.text
        let pin = pin_code.text
        let cty = city_name.text
        let state = state_name.text
        let passwd = password.text
        let cpasswd = cpassword.text
        let dln = drug_license_no.text
        let flag = 1
        
        dispatchGroup.enter()
        
        runThread(after: 0){
                   self.PostData(shname: shnm!, ownnm: ownnm!, mobno: Int(mobno!)!, amobno: Int(amobno!)!, eid: eid!, sll: sll!, pin: Int(pin!)!, cty: cty!, state: state!, passwd: passwd!, cpasswd: cpasswd!, dln: dln!, flag: flag)
        }
        
        
        dispatchGroup.notify(queue: .main){
            print("performing segue")
            self.activityindicator.stopAnimating()
            if  self.state_val == 1 {
                self.performSegue(withIdentifier: "otpsegue", sender: nil)
            }else {
                print("Return error")
            }

        }
       
    }
    
   
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sender = segue.destination as! OTPPopUpViewController
        sender.comefrom = "chemist_registration"
    }
    

    func PostData(shname : String, ownnm : String, mobno : Int, amobno : Int, eid : String,sll : String, pin : Int, cty : String, state : String,passwd : String,cpasswd : String,dln : String,flag:Int)
    {

        let reg_id = "APA91bE4fPLs93mPLRloBkEdBPxnDajAlH436KOpVGh6sVlVIelULfIknGEE18ajzjGnr5sEM469ONQynEj2He5k-8nxEpGyniQ098lL0IKFy7Rye6ifyNj9ypCvWbRaO4CXRTl5M_e9"
        let imei = 12356789
        let lat = 19.125362
        let long = 72.999199
        let zip_id = 400705
        let otpflag = "false"
        
        let alldata = [reg_id,imei,lat,long,zip_id,otpflag,shname,ownnm,mobno,amobno,eid,sll,pin,cty,state,passwd,cpasswd,dln,flag] as [Any]
        
        self.prefrences.setValue(alldata, forKey: "alldata")
        
        
        let url = URL(string: "http://52.41.1.45/zomed_new_tmp/SeedApp/register.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "reg_id=\(reg_id)&imei=\(imei)&lat=\(lat)&long=\(long)&zip_id=\(zip_id)&shop_name=\(shname)&name=\(ownnm)&mobileno=\(mobno)&alt_mobile=\(amobno)&email=\(eid)&landmark=\(sll)&pin_no=\(pin)&city=\(cty)&state=\(state)&password=\(passwd)&drug_license_no=\(dln)&flag=\(flag)&otpflag=\(otpflag)"
      

        request.httpBody = postString.data(using: .utf8)
        
 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
            
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                //printing the json in console
                print("Printing JSON Data")
                let status = jsonObj!.value(forKey: "status")!
                print(jsonObj!.value(forKey: "errormsg")!)
                
                
                
                if String(describing: status) != "success" {
                    print("No Success")
                   self.state_val = 0
                    self.dispatchGroup.leave()
                   
                }else{
                    print("Success")
                    let OTP = jsonObj!.value(forKey: "otp")!
        
                    print("Storing OTP in UserDefault!")
                    self.prefrences.set(OTP, forKey:"otp")
                    self.state_val = 1
                    print(self.state_val)
                    self.dispatchGroup.leave()
                    
                }
                
            }
     
        }
        task.resume()

            }



}
