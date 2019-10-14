//
//  CartTabViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 10/09/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import  SQLite3
import UserNotifications

class CartTabViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartTab: UITabBarItem!
    @IBOutlet weak var sstbtn: UIButton!
    static var loadFlag = false
    let refreshControl : UIRefreshControl? = nil
    var stmt : OpaquePointer?
    var db : OpaquePointer?
    var cartdata = [CartData]()
    var stockistList : avilableStockistModel!
    var selected_product_id = ""
    var sv : UIView!
    var flag_for_qty = false
    let application = UIApplication.shared
    let centre = UNUserNotificationCenter.current()
    var prefrences = UserDefaults.standard
     var total : Float = 0
    @IBOutlet weak var total_price: UILabel!
    func callSegueFromCell(myData dataobject: AnyObject) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegue(withIdentifier: "editModelIdentifier", sender:dataobject )
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTabTableViewCell
        cell.delegate = self
        if cartdata[indexPath.row].PRODUCT_ID != ""{
            cell.pid = cartdata[indexPath.row].PRODUCT_ID
            cell.cartProductName.text = cartdata[indexPath.row].PRODUCT_NAME
            cell.cartProductQty.text = cartdata[indexPath.row].SELECTED_QUANTITY
            cell.PtrLbl.text = cartdata[indexPath.row].SELECTED_PRD_PRICE
            let ptr = Float(cartdata[indexPath.row].SELECTED_PRD_PRICE)!
            let total = (ptr * Float(cartdata[indexPath.row].SELECTED_QUANTITY)!)
            cell.Price.text = String(total)
            
            if cartdata[indexPath.row].SELECTED_PRD_SCHEME_VALUE != "0"{
                
                let offer = cartdata[indexPath.row].SELECTED_PRD_SCHEME_VALUE.split(separator: "+", maxSplits: 1, omittingEmptySubsequences: false)
                print(offer[0])
                let offerV = offer[0]
                
                if Int(cartdata[indexPath.row].SELECTED_QUANTITY)! >= Int(offerV)! {
                   cell.freeoffers.isHidden = false
                   
                }else{
                    cell.freeoffers.isHidden = true
                }
            }
        }
        return cell
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        cartdata.removeAll(keepingCapacity: true)
        selected_product_id = ""
        sstbtn.layer.cornerRadius = 10
        sstbtn.layer.borderWidth = 1
        sstbtn.layer.borderColor = UIColor.black.cgColor
        self.total = 0
        loadCartTableData()
        tableView.reloadData()
        self.total_price.text = String(format: "%.2f" ,self.total)
    }

    func deleteAllData(data : String){
        if Reachability.isConnectedToNetwork(){
            var resp : setOrderModel!
            let emp_id = prefrences.string(forKey: "EMP_ID")
            let url = "\(Constants.stockisturl)index.php?end_point=setChemistOrderAddToCart&che_id=\(String(emp_id!))&product_info=\(data)&os=ios"
            FetchHttpData.updateDataModels(url: url, type: setOrderModel.self){
                response in
                resp = response as? setOrderModel
                if resp.MESSAGE == "SUCCESSFULL" {
                    print("Suceess")
                }
            }
        }else{
            self.view.makeToast("Please Connect to Internet!!")
        }
    }
    func uploadData(data : String) {
        if Reachability.isConnectedToNetwork(){
        let emp_id = prefrences.string(forKey: "EMP_ID")
        var resp : setOrderModel!
        let url = "\(Constants.stockisturl)index.php?end_point=setChemistOrderAddToCart&che_id=\(String(emp_id!))&product_info=\(data)&os=ios"
        FetchHttpData.updateDataModels(url: url, type: setOrderModel.self){
            response in
            resp = response as? setOrderModel
            if resp.MESSAGE == "SUCCESSFULL" {
                print("Suceess")
            }
        }
        }else{
            self.view.makeToast("Please Connect to Internet!!")
        }
    }
    
    func loadCartTableData() {
       
        CartTabViewController.loadFlag = true
        let queryString = "SELECT * FROM \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER)"
          var count : Int = 0
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        cartdata.removeAll()
        var PID : String = ""
        var PRODUCT_NAME = ""
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let temp = CartData()
            temp.PRODUCT_NAME = ""
            temp.PRODUCT_ID = ""
            temp.SELECTED_PRD_PRICE = ""
            temp.SELECTED_QUANTITY = ""
            cartdata.append(temp)
            PID  = String(cString: sqlite3_column_text(stmt, 0))
            PRODUCT_NAME = String(cString: sqlite3_column_text(stmt, 1))
            var SELECTED_QTY = String(cString: sqlite3_column_text(stmt, 4))
            let SELECTED_PTR = String(cString: sqlite3_column_text(stmt, 6))
            let prd_scheme = String(cString: sqlite3_column_text(stmt, 8))
            let prd_scheme_qty = String(cString: sqlite3_column_text(stmt, 9))
            
            if SELECTED_QTY == "" {
                SELECTED_QTY = "1"
            }
            let a = Float(SELECTED_QTY)
            let b = Float(SELECTED_PTR)
            let mul = a! * b!
            self.total = self.total + mul
            if PID != "" {
                cartdata[count].PRODUCT_ID = PID
                cartdata[count].PRODUCT_NAME = PRODUCT_NAME
                cartdata[count].SELECTED_QUANTITY = SELECTED_QTY
                cartdata[count].SELECTED_PRD_PRICE = SELECTED_PTR
                cartdata[count].SELECTED_PRD_SCHEME_VALUE = prd_scheme
                cartdata[count].SELECTED_PRD_SCHEME_QTY = prd_scheme_qty
               // self.selected_product_id.append("\(PID)~\(SELECTED_QTY),")
                count = count+1
        
            }
        }
        
        if count == 0 {
             tableView.isHidden = true
            print("cart empty")
            let alert = UIAlertController(title: "Alert", message: "Cart Is Empty!!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                     self.performSegue(withIdentifier: "cart_to_tabsVC", sender: nil)
                case .cancel:
                    print("cancel")

                case .destructive:
                    print("destructive")


                }}))
            self.present(alert, animated: true, completion: nil)

        }else {
            tableView.isHidden = false
        }
        self.updateViewConstraints()

        if count != 0 {
            for i in 0...(count-1) {
                self.selected_product_id.append("\(cartdata[i].PRODUCT_ID)~\(cartdata[i].SELECTED_QUANTITY)~null,")
            }
            let endIndex = selected_product_id.index(selected_product_id.endIndex, offsetBy: -1)
            let truncated = selected_product_id.substring(to: endIndex)
            print(truncated)
            uploadData(data: truncated)
        }else{
            deleteAllData(data: "")
        }
    }
    
    
   
    
    let dbcon : DBConnection? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.hideKeyboardWhenTappedAround() 
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
//        tabBarController?.tabBar.items?[1].badgeValue = "2"
      
       
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MediAppDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &self.db) != SQLITE_OK {
            print("error opening database")
        }
        
        loadCartTableData()
        tableView.reloadData()
    }
    
    @IBAction func backToHome(_ sender: Any) {
        performSegue(withIdentifier: "cart_to_tabsVC", sender: nil)
    }
    
    @IBAction func searchStockistAction(_ sender: Any) {
    
        if Reachability.isConnectedToNetwork(){
        for i in cartdata {
            if i.SELECTED_QUANTITY == "" || Int(i.SELECTED_QUANTITY) == 0 {
                flag_for_qty = true
            }
        }
        
        if flag_for_qty == true {
        viewWillAppear(true)
        self.sv = UIViewController.displaySpinner(onView: self.view)
        let emp_id = prefrences.string(forKey: "EMP_ID")
        let urlstr = "\(Constants.stockisturl)?end_point=getStockiestList&emp_id=\(emp_id!)&selected_product_id=\(selected_product_id)&product_count=\(cartdata.count)&platform=ios"
        guard let url = URL(string:urlstr)
            
            else {
                print("URL Error")
                return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(avilableStockistModel.self, from: data!)
                self.stockistList = response
                DispatchQueue.main.async {
                    UIViewController.removeSpinner(spinner: self.sv)
                     self.performSegue(withIdentifier: "stockistlistsegue", sender: nil)
                }
               
               
            } catch _ {
            
                    let alert = UIAlertController(title: "Alert", message: "Stockist Not avilable!!!", preferredStyle: UIAlertControllerStyle.alert)
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
        }else{
            self.view.makeToast("You entered empty or zero in quantity!")
        }
        }else{
            self.view.makeToast("Please Connect to internet!")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cart_to_tabsVC" {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.buildNavigationDrawer(drawer: "chemist")
        }else if segue.identifier == "stockistlistsegue" {
            UIViewController.removeSpinner(spinner: sv)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "StockistListViewController") as! StockistListViewController
            newViewController.mystockistlist = stockistList
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func DeleteAllCart(_ sender: Any) {

        let alert = UIAlertController(title: "Alert", message: "Do You Really Want to EMPTY Cart!!", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.destructive, handler: { action in
            // do something like...
            let deleteStatementStirng = "DELETE FROM \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER);"
            //        let deleteStatementStirng = "DROP TABLE \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER);"
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(self.db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted cart.")
                } else {
                    print("Could not delete cart.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }
            
            sqlite3_finalize(deleteStatement)
            self.viewWillAppear(true)
            
        }))
    }
    
    func actionFromOrderNow(avsl : [StockistList]){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MediAppDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &self.db) != SQLITE_OK {
            print("error opening database")
        }
        for i in avsl {
            let id = i.SKU_ID
        let deleteStatementStirng = "DELETE FROM \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER) WHERE \(Constants.ADDTOCART_PRODUCT_ID) = '\(id)';"
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
    }
      
    }
    
}

extension CartTabViewController :CustomTableViewCellDelegate {
    func SetflagForCount(cell: CartTabTableViewCell, flag: Bool) {
        flag_for_qty = flag
    }
    
    func textChanged(cell: CartTabTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        cartdata[indexPath!.row].SELECTED_QUANTITY = cell.cartProductQty.text!
        if Float(cell.cartProductQty.text!) != 0.0 && Float(cell.cartProductQty.text!) != nil{
            let a = Float(cell.cartProductQty.text!)
            let b = Float(cell.PtrLbl.text!)
            cell.Price.text = String(Float(a!*b!))
            
            let updateStatementString = "UPDATE \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER) SET \(Constants.ADDTOCART_SELECTED_QUANTITY)= '\(cell.cartProductQty.text!)'WHERE \(Constants.ADDTOCART_PRODUCT_ID)= '\(cell.pid)';"
            
            var updateStatement: OpaquePointer? = nil
           
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Successfully updated row.")
                } else {
                    print("Could not update row.")
                }
            } else {
                print("UPDATE statement could not be prepared")
            }
            sqlite3_finalize(updateStatement)
        }
        self.total = 0
        loadCartTableData()
        self.total_price.text = String(format: "%.2f" ,self.total)
        
    }
    
    func buttonTapped(cell: CartTabTableViewCell) {
        let alert = UIAlertController(title: "Alert", message: "Do you really want to delete this product!!", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
       
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.destructive, handler: { action in
            // do something like...
            self.deleteRow(rid: cell.pid)
            
        }))
    }
    
    func deleteRow(rid:String){
        let deleteStatementStirng = "DELETE FROM \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER) WHERE \(Constants.ADDTOCART_PRODUCT_ID) = '\(rid)';"
//        let deleteStatementStirng = "DROP TABLE \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER);"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            
                if let tabBars = tabBarController?.tabBar.items {
                    let tabBar = tabBars[1]
                    let val = Int(tabBar.badgeValue!)!
                    val != 0 ? (tabBar.badgeValue = String(val - 1)) : (tabBar.badgeValue = nil)
                    
                }
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
        self.viewWillAppear(true)
    }
}






