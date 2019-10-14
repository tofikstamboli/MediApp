//
//  Tab1ViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 21/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import SQLite3
import Foundation
import iOSDropDown


class Tab1ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITabBarControllerDelegate{
    var feedModelArray = [Track]()
    var holdCartData = [CartData]()
    var schemImageData = [schemImgDataModel]()
    var pidStringForTrack = [String]()
    var pidStringForTrackfilterCount = [String]()
    var pidStringForTrackfilter = [String]()
    @IBOutlet weak var companyNameList: DropDown!
    @IBOutlet weak var categoryList: DropDown!
    @IBOutlet weak var tableView: UITableView!
    var db: OpaquePointer?
    private var ProductListObject = [Product]()
    var searchProduct = [Product]()
    var queryString = ""
    var category = "ALL"
    var company = "ALL"
    var schemData = [schemImgDataModel]()
    var searching = false
    var dbStatement: OpaquePointer? = nil
    ///var data = [String]()
    
//    @IBOutlet weak var compFilter: CompanyFilters!
    
    
    var PRODUCT_ID,PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_COMPOSITION,PRODUCT_DISCRIPTION,SCHEME,SCHEM_DESCRIPTION,SCHEME_EXP,SCHEME_QTY,SCHEME_VALUE,SCHEME_IDm,PTR,PTS,MSP,CATEGORY,IMG_URL,MANUF_ID,MANUF_NAME,PROD_STATUS,PROD_QTY : String?
    var stmt:OpaquePointer?
    var cartdata = [CartData]()
    var BannerImgs = [URL]()
    var SchemImage = [URL]()
    var ImgurlStrings = [String]()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var searchBar: UISearchBar!
    var dataCartFlg = false
    var FlagForCartBlinking = 0
    var gradientLayer: CAGradientLayer!
    static var vdlcount = 0
    var tapGestureRecognizer = UITapGestureRecognizer()
    // imageSlider And stretchi layout related variablers
    var jsnData : setOrderModel!
    var Headerview : UIView!
    var NewHeaderLayer : CAShapeLayer!
    
    private let Headerheight : CGFloat = 176
    private let Headercut : CGFloat = 00
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imgData = [URL]()
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBAction func openDrowerByButton(_ sender: Any) {
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }

    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ProductListObject.count > 0 {
        if searching {
            print(searchProduct.count)
        return searchProduct.count
        }else{
        return ProductListObject.count
        }
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableIdetifier", for: indexPath) as! FirstTabTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        if ProductListObject.count > 0 {
        if searching {
            (PRODUCT_ID,PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_COMPOSITION,PRODUCT_DISCRIPTION,SCHEME,SCHEM_DESCRIPTION,SCHEME_EXP,SCHEME_QTY,SCHEME_VALUE,SCHEME_IDm,PTR,PTS,MSP,CATEGORY,IMG_URL,MANUF_ID,MANUF_NAME,PROD_STATUS,PROD_QTY) = (searchProduct[indexPath.row].getMed())
            cell.setupWithModel(model: feedModelArray[pidStringForTrack.index(of: PRODUCT_ID ?? "")!])
            cell.lab1.text = PRODUCT_NAME!
            cell.BasicPrice.text = "PTR: ₹"+PTR!
            cell.ptr = PTR!
            cell.mrp = MSP!
            cell.discription.text = PRODUCT_COMPOSITION!
            cell.offer.text = SCHEME!
            cell.offer.text = PRODUCT_DISCRIPTION
            cell.actualPrice.text = "MRP: ₹"+MSP!
            cell.deligate = self
            cell.productDetail.SCHEME_VALUE = SCHEME_VALUE!
            cell.productDetail.SCHEME_QTY = SCHEME_QTY!
            cell.productDetail.SCHEM_DESCRIPTION = SCHEM_DESCRIPTION!
            cell.productDetail.SCHEME = SCHEME!
            cell.productDetail.SCHEME_EXP = SCHEME_EXP!
            cell.productDetail.PRODUCT_ID = PRODUCT_ID!
            cell.productDetail.PRODUCT_NAME = PRODUCT_NAME!
//            cell.productDetail.MANUFACTURE_ID = MANUF_ID!
            if SCHEME != "0" {
                cell.schems.isHidden = false
                cell.schems.text = "SCHEME : ❐"+SCHEM_DESCRIPTION!
                cell.free.text = feedModelArray[indexPath.row].freeOffer
            }else{
                cell.schems.isHidden = true
            }
            return cell //4.
        }else {
            (PRODUCT_ID,PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_COMPOSITION,PRODUCT_DISCRIPTION,SCHEME,SCHEM_DESCRIPTION,SCHEME_EXP,SCHEME_QTY,SCHEME_VALUE,SCHEME_IDm,PTR,PTS,MSP,CATEGORY,IMG_URL,MANUF_ID,MANUF_NAME,PROD_STATUS,PROD_QTY) = (ProductListObject[indexPath.row].getMed())
            cell.setupWithModel(model: feedModelArray[indexPath.row])
            cell.lab1?.text = PRODUCT_NAME
            cell.BasicPrice?.text = "PTR: ₹"+PTR!
            cell.discription?.text = PRODUCT_COMPOSITION
            cell.offer?.text = SCHEME
            cell.offer?.text = PRODUCT_DISCRIPTION
            cell.actualPrice?.text = "MRP: ₹"+MSP!
            cell.ptr = PTR!
            cell.mrp = MSP!
            cell.deligate = self
            cell.productDetail.SCHEME_VALUE = SCHEME_VALUE!
            cell.productDetail.SCHEME_QTY = SCHEME_QTY!
            cell.productDetail.SCHEM_DESCRIPTION = SCHEM_DESCRIPTION!
            cell.productDetail.SCHEME = SCHEME!
            cell.productDetail.SCHEME_EXP = SCHEME_EXP!
            cell.productDetail.PRODUCT_ID = PRODUCT_ID
            cell.productDetail.PRODUCT_NAME = PRODUCT_NAME
//            cell.productDetail.MANUFACTURE_ID = MANUF_ID!
            if SCHEME != "0" {
                cell.schems.isHidden = false
                cell.schems.text = "SCHEME : ❐"+SCHEM_DESCRIPTION!
                cell.free.text = feedModelArray[indexPath.row].freeOffer
            }else{
                cell.schems.isHidden = true
            }
            return cell //4.
        }
        }else{
            return cell
        }
    }
    
    ////////////////////////////////

    func fillDataArray(){
      //  print("count:",count)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
       
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cartdata.removeAll()
        loadCartData()
        for i in feedModelArray {
            i.invited = false
            i.freeTrack = true
        }

        tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyNameList.didSelect { (item, index, id) in
            print(item)
            self.company = item
            self.loadAllData()
        }
        
        categoryList.didSelect { (item, index, id) in
            print(item)
            self.category = item
            self.loadAllData()
        }

        let _: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        tableView.backgroundColor = UIColor.white
        Headerview = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(Headerview)
        tabBarController?.delegate = self
        NewHeaderLayer = CAShapeLayer()
        NewHeaderLayer.fillColor = UIColor.black.cgColor
        Headerview.layer.mask = NewHeaderLayer
        
        let newheight = Headerheight - Headercut / 2
        tableView.contentInset = UIEdgeInsets(top: newheight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newheight)
        
        self.Setupnewview()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        startTimer()

        self.searchBar.endEditing(true)
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.hideKeyboardWhenTappedAround()
        loadAllData()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        
        /////////----------><--------------////////
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(KeyboardApper), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(KeyboardApper), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    }

    

    func insert(choice : String,myid : String?, myname : String?, myqty : String?, mrp : String?, ptr : String?, scheme_value : String?,scheme_qty : String?,  pts : String?,  manufacture_id : String?,  manufacture_name : String?,session_id : String?,flag : String?){
        switch choice {
        case "insert":
        
            let insertStatementString = "INSERT INTO " + Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER
                + "(" + Constants.ADDTOCART_PRODUCT_ID
                + "," + Constants.ADDTOCART_PRODUCT_NAME
                + "," + Constants.ADDTOCART_MANUFACTURE_ID
                + "," + Constants.ADDTOCART_SELECTED_MANUFACTURE_NAME
                + "," + Constants.ADDTOCART_SELECTED_QUANTITY
                + "," + Constants.ADDTOCART_SELECTED_PRD_PRICE
                + "," + Constants.ADDTOCART_SELECTED_PRD_PTR
                + "," + Constants.ADDTOCART_SELECTED_PRD_PTS
                + "," + Constants.ADDTOCART_SELECTED_PRD_SCHEME_VALUE
                + "," + Constants.ADDTOCART_SELECTED_PRD_SCHEME_QTY
                + "," + Constants.ADDTOCART_SESSION_ID
                + "," + Constants.ADDTOCART_FLAG
                + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
            
            
            
            // 1
            if sqlite3_prepare_v2(db, insertStatementString, -1, &dbStatement, nil) == SQLITE_OK {
                let id: NSString = myid! as NSString
                let name: NSString = myname! as NSString
                let qty : NSString = myqty! as NSString
                let ptr : NSString = ptr! as NSString
                let mrp : NSString = mrp! as NSString
                let schemevalue : NSString = scheme_value! as NSString
                let schemeqty : NSString = scheme_qty! as NSString
                let pts : NSString = pts! as NSString
                let manuid : NSString = manufacture_id! as NSString
                let manuname : NSString = manufacture_name! as NSString
                let sessid : NSString = session_id! as NSString
                let flag : NSString = flag! as NSString
                
               
                // 2
                sqlite3_bind_text(dbStatement, 1, id.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 2, name.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 3, manuid.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 4, manuname.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 5, qty.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 6, mrp.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 7, ptr.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 8, pts.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 9, schemevalue.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 10, schemeqty.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 11, sessid.utf8String, -1, nil)
                sqlite3_bind_text(dbStatement, 12, flag.utf8String, -1, nil)
                
                // 4
                if sqlite3_step(dbStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                    if let tabBars = tabBarController?.tabBar.items {
                        let tabBar = tabBars[1]
                        let val = Int(tabBar.badgeValue ?? "0")
                        tabBar.badgeValue = String(val! + 1)
                    }
                    self.view.makeToast("Product added into cart !!")
                } else {
                    print("Could not insert row.")
                    self.view.makeToast("Product already inside cart !!")
                }
            } else {
                print("INSERT statement could not be prepared.")
                self.view.makeToast("SQL Error !!")
            }
            // 5
            
    
        
            break;
            
            case  "update" :
                
                
                let updateStatementString = "UPDATE \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER) SET \(Constants.ADDTOCART_SELECTED_QUANTITY)= '\(myqty!)'WHERE \(Constants.ADDTOCART_PRODUCT_ID)= '\(myid!)';"
                
                if sqlite3_prepare_v2(db, updateStatementString, -1, &dbStatement, nil) == SQLITE_OK {
                    if sqlite3_step(dbStatement) == SQLITE_DONE {
                        print("Successfully updated row.")
                    } else {
                        print("Could not update row.")
                    }
                } else {
                    print("UPDATE statement could not be prepared")
                }
                
            break;
            
            case "delete" :
                
                let deleteStatementStirng = "DELETE FROM \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER) WHERE \(Constants.ADDTOCART_PRODUCT_ID) = '\(String(myid!))';"
               
                if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &dbStatement, nil) == SQLITE_OK {
                    if sqlite3_step(dbStatement) == SQLITE_DONE {
                        print("Successfully deleted row.")
                    } else {
                        print("Could not delete row.")
                    }
                } else {
                    print("DELETE statement could not be prepared")
                }
                
                
                
            break;
            
        default:
            sqlite3_finalize(dbStatement)
            break;
        }
    }
    
    @objc func KeyboardApper(notification : Notification){
        
 
        // 1
        let userInfo = notification.userInfo!

        // 2
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let viewEndframe = view.convert(keyboardScreenEndFrame, from: view.window)
        NewHeaderLayer = CAShapeLayer()
        NewHeaderLayer.fillColor = UIColor.black.cgColor
        Headerview.layer.mask = NewHeaderLayer

        let newheight = Headerheight - Headercut / 2

        if notification.name == NSNotification.Name.UIKeyboardWillHide {
            tableView.contentInset = UIEdgeInsets(top: newheight, left: 0, bottom: 0, right: 0)
        } else{
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: viewEndframe.height, right: 0)
//            tableView.setContentOffset(.zero, animated: true)
            
            print("Keyboard else")
        }
//        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        
    }
    
    
    
    func startTimer() {
        
        _ =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = collectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < imgData.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
    }
    
    
    
    func Setupnewview() {
        let newheight = Headerheight - Headercut / 2
        var getheaderframe = CGRect(x: 0, y: -newheight, width: tableView.bounds.width, height: Headerheight)
        if tableView.contentOffset.y < newheight
        {
            getheaderframe.origin.y = tableView.contentOffset.y
            getheaderframe.size.height = -tableView.contentOffset.y + Headercut / 2
        }
        
        Headerview.frame = getheaderframe
        let cutdirection = UIBezierPath()
        cutdirection.move(to: CGPoint(x: 0, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: getheaderframe.height))
        cutdirection.addLine(to: CGPoint(x: 0, y: getheaderframe.height - Headercut))
        NewHeaderLayer.path = cutdirection.cgPath
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.decelerationRate = UIScrollView.DecelerationRate.greatestFiniteMagnitude
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.Setupnewview()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

    @objc func doSomething(refreshControl: UIRefreshControl) {
        loadAllData()
        refreshControl.endRefreshing()
    }
    


    func loadImges() {

        let queryString1 = "SELECT * FROM \(Constants.TABLE_GST_SCHEME_OFFER_IMAGES)"

        if sqlite3_prepare(db, queryString1, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        var cnt : Int = 0
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let temp = schemImgDataModel()
            temp.schemUrl = ""
            temp.productId = ""
            temp.BigUrl = ""
            temp.SchemFlag = ""
            schemImageData.append(temp)
            let schemUrl = String(cString: sqlite3_column_text(stmt, 0))
            let productId = String(cString: sqlite3_column_text(stmt, 1))
            let BigUrl = String(cString: sqlite3_column_text(stmt, 2))
            let SchemFlag = String(cString: sqlite3_column_text(stmt, 3))
            if schemUrl != "NULL" {
//                if SchemFlag == "1" {
                    schemImageData[cnt].schemUrl = schemUrl
                    schemImageData[cnt].productId = productId
                    schemImageData[cnt].BigUrl = BigUrl
                    schemImageData[cnt].SchemFlag = SchemFlag
                
//                    let myurl = schemUrl.replacingOccurrences(of: " ", with: "%20")
//
//                    SchemImage.append(URL(string: myurl) ?? URL(string: "http://leeford.in/wp-content/uploads/2017/09/image-not-found.jpg")!)
               
//                }else{
                let bigUrl = BigUrl.replacingOccurrences(of: " ", with: "%20")
                let myurl = schemUrl.replacingOccurrences(of: " ", with: "%20")
                imgData.append(URL(string: myurl) ?? URL(string: "http://leeford.in/wp-content/uploads/2017/09/image-not-found.jpg")!)
                ImgurlStrings.append(bigUrl)
                cnt = cnt+1
//                }
            }
        }
    }
    
    func loadDropDownData()
    {
        let queryString1 = "SELECT distinct \(Constants.PROD_CATEGORY_NAME) FROM \(Constants.TABLE_GST_PRODUCT_MASTER)"
        if sqlite3_prepare(db, queryString1, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        categoryList.optionArray.append("ALL")
        companyNameList.optionArray.append("ALL")
        while(sqlite3_step(stmt) == SQLITE_ROW){
  
          //  let MANUFACTURE_NAME = String(cString: sqlite3_column_text(stmt, 0))
            let PROD_CATEGORY_NAME = String(cString: sqlite3_column_text(stmt, 0))
           
           categoryList.optionArray.append(PROD_CATEGORY_NAME)
           // companyNameList.optionArray.append(MANUFACTURE_NAME)
        }
        let queryString2 = "SELECT distinct \(Constants.MANUFACTURE_NAME) FROM \(Constants.TABLE_GST_PRODUCT_MASTER)"
        if sqlite3_prepare(db, queryString2, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            
             let MANUFACTURE_NAME = String(cString: sqlite3_column_text(stmt, 0))
            companyNameList.optionArray.append(MANUFACTURE_NAME)
        }
    }
    
    func loadCartData() {
        /// Select Cart values //
        let queryString1 = "SELECT * FROM \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER)"
        if sqlite3_prepare(db, queryString1, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        var cnt : Int = 0
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let temp = CartData()
            temp.PRODUCT_ID = ""
            temp.PRODUCT_NAME = ""
            temp.SELECTED_QUANTITY = ""
            cartdata.append(temp)
            let PRODUCT_ID = String(cString: sqlite3_column_text(stmt, 0))
            let PRODUCT_NAME = String(cString: sqlite3_column_text(stmt, 1))
            let PRODUCT_QTY = String(cString: sqlite3_column_text(stmt, 4))
            let ptr = String(cString: sqlite3_column_text(stmt, 6))
            if PRODUCT_QTY != "" {

                cartdata[cnt].PRODUCT_ID = PRODUCT_ID
                cartdata[cnt].PRODUCT_NAME = PRODUCT_NAME
                cartdata[cnt].SELECTED_QUANTITY = PRODUCT_QTY
                cartdata[cnt].SELECTED_PRD_PRICE = ptr
                
                cnt = cnt+1
            }
           
        }
        if let tabBars = tabBarController?.tabBar.items {
            
            let tabBar = tabBars[1]
            if cnt != 0{
            tabBar.badgeValue = String(cnt)
            }else{
               tabBar.badgeValue = nil
            }
        }
        
        
        //-------------------//
        
    }
    
   
    
    func loadAllData(){
        fillDataArray()
        ProductListObject.removeAll()
        searchProduct.removeAll()
        pidStringForTrack.removeAll()
        pidStringForTrackfilter.removeAll()
        companyNameList.optionArray.removeAll()
        feedModelArray.removeAll()
        holdCartData.removeAll()
        categoryList.optionArray.removeAll()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MediAppDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &self.db) != SQLITE_OK {
            print("error opening database")
        }
        loadDropDownData()
        loadCartData()
            if schemImageData.count <= 0 {
                loadImges()
            }
        if category == "ALL" && company == "ALL"{
             queryString = "SELECT * FROM \(Constants.TABLE_GST_PRODUCT_MASTER)"}else if company == "ALL"{
             queryString = "SELECT * FROM \(Constants.TABLE_GST_PRODUCT_MASTER) where \(Constants.PROD_CATEGORY_NAME) = '\(category)'"
        }else if category == "ALL"{
                queryString = "SELECT * FROM \(Constants.TABLE_GST_PRODUCT_MASTER) where \(Constants.MANUFACTURE_NAME) = '\(company)'"
        }else {
             queryString = "SELECT * FROM \(Constants.TABLE_GST_PRODUCT_MASTER) where \(Constants.MANUFACTURE_NAME) = '\(company)' and \(Constants.PROD_CATEGORY_NAME) = '\(category)'"
        }

        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
            

        while(sqlite3_step(stmt) == SQLITE_ROW){
            //Thread 1: EXC_BAD_ACCESS (code=1, address=0x8) sometime this error come here
            
            
            let PRODUCT_ID = String(cString: sqlite3_column_text(stmt, 0))
            let PRODUCT_NAME = String(cString: sqlite3_column_text(stmt, 1))
            let PRODUCT_TYPE = String(cString: sqlite3_column_text(stmt, 2))
            let PRODUCT_COMPOSITION = String(cString: sqlite3_column_text(stmt, 3))
            let PRODUCT_DISCRIPTION = String(cString: sqlite3_column_text(stmt, 4))
            let SCHEME = String(cString: sqlite3_column_text(stmt, 5))
            let SCHEM_DESCRIPTION = String(cString: sqlite3_column_text(stmt, 6))
            let SCHEME_EXP = String(cString: sqlite3_column_text(stmt, 7))
            let SCHEME_QTY = String(cString: sqlite3_column_text(stmt, 8))
            let SCHEME_VALUE = String(cString: sqlite3_column_text(stmt, 9))
            let SCHEME_ID = String(cString: sqlite3_column_text(stmt, 10))
            let PTR = String(cString: sqlite3_column_text(stmt, 11))
            let PTS = String(cString: sqlite3_column_text(stmt, 12))
            let MSP = String(cString: sqlite3_column_text(stmt, 13))
            let CATEGORY = String(cString: sqlite3_column_text(stmt, 14))
            let IMG_URL = String(cString: sqlite3_column_text(stmt, 15))
            let trimmedString = IMG_URL.trimmingCharacters(in: .whitespaces)
            let newUrl = trimmedString.replacingOccurrences(of: " ", with: "%20")
            let MANUF_ID = String(cString: sqlite3_column_text(stmt, 16))
            let MANUF_NAME = String(cString: sqlite3_column_text(stmt, 17))
            let PROD_STATUS = String(cString: sqlite3_column_text(stmt, 18))
            let PROD_QTY = String(cString: sqlite3_column_text(stmt, 19))
            
        
            pidStringForTrack.append(PRODUCT_ID)
            pidStringForTrackfilter.append(PRODUCT_NAME)

            
            
            ProductListObject.append(Product(PRODUCT_ID: PRODUCT_ID, PRODUCT_NAME: PRODUCT_NAME, PRODUCT_TYPE: PRODUCT_TYPE, PRODUCT_COMPOSITION: PRODUCT_COMPOSITION, PRODUCT_DISCRIPTION: PRODUCT_DISCRIPTION, SCHEME: SCHEME, SCHEM_DESCRIPTION: SCHEM_DESCRIPTION, SCHEME_EXP: SCHEME_EXP, SCHEME_QTY: SCHEME_QTY, SCHEME_VALUE: SCHEME_VALUE, SCHEME_IDm: SCHEME_ID, PTR: PTR, PTS: PTS, MSP: MSP, CATEGORY: CATEGORY, IMG_URL: newUrl, MANUF_ID: MANUF_ID, MANUF_NAME: MANUF_NAME, PROD_STATUS: PROD_STATUS, PROD_QTY: PROD_QTY))
            
        }
            searchProduct = ProductListObject
            var count = 0
        
            if searching {
         count = searchProduct.count
            } else {
                count = ProductListObject.count
            }
        for _ in stride(from: 0, through: count, by: 1){
            let  newModel = Track()
            let cartHoldModel = CartData()
            newModel.invited = false
            newModel.pname = "dummy--\(String(describing: index))"
            newModel.qty = ""
            cartHoldModel.PRODUCT_ID = ""
            cartHoldModel.PRODUCT_NAME = ""
            cartHoldModel.SELECTED_QUANTITY = ""
            cartHoldModel.SELECTED_PRD_PRICE = ""
            cartHoldModel.SELECTED_PRD_SCHEME_VALUE = ""
            holdCartData.append(cartHoldModel)
            feedModelArray.append(newModel)
        }
           tableView.reloadData()
    }
}
extension Tab1ViewController : MyCustomTabViewDeligate,UISearchBarDelegate {
    
    func schemeTapped(cell: FirstTabTableViewCell) {
        
        var message = "𝑆𝒄𝘩𝒆𝙢𝒆 ➤ "+cell.productDetail.SCHEM_DESCRIPTION!+"\n𝑃𝙧ő𝑑𝑢𝒄𝒕 ➤ "+cell.productDetail.PRODUCT_NAME!
        message = message + "\n 𝐸𝒙𝒑𝙞𝙧𝐲 𝘿a𝐭𝑒 ➤ " + cell.productDetail.SCHEME_EXP!
        
        let alert = UIAlertController(title: "Scheme Detail:", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        alert.setTitlet(font: UIFont (name: "HelveticaNeue-UltraLight", size: 20), color: UIColor.red)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didAddQty(cell: FirstTabTableViewCell) {
        let indexPath = pidStringForTrack.index(of: cell.productDetail.PRODUCT_ID!)
        
        insert(choice: "update", myid: cell.productDetail.PRODUCT_ID!, myname: nil, myqty: cell.tv.text,mrp: cell.actualPrice.text!, ptr: cell.BasicPrice.text!, scheme_value: nil, scheme_qty: nil, pts: nil, manufacture_id: nil, manufacture_name: nil, session_id: nil, flag: nil)
        holdCartData[indexPath!].PRODUCT_NAME = cell.lab1.text!
        holdCartData[indexPath!].PRODUCT_ID = cell.productDetail.PRODUCT_ID!
        holdCartData[indexPath!].SELECTED_QUANTITY = cell.tv.text!
        holdCartData[indexPath!].PRODUCT_ID = cell.productDetail.PRODUCT_ID!
        holdCartData[indexPath!].SELECTED_PRD_PRICE = cell.productDetail.PTR!
        feedModelArray[indexPath!].invited = cell.mySwitch.isOn
        feedModelArray[indexPath!].qty = cell.tv.text!
        feedModelArray[indexPath!].pid = cell.productDetail.PRODUCT_ID
        
        if cell.tv.text != "" && cell.productDetail.SCHEME_QTY != "0"{
            let free = checkSchemOffers(qty: Int(cell.tv.text!)!, schemQty: Int(cell.productDetail.SCHEME_QTY!)!, value: Int(cell.productDetail.SCHEME_VALUE!)!)
            if free != 0 {
                cell.free.isHidden = false
                cell.free.text = "Free: "+String(free)
                feedModelArray[indexPath!].freeTrack = cell.free.isHidden
                feedModelArray[indexPath!].freeOffer = "Free: "+String(free)
            }else{
                cell.free.isHidden = true
                feedModelArray[indexPath!].freeTrack = cell.free.isHidden
                feedModelArray[indexPath!].freeOffer = "Free: "+String(free)
            }
        }
    }
    
    func didSubQty(cell: FirstTabTableViewCell) {
        let indexPath = pidStringForTrack.index(of: cell.productDetail.PRODUCT_ID!)
        
        insert(choice: "update", myid: cell.productDetail.PRODUCT_ID!, myname: nil, myqty: cell.tv.text,mrp: cell.actualPrice.text!, ptr: cell.BasicPrice.text!, scheme_value: nil, scheme_qty: nil, pts: nil, manufacture_id: nil, manufacture_name: nil, session_id: nil, flag: nil)
        holdCartData[indexPath!].PRODUCT_NAME = cell.lab1.text!
        holdCartData[indexPath!].PRODUCT_ID = cell.productDetail.PRODUCT_ID!
        holdCartData[indexPath!].SELECTED_QUANTITY = cell.tv.text!
        holdCartData[indexPath!].SELECTED_PRD_PRICE = cell.productDetail.PTR!
        holdCartData[indexPath!].SELECTED_PRD_SCHEME_VALUE = cell.productDetail.SCHEME!
        feedModelArray[indexPath!].invited = cell.mySwitch.isOn
        feedModelArray[indexPath!].qty = cell.tv.text!
        feedModelArray[indexPath!].pid = cell.productDetail.PRODUCT_ID
        if cell.tv.text != "" && cell.productDetail.SCHEME_QTY != "0"{
            let offer = checkSchemOffers(qty: Int(cell.tv.text!)!, schemQty: Int(cell.productDetail.SCHEME_QTY!)!, value: Int(cell.productDetail.SCHEME_VALUE!)!)
            if offer != 0 {
                cell.free.isHidden = false
                cell.free.text = "Free: "+String(offer)
                feedModelArray[indexPath!].freeTrack = cell.free.isHidden
                feedModelArray[indexPath!].freeOffer = "Free: "+String(offer)
            }else{
                cell.free.isHidden = true
                feedModelArray[indexPath!].freeTrack = cell.free.isHidden
                feedModelArray[indexPath!].freeOffer = "Free: "+String(offer)
            }
        }
    }
    

    func didEndEditing(cell: FirstTabTableViewCell) {
        tableView.isScrollEnabled = true
        
    }
    func didTvTap(cell: FirstTabTableViewCell) {
//      tableView.isScrollEnabled = false
    }

    func checkSchemOffers(qty:Int,schemQty:Int,value:Int) -> Int{
       print(qty,schemQty,value)
       let rem = qty / schemQty
        if rem > 0 {
            return value * rem
        }else{
            return 0
        }
    }
    
    @objc func freeOfferAction() -> Void {
        print("a")
    }
    
    func didQTYEnter(cell: FirstTabTableViewCell) {
        let indexPath = pidStringForTrack.index(of: cell.productDetail.PRODUCT_ID!)
      
        if (Float(cell.tv.text!) == 0.0){
                        cell.tv.text = "1"
                        print("Unwanted Entry")
            insert(choice: "update", myid: cell.productDetail.PRODUCT_ID!, myname: nil, myqty: cell.tv.text, mrp: cell.actualPrice.text!, ptr: cell.BasicPrice.text!, scheme_value: nil, scheme_qty: nil, pts: nil, manufacture_id: nil, manufacture_name: nil, session_id: nil, flag: nil)
                        holdCartData[indexPath!].PRODUCT_NAME = cell.lab1.text!
                        holdCartData[indexPath!].PRODUCT_ID = cell.productDetail.PRODUCT_ID!
                        holdCartData[indexPath!].SELECTED_PRD_PRICE = cell.productDetail.PTR!
                        holdCartData[indexPath!].SELECTED_QUANTITY = cell.tv.text!
                        holdCartData[indexPath!].SELECTED_PRD_SCHEME_VALUE = cell.productDetail.SCHEME!
                        feedModelArray[indexPath!].invited = cell.mySwitch.isOn
                        feedModelArray[indexPath!].qty = cell.tv.text!
                        feedModelArray[indexPath!].pid = cell.productDetail.PRODUCT_ID
        }else{

            if cell.tv.text != "" && cell.productDetail.SCHEME_QTY != "0"{
            let offer = checkSchemOffers(qty: Int(cell.tv.text!)!, schemQty: Int(cell.productDetail.SCHEME_QTY!)!, value: Int(cell.productDetail.SCHEME_VALUE!)!)
                if offer != 0 {
                cell.free.isHidden = false
                cell.free.text = "Free: "+String(offer)
                feedModelArray[indexPath!].freeTrack = cell.free.isHidden
                feedModelArray[indexPath!].freeOffer = "Free: "+String(offer)
                }else{
                     cell.free.isHidden = true
                     feedModelArray[indexPath!].freeTrack = cell.free.isHidden
                    feedModelArray[indexPath!].freeOffer = "Free: "+String(offer)
                }
            }
            
            insert(choice: "update", myid: cell.productDetail.PRODUCT_ID!, myname: nil, myqty: cell.tv.text, mrp: nil, ptr: nil,scheme_value: nil,scheme_qty: nil, pts: nil, manufacture_id: nil, manufacture_name: nil, session_id: nil, flag: nil)
                        print("Updated!")
                        holdCartData[indexPath!].PRODUCT_NAME = cell.lab1.text!
                        holdCartData[indexPath!].PRODUCT_ID = cell.productDetail.PRODUCT_ID!
                        holdCartData[indexPath!].SELECTED_PRD_PRICE = cell.productDetail.PTR!
                        holdCartData[indexPath!].SELECTED_QUANTITY = cell.tv.text!
                        holdCartData[indexPath!].SELECTED_PRD_SCHEME_VALUE = cell.productDetail.SCHEME!
                        feedModelArray[indexPath!].invited = cell.mySwitch.isOn
                        feedModelArray[indexPath!].qty = cell.tv.text!
                        feedModelArray[indexPath!].pid = cell.productDetail.PRODUCT_ID
        }
        
        
        
    }
    
    func viewInfo(cell: FirstTabTableViewCell) {
        
        
        
      let indexPath = pidStringForTrack.index(of: cell.productDetail.PRODUCT_ID!)
        print(pidStringForTrack.count)
       (PRODUCT_ID,PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_COMPOSITION,PRODUCT_DISCRIPTION,SCHEME,SCHEM_DESCRIPTION,SCHEME_EXP,SCHEME_QTY,SCHEME_VALUE,SCHEME_IDm,PTR,PTS,MSP,CATEGORY,IMG_URL,MANUF_ID,MANUF_NAME,PROD_STATUS,PROD_QTY) = (searchProduct[indexPath!].getMed())
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sender = storyboard.instantiateViewController(withIdentifier: "ProductDetailPopUpViewController") as! ProductDetailPopUpViewController
        sender.pname = PRODUCT_NAME!
        sender.pcategory = CATEGORY!
        sender.compo = PRODUCT_COMPOSITION!
        sender.ppack = PRODUCT_DISCRIPTION!
        sender.pschemes = SCHEME!
        sender.pptr = PTR!
        sender.pmrp = MSP!
        sender.img = IMG_URL!
        sender.company = MANUF_NAME!
        navigationController?.pushViewController(sender,animated: true)
    }
    
    func didTappedSwitch(cell: FirstTabTableViewCell) {
        
       
        let indexPath = pidStringForTrack.index(of: cell.productDetail.PRODUCT_ID!)
            //tableView.indexPath(for: cell)
        if cell.mySwitch.isOn == false {
            holdCartData.remove(at: indexPath!)
            cell.addQtyBtn.isHidden = true
            cell.subQtyBtn.isHidden = true

           
            insert(choice: "delete", myid: cell.productDetail.PRODUCT_ID!, myname: nil, myqty: nil, mrp: nil, ptr: nil, scheme_value: nil, scheme_qty: nil, pts: nil, manufacture_id: nil, manufacture_name: nil, session_id: nil, flag: nil)
                self.view.makeToast("Product Deleted")
            if let tabBars = tabBarController?.tabBar.items {
                let tabBar = tabBars[1]
                let val = Int(tabBar.badgeValue!)
                val == 0 ? (tabBar.badgeValue = nil) : (tabBar.badgeValue = String(val! - 1))
            }
           
        }else{
            
            cell.addQtyBtn.isHidden = false
            cell.subQtyBtn.isHidden = false
           
            insert(choice: "insert", myid: cell.productDetail.PRODUCT_ID!, myname: cell.lab1.text!, myqty: "1", mrp: cell.mrp, ptr: cell.ptr, scheme_value : cell.productDetail.SCHEME!, scheme_qty: cell.productDetail.SCHEME_QTY, pts: cell.productDetail.PTS, manufacture_id: cell.productDetail.MANUF_ID, manufacture_name: cell.productDetail.MANUF_NAME, session_id: "", flag: "")
            
            
            let val = holdCartData.contains {
                $0.PRODUCT_ID == cell.productDetail.PRODUCT_ID
            }
            print(val)
        }
        
        feedModelArray[indexPath!].invited = cell.mySwitch.isOn
            feedModelArray[indexPath!].qty = "1"
            holdCartData[indexPath!].PRODUCT_NAME = cell.lab1.text!
            holdCartData[indexPath!].PRODUCT_ID = cell.productDetail.PRODUCT_ID!
            holdCartData[indexPath!].SELECTED_PRD_PRICE = cell.productDetail.PTR!
            holdCartData[indexPath!].SELECTED_QUANTITY = cell.tv.text!
            holdCartData[indexPath!].SELECTED_PRD_SCHEME_VALUE = cell.productDetail.SCHEME!
            feedModelArray[indexPath!].invited = cell.mySwitch.isOn
            feedModelArray[indexPath!].pid = cell.productDetail.PRODUCT_ID
            feedModelArray[indexPath!].qty = cell.tv.text!
            feedModelArray[indexPath!].pid = cell.productDetail.PRODUCT_ID
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchProduct.removeAll()
        if searchText.count == 0 {
            searchProduct.removeAll()
            ProductListObject.removeAll()
            pidStringForTrack.removeAll()
          //  pidStringForTrackfilter.removeAll()
           // pidStringForTrackfilterCount.removeAll()

            loadAllData()
           tableView.reloadData()
        }else{
            searchProduct.removeAll()
            ProductListObject.removeAll()
            pidStringForTrack.removeAll()
         //   pidStringForTrackfilter.removeAll()
            loadAllData()

            searchProduct = ProductListObject.filter({ $0.PRODUCT_DISCRIPTION!.lowercased().contains(searchText.lowercased()) || $0.PRODUCT_NAME!.lowercased().contains(searchText.lowercased()) ||
                $0.PRODUCT_COMPOSITION!.lowercased().contains(searchText.lowercased())})
            
           // pidStringForTrackfilterCount.removeAll()

            pidStringForTrack.removeAll()
            
            for (index, element) in searchProduct.enumerated() {
                print(index, ":", element)
                pidStringForTrack.append(searchProduct[index].PRODUCT_ID!)
                
            }
            print(pidStringForTrack)
   
            searching = true
            tableView.reloadData()
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
            if numberOfRows != 0 {
            self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
            }

        }
    }

  
   
}

extension Tab1ViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! sliderCollectionViewCell
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.addGestureRecognizer(self.tapGestureRecognizer)
        cell.imageView!.kf.setImage(with: imgData[indexPath.row], options: [.transition(.fade(0.2))])
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let p = tapGestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        if ImgurlStrings[indexPath?.row ?? 0] != "NULL" {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ZoomingViewController") as! ZoomingViewController
        vc.url = ImgurlStrings[indexPath?.row ?? 0]
        navigationController?.pushViewController(vc,animated: true)
        }else{
            self.view.makeToast("Image Not Found!")
        }
    }
    
}
extension Tab1ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension UIView{
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
    
    
    
}
