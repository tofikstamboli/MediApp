//
//  OTPPopUpViewController.swift
//  MediAppIOS
//
//  Created by Globalspace Mac Mini on 28/11/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import SQLite3


class OTPPopUpViewController: UIViewController,UITextFieldDelegate {
    
    let prefrences = UserDefaults.standard
    
    var db: OpaquePointer?
    
    let fAc = fillAndColorClass()
    
    @IBOutlet weak var otp_txt: UITextField!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var errlab: UILabel!
    @IBOutlet weak var lableView: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    //    var activityindicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var comefrom = ""
    
    //    let dispatchGrop = DispatchGroup()
    
    var user_id : String!
    var error_msg : String!
    var status : String!
    var loginAs : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        errlab.isHidden = true
        // Do any additional setup after loading the view.
        
        loginAs = prefrences.string(forKey: "loginAs")
        
        self.fAc.feelAndColor(view: myView)
        self.fAc.feelAndColor(view: lableView)
        self.fAc.feelAndColor(view: submitBtn)
        self.fAc.feelAndColor(view: otp_txt)
        
        //create table
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MASTER_DATABASE.sqlite")
        
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, " CREATE TABLE "
            + Constants.TABLE_GST_PRODUCT_MASTER + "(" + Constants.PRODUCT_ID
            + " INTEGER ," + Constants.PRODUCT_NAME + " TEXT,"
            + Constants.MANUFACTURE_ID + " TEXT,"
            + Constants.MANUFACTURE_NAME + " TEXT,"
            + Constants.PRODUCT_DESCRIPTION + " TEXT,"
            + Constants.PROD_COMPOSITION + " TEXT,"
            + Constants.SCHEME_ID + " TEXT," + Constants.PTR
            + " TEXT," + Constants.PTS + " TEXT," + Constants.MSP + " TEXT,"
            + Constants.IMAGEURL + " TEXT," + Constants.CATEGORY + " TEXT,"
            + Constants.SCHEME_DESCRIPTION + " TEXT," + Constants.SCHEME_EXPIRY + " TEXT,"
            + Constants.SCHEME_VALUE + " TEXT," + Constants.SCHEME_QUANTITY + " TEXT,"
            + Constants.SCHEME + " TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        print("Table Created Successfully")
        
        self.fetchData()
        
        // Do any additional setup after loading the view.
    }
    //        navigationController?.popViewController(animated: true)
    //        dismiss(animated: true, completion: nil)

    
    @IBAction func OtpSubmitAction(_ sender: AnyObject) {
        
        //        activityindicator.startAnimating()
        
        
        let otp = prefrences.string(forKey: "otp")
        
        if otp == otp_txt.text {
            errlab.text = "OTP Match."
            errlab.isHidden = false
            
            self.performSegue(withIdentifier: "MainPageViewController", sender: nil)
            
            
        }else {
            errlab.text = "OTP Not Match \n Please Try again."
            errlab.isHidden = false
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        activityindicator.stopAnimating()
//        if segue.identifier == "owner_registration"{
//            _ = (segue.destination as? ChemistLoginViewController)
//            
//        }
        
    }
    
    func fetchData(){
        
        print("Second Table Operation ")
        
        let alldata = prefrences.array(forKey: "alldata")
        var postString : String = ""
        let url = URL(string: Constants.liveurllet)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        //        let regId = PostData(shname: alldata![6] as! String, ownnm: alldata![7] as! String, mobno: alldata![8] as! Int, eid: alldata![9] as! String, sll: alldata![10] as! String, pin: alldata![11] as! Int, cty: alldata![12] as! String, state: alldata![13] as! String, passwd: alldata![14] as! String, cpasswd: alldata![14] as! String, dln: alldata![16] as! String, flag: alldata![17] as! Int, gstin: alldata![18] as! String, cap1: alldata![19] as! String)
        //
        
        if loginAs == "Chemist"{
            postString = "reg_id=\(alldata![0])&imei=\(alldata![1])&lat=\(alldata![2])&long=\(alldata![3])&zip_id=\(alldata![4])&shop_name=\(alldata![6])&name=\(alldata![7])&mobileno=\(alldata![8])&email=\(alldata![9])&landmark=\(alldata![10])&pin_no=\(alldata![11])&city=\(alldata![12])&state=\(alldata![13])&password=\(alldata![14])&drug_license_no=\(alldata![16])&flag=4&p_gstin=\(alldata![18])&otpflag=true"
        }else if loginAs == "Stockist"{
            postString = "reg_id=\(alldata![0])&imei=\(alldata![1])&lat=\(alldata![2])&long=\(alldata![3])&zip_id=\(alldata![4])&shop_name=\(alldata![6])&name=\(alldata![7])&mobileno=\(alldata![8])&email=\(alldata![9])&landmark=\(alldata![10])&pin_no=\(alldata![11])&city=\(alldata![12])&state=\(alldata![13])&password=\(alldata![14])&drug_license_no=\(alldata![16])&flag=1&p_gstin=\(alldata![18])&pin_covered=\(alldata![19])&otpflag=true"
        }
        
        request.httpBody = postString.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.toastGenrate(message: String(describing: error))
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
                //print(jsonObj!.value(forKey: "status")!)
                //print(jsonObj!.value(forKey: "errormsg")!)
                let status = jsonObj!.value(forKey: "status")! as! String
                if status == "success" {
                    self.user_id = jsonObj!.value(forKey: "user_id")! as? String
                    self.prefrences.set(self.user_id, forKey: "user")
                    
                }else{
//                    self.error_msg = (jsonObj!.value(forKey: "errormsg")! as! String)
                    print("Errormsg :\(String(describing: self.error_msg)) ")
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
                
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
