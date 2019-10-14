//
//  OwnerRegistrationViewController.swift
//  LoginDemo
//
//  Created by abhishek on 30/06/18.
//  Copyright © 2018 abhishek. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit
import AddressBookUI
import Contacts


class OwnerRegistrationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RegisterationTableViewCell
        cell.textLabel?.text = searchList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if flafForSales == false{
        self.state_name.text = searchList[indexPath.row]
        }else{
            self.salesPerson.text = searchList[indexPath.row]
        }
         self.tableView.isHidden = true
    }

    @IBOutlet weak var shop_name: UITextField!
    @IBOutlet weak var owner_name: UITextField!
    @IBOutlet weak var mob_no: UITextField!
    @IBOutlet weak var alt_mob_no: UITextField! //it is GST number
    @IBOutlet weak var email_id: UITextField!
    @IBOutlet weak var s_l_l: UITextField!
    @IBOutlet weak var pin_code: UITextField!
    @IBOutlet weak var city_name: UITextField!
    @IBOutlet weak var state_name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var cpassword: UITextField!
    @IBOutlet weak var drug_license_no: UITextField!
//    @IBOutlet weak var cpa: UITextField!
//    @IBOutlet weak var searchGST: UIButton!
    @IBOutlet weak var getlocbtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addmanuallybtn: UIButton!
    @IBOutlet weak var registerbtn: UIButton!
    @IBOutlet weak var LBtn: UIButton!
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var salesPerson: UITextField!
    var flafForSales = false

    var tapGesture = UITapGestureRecognizer()
    var tapGesture2 = UITapGestureRecognizer()
   
    var shnm : String!
    var ownnm : String!
    var mobno : String!
    var amobno : String!
    var eid : String!
    var sll : String!
    var pin : String!
    var cty : String!
    var state : String!
    var passwd : String!
    var cpasswd : String!
    var dln : String!
    var flag : Int! // flag = 1 for stockist
    var gstin : String!
    var state_val = 0
    var cpa1 : String!
    var myChoice : Bool!
    let valid = validation()
    
    let locationManager = CLLocationManager()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var viewLoading = UIView()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var uiView: UIView!
    var activityindicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var prefrences = UserDefaults.standard
    
    var statesList : [String] = ["ANDHRA PRADESH","ASSAM","ARUNACHAL PRADESH","Bihar","Chhattisgarh","Goa","Gujarat","Harayana","Himachal Pradesh",
    "Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Odisha","Punjab",
    "Rajasthan","Sikkim","Tamil Nadu","Telangana","Tripura","Uttar Pradesh","Uttarakhand","West Bengal","New Delhi"];
    var searchList = [String]()
    var salesFiltersArr = [String]()
    
    
    override func viewWillAppear(_ animated: Bool) {
       loadDetails()
//        hideAllLab()
//        animateScreen()
        self.mapView.isHidden = true
        self.feelAndColor(view: alt_mob_no)
        self.feelAndColor(view: shop_name)
        self.feelAndColor(view: owner_name)
        self.feelAndColor(view: mob_no)
        self.feelAndColor(view: email_id)
        self.feelAndColor(view: s_l_l)
        self.feelAndColor(view: pin_code)
        self.feelAndColor(view: city_name)
        self.feelAndColor(view: state_name)
        self.feelAndColor(view: password)
        self.feelAndColor(view: cpassword)
        self.feelAndColor(view: drug_license_no)
//        self.feelAndColor(view: cpa)
//        self.feelAndColor(view: searchGST)
        self.feelAndColor(view: mapView)
//        self.feelAndColor(view: getlocbtn)
//        self.feelAndColor(view: addmanuallybtn)
        self.feelAndColor(view: registerbtn)
        self.feelAndColor(view: salesPerson)
       self.feelAndColor(view: tableView)
    }
    
    func loadDetails() {
        
//        self.viewLoading = UIViewController.displaySpinner(onView: self.view)
        
        alt_mob_no.text = prefrences.string(forKey: "GSTNO")
        shop_name.text = prefrences.string(forKey: "SHOPNM")
        owner_name.text = prefrences.string(forKey: "OWNNM")
        mob_no.text = prefrences.string(forKey: "MOBNM")
        email_id.text = prefrences.string(forKey: "EMID")
        s_l_l.text = prefrences.string(forKey: "SLL")
        pin_code.text = prefrences.string(forKey: "PINCODE")
        city_name.text = prefrences.string(forKey: "CITYNM")
        state_name.text = prefrences.string(forKey: "STATENM")
//        password.text = prefrences.string(forKey: "PASS")
//        cpassword.text = prefrences.string(forKey: "CPASS")
        drug_license_no.text = prefrences.string(forKey: "DLN")
        salesPerson.text = prefrences.string(forKey: "SALESPER")
        
//        UIViewController.removeSpinner(spinner: self.viewLoading)
        
    }
    @IBAction func stateEditingChanged(_ sender: Any) {
        salesPerson.text = ""
                if (state_name.text?.count)! > 0 {
                    tableView.isHidden = false
                    searchList = statesList.filter({ $0.lowercased().prefix(state_name.text!.count) ==  state_name.text!.lowercased() })
                    if searchList.count == 0 {
                        tableView.isHidden = true
                    }else{
                        tableView.isHidden = false
                    }
                }else if state_name.text == ""{
                    searchList = statesList
                    //            searching = false
                    tableView.isHidden = true
                    
                }
                //        searching = true
        tableView.reloadData()
    }
    
    
    
    @IBAction func salesPersonEditing(_ sender: Any) {
        if (salesPerson.text?.count)! > 0 {
            tableView.isHidden = false
            searchList = salesFiltersArr.filter({ $0.lowercased().prefix(salesPerson.text!.count) ==  salesPerson.text!.lowercased() })
            if searchList.count == 0 {
                tableView.isHidden = true
            }else{
                tableView.isHidden = false
            }
        }else if salesPerson.text == ""{
            searchList = salesFiltersArr
            //            searching = false
            tableView.isHidden = true
        }
        tableView.reloadData()
    }
    
    func setDelegate(text : UITextField){
        text.delegate = self
    }
    
 func feelAndColor(view:UIView){
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.orange.cgColor
    }
    func hideAllLab(){
        alt_mob_no.center.x -= view.bounds.width
        shop_name.center.x += view.bounds.width
        owner_name.center.x -= view.bounds.width
        mob_no.center.x += view.bounds.width
        email_id.center.x -= view.bounds.width
        s_l_l.center.x += view.bounds.width
        pin_code.center.x -= view.bounds.width
        city_name.center.x += view.bounds.width
        state_name.center.x -= view.bounds.width
        password.center.x += view.bounds.width
        cpassword.center.x -= view.bounds.width
        drug_license_no.center.x += view.bounds.width
//        searchGST.center.x += view.bounds.width
        LBtn.center.x += view.bounds.width
//        cpa.center.x -= view.bounds.width
        
         mapView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor).isActive = true
        getlocbtn.widthAnchor.constraint(equalTo: registerbtn.widthAnchor).isActive = true
        addmanuallybtn.widthAnchor.constraint(equalTo: registerbtn.widthAnchor).isActive = true
    }
    func animateScreen(){
        
        ///////Animations
        UIView.animate(withDuration: 0.5, delay: 0.6, options: [],
                       animations: {
                        self.alt_mob_no.center.x += self.view.bounds.width
                        self.owner_name.center.x += self.view.bounds.width
                        self.email_id.center.x += self.view.bounds.width
//                        self.pin_code.center.x += self.view.bounds.width
//                        self.state_name.center.x += self.view.bounds.width
                        self.cpassword.center.x += self.view.bounds.width
//                        self.cpa.center.x += self.view.bounds.width
        },
                       completion: nil
        )
        UIView.animate(withDuration: 0.5, delay: 0.6, options: [],
                       animations: {
                        self.shop_name.center.x -= self.view.bounds.width
                        self.mob_no.center.x -= self.view.bounds.width
//                        self.s_l_l.center.x -= self.view.bounds.width
                        self.password.center.x -= self.view.bounds.width
                        self.drug_license_no.center.x -= self.view.bounds.width
//                        self.searchGST.center.x -= self.view.bounds.width
//                        self.city_name.center.x -= self.view.bounds.width
        },
                       completion: nil
        )
        
    }
    func createSettingsAlertController(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
   func gettingLocationMethod(){
    
    if CLLocationManager.locationServicesEnabled() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            print("No access")
            
            createSettingsAlertController(title: "Title", message: "Allow Location")
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Access")
            self.view.makeToast("Wait!\nWe are setting Your location")
            UIView.animate(withDuration: 1.0, delay: 0.6, options: [],
                           animations: {
                            self.mapView.center.x += self.view.bounds.width
                            self.city_name.center.x -= self.view.bounds.width
                            self.s_l_l.center.x -= self.view.bounds.width
                            self.pin_code.center.x += self.view.bounds.width
                            self.state_name.center.x += self.view.bounds.width
                            self.getlocbtn.center.x += self.view.bounds.width
                            self.addmanuallybtn.center.x -= self.view.bounds.width
                            self.LBtn.center.x -= self.view.bounds.width
            },
                           completion: nil
            )
            city_name.centerXAnchor.constraint(equalTo: uiView.centerXAnchor).isActive = true
            s_l_l.centerXAnchor.constraint(equalTo: uiView.centerXAnchor).isActive = true
            pin_code.centerXAnchor.constraint(equalTo: uiView.centerXAnchor).isActive = true
            s_l_l.centerXAnchor.constraint(equalTo: uiView.centerXAnchor).isActive = true
            
            
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                if locManager.location != nil {
                 currentLocation = locationManager.location
                print(currentLocation.coordinate.longitude)
                print(currentLocation.coordinate.latitude)
                findAddress(long: currentLocation.coordinate.longitude, lat: currentLocation.coordinate.latitude)
                }else{
                    DispatchQueue.main.async {
                        self.view.makeToast("Getting Nil Location! Please check GPS OR Enter Data Menually!")
                        UIViewController.removeSpinner(spinner: self.viewLoading)
                    }
                }
            }
        }
    } else {
        print("Location services are not enabled")
    }
    }
    
    func setDataTOSave(flag:Bool){
//        self.viewLoading = UIViewController.displaySpinner(onView: self.view)
        if flag == true {
            self.saveBtn.tintColor = UIColor.blue
            prefrences.set(alt_mob_no.text, forKey: "GSTNO")
            prefrences.set(shop_name.text, forKey: "SHOPNM")
            prefrences.set(owner_name.text, forKey: "OWNNM")
            prefrences.set(mob_no.text, forKey: "MOBNM")
            prefrences.set(email_id.text, forKey: "EMID")
            prefrences.set(s_l_l.text, forKey: "SLL")
            prefrences.set(pin_code.text, forKey: "PINCODE")
            prefrences.set(city_name.text, forKey: "CITYNM")
            prefrences.set(state_name.text, forKey: "STATENM")
            prefrences.set(password.text, forKey: "PASS")
            prefrences.set(cpassword.text, forKey: "CPASS")
            prefrences.set(drug_license_no.text, forKey: "DLN")
            prefrences.set(salesPerson.text, forKey: "SALESPER")
        }else{
            prefrences.set("", forKey: "GSTNO")
            prefrences.set("", forKey: "SHOPNM")
            prefrences.set("", forKey: "OWNNM")
            prefrences.set("", forKey: "MOBNM")
            prefrences.set("", forKey: "EMID")
            prefrences.set("", forKey: "SLL")
            prefrences.set("", forKey: "PINCODE")
            prefrences.set("", forKey: "CITYNM")
            prefrences.set("", forKey: "STATENM")
            prefrences.set("", forKey: "PASS")
            prefrences.set("", forKey: "CPASS")
            prefrences.set("", forKey: "DLN")
            prefrences.set("", forKey: "SALESPER")
        }
//         UIViewController.removeSpinner(spinner: viewLoading)
    }
    
    @IBAction func saveFieldData(_ sender: Any) {
       setDataTOSave(flag: true)
    }
    
//    @IBAction func getMyLoc(_ sender: Any) {
//        if Reachability.isConnectedToNetwork(){
////    self.viewLoading = UIViewController.displaySpinner(onView: view)
//      gettingLocationMethod()
//        }else{
//            self.view.makeToast("Please Connect to internet!")
//        }
//    }
    
    @IBAction func getLocSBtn(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
        if CLLocationManager.locationServicesEnabled() {
//            self.viewLoading = UIViewController.displaySpinner(onView: view)
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                createSettingsAlertController(title: "Title", message: "Allow Location")
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.view.makeToast("Wait!\nWe are setting Your location")
                if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                    if locManager.location != nil{
                    currentLocation = locationManager.location
                    print(currentLocation.coordinate.longitude)
                    print(currentLocation.coordinate.latitude)
                    prefrences.set(currentLocation.coordinate.latitude, forKey: "CurrentLat")
                    prefrences.set(currentLocation.coordinate.longitude, forKey: "CurrentLong")
                    findAddress(long: currentLocation.coordinate.longitude, lat: currentLocation.coordinate.latitude)
                    }else{
                        toastGenrate(message: "Getting Nil Location! Please check GPS OR Enter Data Menually!")
//                        UIViewController.removeSpinner(spinner: self.viewLoading)
                        
                    }
                }
            }
        } else {
            print("Location services are not enabled")
            self.view.makeToast("Location services are not enabled!")
        }
        }else{
            self.view.makeToast("Please Conntect to internet!")
        }
    }
    
    
    func findAddress(long : Double , lat : Double){
        let loc: CLLocation = CLLocation(latitude: lat,longitude: long)
        let ceo: CLGeocoder = CLGeocoder()
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                var pm = [CLPlacemark]()
                if placemarks != nil {
                pm = placemarks! as [CLPlacemark]
                }else{
                     DispatchQueue.main.async {
//                    self.view.makeToast("Error at getting loacation!")
                        self.view.makeToast("Error at getting loacation!\nPlease On GPS")
                       
                    }
                }
                if pm.count > 0 {
                    let pm = placemarks![0]
                 let subtitle =
                    ABCreateStringWithAddressDictionary(pm.addressDictionary!, false);
                    //                    print(pm.country as Any:)
//                    print(pm.locality as Any)
//                    print(pm.subLocality as Any)
//                    print(pm.administrativeArea as Any)
//                    print(pm.postalCode as Any)
//                    print(pm.subThoroughfare as Any)
                    self.s_l_l.text = subtitle
                    self.pin_code.text = pm.postalCode
                    if pm.postalCode != nil {
                    self.prefrences.set(pm.postalCode, forKey: "ZipId")
                    }else{
                        self.prefrences.set(self.pin_code.text, forKey: "ZipId")
                    }
                    self.city_name.text = pm.locality
                    self.state_name.text = pm.administrativeArea
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }

                }
        })
//         UIViewController.removeSpinner(spinner: self.viewLoading)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        searchList = statesList
        tableView.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.mapView.showsUserLocation = true;
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setDelegate(text: alt_mob_no)
        self.setDelegate(text: shop_name)
        self.setDelegate(text: owner_name)
        self.setDelegate(text: email_id)
        self.setDelegate(text: city_name)
        self.setDelegate(text: state_name)
        self.setDelegate(text: password)
        self.setDelegate(text: cpassword)
        self.setDelegate(text: drug_license_no)
        self.setDelegate(text: salesPerson)
        self.setDelegate(text: s_l_l)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(KeyboardApper), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(KeyboardApper), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 200, 200)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        //------>Tap Event For state <-------------
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self .MyviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        state_name.addGestureRecognizer(tapGesture)
        state_name.isUserInteractionEnabled = true
        
        tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.SalesPersonTapped(_:)))
        tapGesture2.numberOfTapsRequired = 1
        tapGesture2.numberOfTouchesRequired = 1
        salesPerson.addGestureRecognizer(tapGesture2)
        salesPerson.isUserInteractionEnabled = true
 

        //-------><------------------------
        
        //// finding current long lat
        
//        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
//
//                        currentLocation = locationManager.location
//                        print(currentLocation.coordinate.longitude)
//                        print(currentLocation.coordinate.latitude)
//                        findAddress(long: currentLocation.coordinate.longitude, lat: currentLocation.coordinate.latitude)
//        }
        
        //--------------------------------------------->
        
        self.mob_no.keyboardType = UIKeyboardType.numberPad
        self.pin_code.keyboardType = UIKeyboardType.numberPad
        self.hideKeyboardWhenTappedAround()
//        if myChoice == false {
//            cpa.isEnabled = true
            self.prefrences.set("Chemist", forKey: "loginAs")
//        }else{
//            cpa.isEnabled = true
//            self.prefrences.set("Stockist", forKey: "loginAs")
//        }
        // Do any additional setup after loading the view.
    }

//    @objc func tapOfScrollView(){
//        tableView.isHidden = true
//    }
//

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func MyviewTapped(_ sender: UITapGestureRecognizer) {
        if flafForSales == true {
//            tableView.center.y = -100
        }
        searchList = statesList
        flafForSales = false
        tableView.isHidden = false
        tableView.reloadData()
        state_name.becomeFirstResponder()
    }
    @objc func SalesPersonTapped(_ sender: UITapGestureRecognizer){
        if state_name.text == "" {
            toastGenrate(message: "Please Select State Name !")
        }else{
            loadSalesData()
        tableView.isHidden = false
//        tableView.center.y = 700
        flafForSales = true
        salesPerson.becomeFirstResponder()
    }
    }
    
    //Adding Done Action to keyboard
    

    
    @IBOutlet weak var phnumb: UITextField! {
        didSet { phnumb?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var pinc: UITextField! {
        didSet { phnumb?.addDoneCancelToolbar() }
    }
    
    
    func textFieldShouldReturn(_ alt_mob_no: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = alt_mob_no.superview?.viewWithTag(alt_mob_no.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            alt_mob_no.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    
    
    //------------------------------
    
    
    @objc func KeyboardApper(notification : Notification){

                // 1
                let userInfo = notification.userInfo!
        
                // 2
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let viewEndframe = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == NSNotification.Name.UIKeyboardWillHide {
                    scrollView.contentInset = UIEdgeInsets.zero
                } else{
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: viewEndframe.height, right: 0)
                }
                scrollView.scrollIndicatorInsets = scrollView.contentInset

    }
    
    
    func loadSalesData() {
//        self.sv = UIViewController.displaySpinner(onView: self.view)
//        let emp_id = preferences.string(forKey: "EMP_ID")!
        let state : String = state_name.text!
        guard let url = URL(string:"\(Constants.stockisturl)index.php?end_point=getMrList&city_name=\(state)")
            
            else {
                print("URL Error!")
                return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                
                // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(SalesPerson.self, from: data!)
                var mrArr = [String]()
                for (_,j) in (response.Mr_List?.enumerated())!{
                    mrArr.append(j.EMPLOYEE_NAME!)
                }
                self.searchList = mrArr
                self.salesFiltersArr = mrArr
                DispatchQueue.main.async {
                     self.tableView.reloadData()
                }
            }
                
            catch _ {
                
                print("Error at getting wallet data!")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "Something Went Wrong! ", preferredStyle: UIAlertControllerStyle.alert)
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
        }
        task.resume()
    }
    
    let dispatchGroup = DispatchGroup()
    
    func runThread(after sec:Int, completion: @escaping() -> Void) {
        let deadline = DispatchTime.now() + .seconds(sec)
         DispatchQueue.main.asyncAfter(deadline: deadline){
            completion()
        }
    }
    
    
    func fullValidation(gst:String,email:String,phone:String,pass1:String,pass2:String,pin:String)->Bool{
        if gst != "" {
            if !valid.isValidGST(value: gst) {
            toastGenrate(message: "Invalid GST Number !")
            return false
            }
        }
        if !valid.isValidPhone(value: phone){
            toastGenrate(message: "Invalid PhoneNumber !")
            return false
        }
        if !valid.isValidEmail(testStr: email){
            toastGenrate(message: "Invalid Email !")
            return false
        }
        
        if !valid.isValidPin(value: pin){
            toastGenrate(message: "Invalid Pin Code !")
            return false
        }
        if pass1 != pass2 {
            toastGenrate(message: "Password Not Matched !")
            return false
        }
        return true
    }
    
    
    @IBAction func owner_register_action(_ sender: AnyObject) {
   
        shnm = shop_name.text!
        ownnm = owner_name.text!
        mobno = mob_no.text!
        gstin = alt_mob_no.text!
        eid = email_id.text!
        sll = s_l_l.text!
        pin = pin_code.text!
        cty = city_name.text!
        state = state_name.text!
        passwd = password.text!
        cpasswd = cpassword.text!
        dln = drug_license_no.text!
        cpa1 = "000000"
        
    
        if Reachability.isConnectedToNetwork(){
//            if myChoice == false //chemist
//            {
                if shnm == "" || ownnm == "" || mobno == "" || eid == "" || sll == "" || pin == "" || cty == "" || state == "" || passwd == "" || cpasswd == "" {
                    print("Please enter values!")
                    self.toastGenrate(message: "Please Fill All fields!")
                }else{

                    if fullValidation(gst: gstin, email: eid, phone: mobno, pass1: passwd, pass2: cpasswd, pin: pin){
                flag = 4
               amobno = mobno
               

                self.PostData(shname: self.shnm, ownnm: self.ownnm, mobno: Int(self.mobno)!, eid: self.eid, sll: self.sll, pin: Int(self.pin)!, cty: self.cty, state: self.state, passwd: self.passwd, cpasswd: self.cpasswd, dln: self.dln, flag: self.flag, gstin: self.gstin, cap1: self.cpa1)

        }
    }
//            }else { // stockist
//                flag = 1
//
//                if shnm == "" || ownnm == "" || mobno == "" || eid == "" || sll == "" || pin == "" || cty == "" || state == "" || passwd == "" || cpa1 == "" || gstin == ""{
//                    print("Please enter values!")
//                }else{
//                    amobno = mobno
//                    dispatchGroup.enter()
//
//                    runThread(after: 0){
//                        self.PostData(shname: self.shnm, ownnm: self.ownnm, mobno: Int(self.mobno)!, eid: self.eid, sll: self.sll, pin: Int(self.pin)!, cty: self.cty, state: self.state, passwd: self.passwd, cpasswd: self.cpasswd, dln: self.dln, flag: self.flag, gstin: self.gstin, cap1: self.cpa1)
//                    }
//
//                    dispatchGroup.notify(queue: .main){
//                        print("performing segue")
//                        self.activityindicator.stopAnimating()
//                        if  self.state_val == 1 {
//                            self.performSegue(withIdentifier: "otpsegue", sender: nil)
//                        }else {
//                            print("Return error")
//                        }
//
//
//
//                }
//            }
//        }
        }else{
             DispatchQueue.main.async {
            self.view.makeToast("Please Check Internet Connection!")
            }
        }
    }
    
   
    //Hide when touch outside table view
  
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.tableView)
            print(position)
        }
    }

    

    func PostData(shname : String, ownnm : String, mobno : Int, eid : String,sll : String, pin : Int, cty : String, state : String,passwd : String,cpasswd : String,dln : String,flag:Int,gstin:String,cap1:String)
    {
        activityindicator.center = self.view.center
        activityindicator.hidesWhenStopped = true
        
        activityindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityindicator.startAnimating()
        view.addSubview(activityindicator)
        

        let reg_id = "APA91bE4fPLs93mPLRloBkEdBPxnDajAlH436KOpVGh6sVlVIelULfIknGEE18ajzjGnr5sEM469ONQynEj2He5k-8nxEpGyniQ098lL0IKFy7Rye6ifyNj9ypCvWbRaO4CXRTl5M_e9"
        let imei = 12356789
        var lat = prefrences.string(forKey: "CurrentLat")
        var long = prefrences.string(forKey: "CurrentLong")
        
        if lat == nil || long == nil {
            lat = "0"
            long = "0"
        }
        
//        let zip_id = prefrences.string(forKey: "ZipId")
        let zip_id = self.pin_code.text
        let otpflag = "false"
        
        let alldata = [reg_id,imei,lat as Any,long as Any,zip_id!,otpflag,shname,ownnm,mobno,eid,sll,pin,cty,state,passwd,cpasswd,dln,flag,gstin,cpa1] as [Any]
        
        self.prefrences.setValue(alldata, forKey: "alldata")
        
        
        let url = URL(string: Constants.liveurllet)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var postString : String = ""
//        if myChoice == false{ // chemist
            postString = "shop_name=\(shname)&name=\(ownnm)&email=\(eid)&mobileno=\(mobno)&reg_id=\(reg_id)&imei=\(imei)&pin_no=\(pin)&drug_license_no=\(dln)&city=\(cty)&state=\(state)&lat=\(String(describing: lat))&long=\(String(describing: long ))&flag=4&password=\(passwd)&otpflag=\(otpflag)&landmark=\(sll)&zip_id=\(String(describing: zip_id))&p_gstin=\(gstin)"
//        }else{
//            postString = "shop_name=\(shname)&name=\(ownnm)&email=\(eid)&mobileno=\(mobno)&reg_id=\(reg_id)&imei=\(imei)&pin_no=\(pin)&drug_license_no=\(dln)&city=\(cty)&state=\(state)&lat=\(String(describing: lat))&long=\(String(describing: long))&flag=1&password=\(passwd)&pin_covered=\(String(describing:cpa1))&otpflag=\(otpflag)&landmark=\(sll)&zip_id=\(String(describing: zip_id))&p_gstin=\(gstin)"
//        }

        request.httpBody = postString.data(using: .utf8)
        
 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                self.activityindicator.stopAnimating()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                self.activityindicator.stopAnimating()
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
            
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                //printing the json in console
                print("Printing JSON Data")
                let status : String = jsonObj?.value(forKey: "status") as! String
                let error : String = jsonObj?.value(forKey: "errormsg") as? String ?? ""
             //   print(jsonObj!.value(forKey: "errormsg")!)
                
                if status == "failure" {
                    self.state_val = 0
                     DispatchQueue.main.async {
                    self.view.makeToast(error)
                    self.activityindicator.stopAnimating()
                    }
                }
                
                if status == "success" {
 
                    let OTP : String = jsonObj!.value(forKey: "otp") as! String
                    self.prefrences.set(OTP, forKey:"otp")
                    self.state_val = 1
                    print(self.state_val)
                     print("performing segue")
                    
                    DispatchQueue.main.async {
                   
                    if  self.state_val == 1 {
                        self.setDataTOSave(flag: false)
                        self.activityindicator.stopAnimating()
                        self.performSegue(withIdentifier: "otpsegue", sender: nil)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "OTPPopUpViewController") as! OTPPopUpViewController
                        self.navigationController?.pushViewController(vc,animated: true)
                    }else {
                        self.activityindicator.stopAnimating()
                    }
              
                    }
                }
                
            }

        
        }
        task.resume()

            }


}
extension OwnerRegistrationViewController : CLLocationManagerDelegate{
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            print("location:: (location)")
        }
        
    }
    
    func toastGenrate(message : String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                self.activityindicator.stopAnimating()
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
}
