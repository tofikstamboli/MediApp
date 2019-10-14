//
//  ChemistLoginViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 02/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import SQLite3


class ChemistLoginViewController: UIViewController,UITextFieldDelegate {
  
    
    let dispatchGroup = DispatchGroup()
   var db: OpaquePointer?
    private var ProductListObject = [Product]()
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var signInbtn: UIButton!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var upperUIView: UIView!
    @IBOutlet weak var forgotPas: UIButton!
    
    var sv = UIView()
    let preferences = UserDefaults.standard
    var valid = validation()
    var loginAs : String = ""
    var user_id : String = ""
    var login_track : Int = 0 // 1(Stockist) || 2(Chemist) for direct login and 0 for registration
    let backPro = loadBackData()
    var queryStringImg = String()
    var respData : MyData!
    var stmt: OpaquePointer?
    
    var queryString = ""
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "loginDone" {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.buildNavigationDrawer(drawer: "chemist")
        }
            if segue.identifier == "signin_to_stockist" {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.buildNavigationDrawer(drawer: "stockiest")
        }
    }
    

    
    func createTables() {
    if sqlite3_exec(self.db, " CREATE TABLE "
    + Constants.TABLE_GST_PRODUCT_MASTER + "("
    + Constants.PRODUCT_ID + " TEXT,"
    + Constants.PRODUCT_NAME + " TEXT,"
    + Constants.PRODUCT_TYPE + " TEXT,"
    + Constants.PROD_COMPOSITION + " TEXT,"
    + Constants.PRODUCT_DESCRIPTION + " TEXT,"
    + Constants.SCHEME + " TEXT,"
    + Constants.SCHEME_DESCRIPTION + " TEXT,"
    + Constants.SCHEME_EXPIRY + " TEXT,"
    + Constants.SCHEME_QUANTITY + " TEXT,"
    + Constants.SCHEME_VALUE + " TEXT,"
    + Constants.SCHEME_ID + " TEXT,"
    + Constants.PTR + " TEXT,"
    + Constants.PTS + " TEXT,"
    + Constants.MSP + " TEXT,"
    + Constants.CATEGORY + " TEXT,"
    + Constants.IMAGEURL + " TEXT,"
    + Constants.MANUFACTURE_ID + " TEXT,"
    + Constants.MANUFACTURE_NAME + " TEXT,"
    + Constants.PRODUCT_STATUS + " TEXT,"
    + Constants.PRD_CATEGORY_ID + " TEXT ,"
    + Constants.PRD_CATEGORY_NAME + " TEXT ,"
//    + Constants.PRD_REDEEM_MRP + " TEXT ,"
//    + Constants.PRD_REDEEM_POINT + " TEXT ,"
    + Constants.PRODUCT_QUANTITY + " TEXT,"
    + Constants.PRD_REDEEM_VALUE + " TEXT,"
    + Constants.PROD_BUSINESS_TYPE + " TEXT) ;", nil, nil, nil) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
    print("error creating table: \(errmsg)")
    }
    print("table1 GST_PRODUCT_MASTER created successfully")
    
    
    if sqlite3_exec(self.db, "CREATE TABLE "
    + Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER + "(" + Constants.ADDTOCART_PRODUCT_ID
    + " TEXT PRIMARY KEY," + Constants.ADDTOCART_PRODUCT_NAME
    + " TEXT ," + Constants.ADDTOCART_MANUFACTURE_ID
    + " TEXT ," + Constants.ADDTOCART_SELECTED_MANUFACTURE_NAME
    + " TEXT ,"  + Constants.ADDTOCART_SELECTED_QUANTITY
    + " TEXT ," + Constants.ADDTOCART_SELECTED_PRD_PRICE
    + " TEXT ," + Constants.ADDTOCART_SELECTED_PRD_PTR
    + " TEXT ," + Constants.ADDTOCART_SELECTED_PRD_PTS
    + " TEXT ," + Constants.ADDTOCART_SELECTED_PRD_SCHEME_VALUE
    + " TEXT ," + Constants.ADDTOCART_SELECTED_PRD_SCHEME_QTY
    + " TEXT ," + Constants.ADDTOCART_SESSION_ID
    + " TEXT ," + Constants.ADDTOCART_FLAG + " TEXT ) ;", nil, nil, nil) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
    print("error creating table: \(errmsg)")
    }
    
    print("table2 GST_ADDTOCART_PRODUCT_MASTER created successfully")
    
    //        gst_tbl_product_category(prod_category_id,prod_category_name,prod_category_status) values('GPE_1','GENRIC','ACTIVE'),('GPE_2','BRAND','ACTIVE'),('GPE_3','OTC','ACTIVE')
    
    if sqlite3_exec(self.db, "CREATE TABLE "
    + Constants.TABLE_GST_PRODUCT_CATEGORY + "(" + Constants.PRD_CATEGORY_ID
    + " TEXT PRIMARY KEY," + Constants.PRD_CATEGORY_NAME
    + " TEXT ," + Constants.PRD_CATEGORY_STATUS + " TEXT ) ;", nil, nil, nil) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
    print("error creating table: \(errmsg)")
    }
    
    print("table2 TABLE_GST_PRODUCT_CATEGORY created successfully")
    
    let createschememaster = " CREATE TABLE "
    + Constants.TABLE_GST_SCHEME_OFFER_IMAGES + "(" +
    Constants.OFFER_SCHEME_URL + " TEXT ," +
    Constants.OFFER_SCHEME_PRODUCTID + " TEXT ," +
    Constants.BIG_URL + " TEXT ," +
    Constants.SCHEME_FLAG + " TEXT) ;";
    
    if sqlite3_exec(self.db, createschememaster, nil, nil, nil) != SQLITE_OK {
    let errmsg = String(cString: sqlite3_errmsg(self.db)!)
    print("error creating table: \(errmsg)")
    }else{
    print("table2 schememaster created successfully")
    }
    
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.email.delegate = self
        self.passwd.delegate = self
        signInbtn.layer.cornerRadius = 10
        signInbtn.layer.borderWidth = 1
        signInbtn.layer.borderColor = UIColor.black.cgColor
        email.layer.cornerRadius = 10
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor.gray.cgColor
        passwd.layer.cornerRadius = 10
        passwd.layer.borderWidth = 1
        passwd.layer.borderColor = UIColor.gray.cgColor
        forgotPas.layer.cornerRadius = 10
        myView.layer.cornerRadius = 10
        myView.layer.borderWidth = 2
        myView.layer.borderColor = UIColor.black.cgColor
        self.hideKeyboardWhenTappedAround()
        email.delegate = self
        passwd.delegate = self
        
        
        if login_track != 1 && login_track != 2 {
            user_id = preferences.string(forKey: "user") ?? ""
            loginAs = preferences.string(forKey: "which_login")!
        }else if login_track == 1{
        loginAs = "Stockist"
        }else{
            loginAs = "Chemist"
        }
        if loginAs == "Chemist"{
             let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("MediAppDatabase.sqlite")
        
        
            if sqlite3_open(fileURL.path, &self.db) != SQLITE_OK {
                print("error opening database")
            }
            
//        self.DropTable()
            
          createTables()
            
            
            
            
      
        if Reachability.isConnectedToNetwork(){
            self.deleteSqlTableData()
           
            let emid = preferences.string(forKey: "EmailId")
            let pass = preferences.string(forKey: "Password")
            
//            emid = "" ; pass = "" ; // stopping auto login
            
            if emid != "" && pass != "" && emid != nil && pass != nil  {
                getLoginCredential(email: emid!, password: pass!)
            }

            
            
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Connect To Internet! ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    UIViewController.removeSpinner(spinner: self.sv)
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        }else if loginAs == "Stockist"{
            let emid = preferences.string(forKey: "EmailId")
            let pass = preferences.string(forKey: "Password")
            
            //            emid = "" ; pass = "" ; // stopping auto login
            
            if emid != "" && pass != "" && emid != nil && pass != nil  {
                getLoginCredential(email: emid!, password: pass!)
            }
        }
    }

    @IBAction func LoginProcessAction(_ sender: Any) {
        let emid = self.email.text
        let pass = self.passwd.text
        if valid.isValidEmail(testStr: emid!){
            getLoginCredential(email: emid!, password: pass!)
        }else{
            Toast(str: "Invalid Email ID")
        }
    }

    func getLoginCredential(email:String,password:String) {
        
        if Reachability.isConnectedToNetwork(){
            
            self.sv = UIViewController.displaySpinner(onView: self.view)
            if loginAs == "Stockist" {
                
                guard let newurl = URL(string:"\(Constants.stockisturl)?end_point=userLogin&email=\(email)&password=\(password)&flag=1&reg_id=23443&imei=124354525") // flag = 4 for chemist and 1 for stockist
                    
                    else {return}
                let task = URLSession.shared.dataTask(with: newurl) { (data, response, error) in
                    do {
                        // data we are getting from network request
                        let decoder = JSONDecoder()
                        
                        let response = try decoder.decode(LoginModel.self, from: data!)
                        
                        if response.user_info.STATUS == "1" {
                            
                            self.preferences.set(response.user_info.EMP_ID, forKey: "EMP_ID")
                            DispatchQueue.main.async {
                                
                                UIViewController.removeSpinner(spinner: self.sv)
                                self.performSegue(withIdentifier: "signin_to_stockist", sender: nil)
                            }
//                            DispatchQueue.global(qos:.userInteractive).async {
//                                //                        self.doSomeTimeConsumingTask() // takes 5 seconds to respond
//
//
//
//                            }

                        }

                        
                    } catch let parsingError {
                        print("Error", parsingError)
                        UIViewController.removeSpinner(spinner: self.sv)
                    }
                }
                task.resume()
            }else if loginAs == "Chemist" {
//                let newurl = String(URL:"\(Constants.stockisturl)?end_point=userLogin&email=\(email)&password=\(password)&flag=4&reg_id=23443&imei=124354525")// flag = 4 for chemist and 1 for stockist
                
                guard let newurl = URL(string: "\(Constants.stockisturl)?end_point=userLogin&email=\(email)&password=\(password)&flag=4&reg_id=23443&imei=124354525") else {return}

                let task = URLSession.shared.dataTask(with: newurl) { (data, response, error) in
                    do {
                        // data we are getting from network request
                        let decoder = JSONDecoder()
                        if data != nil {
                        let response = try decoder.decode(LoginModel.self, from: data!)
                        //self.stockistList = response
                        //  self.performSegue(withIdentifier: "stockistlistsegue", sender: nil)


                        if response.user_info.STATUS == "1" {
                            self.preferences.set(response.user_info.EMP_ID, forKey: "EMP_ID")
                            print("ConnectionData Loaded!!!")
                            self.preferences.set(email, forKey: "EmailId")
                            self.preferences.set(password, forKey: "Password")
                            self.preferences.set(response.user_info.FST_NAME, forKey: "name")
                            self.preferences.set(response.user_info.EMP_ID, forKey: "user")
                            self.preferences.set(response.user_info.SHOP_NAME, forKey: "shopname")
                            self.preferences.set(response.user_info.MOBILE, forKey: "mobile")
                            self.preferences.set(response.user_info.CITY, forKey: "city")
                            self.preferences.set(response.user_info.STATE, forKey: "state")
                            self.preferences.set(response.user_info.POSTAL_CODE, forKey: "postalcode")
//                            self.preferences.set(response.user_info.LANDMARK, forKey: "landmark")
                            self.makeGetCall()
//                            self.makeGetCall2()
                        }else {
                            DispatchQueue.main.async {
//                               USer id or pass wrong error
                                self.view.makeToast(response.user_info.ERROR)
                                UIViewController.removeSpinner(spinner: self.sv)
                            }
                        }
                        }else{
                            let alert = UIAlertController(title: "Alert", message: "Check Connection! ", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    UIViewController.removeSpinner(spinner: self.sv)

                                case .cancel:
                                    print("cancel")

                                case .destructive:
                                    print("destructive")

                                }}))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } catch let parsingError {
                        print("Error", parsingError)
                        let alert = UIAlertController(title: "Alert", message: "Check Your credentials ! / Internet Connection.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                UIViewController.removeSpinner(spinner: self.sv)
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                task.resume()
            }
        }else{
            Toast(str: "please connect to network!")
        }
    }

    func Toast(str : String) {
        let alert = UIAlertController(title: "Alert", message: str, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                UIViewController.removeSpinner(spinner: self.sv)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteDataAll(deleteStatementStirng : String){
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        if sqlite3_exec(db, deleteStatementStirng , nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error delete data: \(errmsg)")
        }else {
            print("data deleted....!")
        }
        sqlite3_finalize(deleteStatement)
    }

    func deleteSqlTableData() {
        //////////////Delete All data from cart table before insert new one /////////////////////////////////
        var deleteStatementStirng = "DELETE FROM \(Constants.TABLE_GST_PRODUCT_MASTER);"
        deleteDataAll(deleteStatementStirng: deleteStatementStirng)
        // delete offeres
        deleteStatementStirng = "DELETE FROM \(Constants.TABLE_GST_SCHEME_OFFER_IMAGES);"
        deleteDataAll(deleteStatementStirng: deleteStatementStirng)
        
        deleteStatementStirng = "DELETE FROM \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER);"
        deleteDataAll(deleteStatementStirng: deleteStatementStirng)
    }
    
    
    func exicuteStmt(){
        if sqlite3_prepare(self.db, self.queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(self.db)!)
            print("error preparing insert: \(errmsg)")
            return
        }else{
            print("Success")
        }
        
        if sqlite3_step(self.stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(self.db)!)
            print("failure inserting operation: \(errmsg)")
            return
        }else{
            print("Success")
        }
    }
    
    
    

    

    
    func makeGetCall() {
    
              self.user_id = preferences.string(forKey: "user")!
              
              guard let url = URL(string:"\(Constants.stockisturl)index.php?end_point=getOrderList&emp_id=\(self.user_id)" ) else {return}
              let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                // data we are getting from network request
                let decoder = JSONDecoder()
                if data != nil {
        
                let response = try decoder.decode(MyData.self, from: data!)
                self.respData = response
                
                self.queryString = "\(String(response.stk_book.v_insert!))"
                self.exicuteStmt()
                self.queryString = "\(String(response.scheme_images.str_images_url!))"
                self.exicuteStmt()
                self.queryString = "\(String((response.cart?.v_insert) ?? ""))"
                self.exicuteStmt()
                
                    DispatchQueue.main.async {
                        UIViewController.removeSpinner(spinner: self.sv)
                        self.performSegue(withIdentifier: "loginDone", sender: nil)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.view.makeToast("Check Connection!")
                    }
                }
                
            } catch let parsingError {
                DispatchQueue.main.async {
                    self.view.makeToast(parsingError.localizedDescription)
                }

            }
        }
        task.resume()

       
        
        
}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

    
    
    



