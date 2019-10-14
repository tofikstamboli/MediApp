//
//  OrdersDetailViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 11/01/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit
import Foundation
struct CheckTrack {
    var check : Bool = false
}

class OrdersDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BEMCheckBoxDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var status_name, chemist_id, ord_id, org_id : String!
    var responseData : Any!
    var finalDataApproved : ApprovedDetailModel!
    var finalTableList = [ApprovedData]()
    var finalDataPending : PendingDetailModel! // used for postpone also
    var finalDataDecline : DeclineDetailModel!
    var checkBoxCount = 0
    var checkTrack = [CheckTrack]()
    @IBOutlet weak var stockist_nm: UILabel!
    @IBOutlet weak var invoice_id: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var gstIn: UILabel!
    @IBOutlet weak var netTotal: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mAsDelivered: UIButton!
    @IBOutlet weak var checkBoxAll: BEMCheckBox!
    var cancelOrderDetailValues : String = ""
    var cancelOrderTrack = [String]()
    var cancelOrderIndexes = [String]()
    let cs = CharacterSet.init(charactersIn: "Free")
    var sv = UIView()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderDetailTableViewCell
        
        cell.del = (self as SingleCheckProtocol)
        
        cell.checkBoxOne.isHidden = true
        
        cancelOrderTrack.append(finalTableList[indexPath.row].SKU_ID!)
        
        cancelOrderIndexes.append("")
        
        cell.cellData = finalTableList[indexPath.row]
        if status_name == "pending" || status_name == "postpone"{
            cell.checkBoxOne.isHidden = false
            mAsDelivered.backgroundColor = UIColor.gray
            mAsDelivered.setTitle("CANCEL", for: UIControlState.normal)
            
            cell.checkBoxOne.setOn(checkTrack[indexPath.row].check, animated: false)
            
            if checkBoxCount != 0 && checkBoxCount == finalDataPending.pending_order_details?.count{
                cell.checkBoxOne.setOn(true, animated: false)
                mAsDelivered.isHidden = false
                

                let val = finalTableList[indexPath.row].ORDL! + "~" + finalTableList[indexPath.row].SKU_ID! + "~" + finalTableList[indexPath.row].ORDER_QUANTITY! + "~" + finalTableList[indexPath.row].SUB_TOTAL! + "*"
                
                cancelOrderDetailValues = cancelOrderDetailValues + val
                
            }else if checkBoxCount == 0 {
                cell.checkBoxOne.setOn(false, animated: false)
                mAsDelivered.isHidden = true
            }else{
                 mAsDelivered.isHidden = false
            }
        }
        cell.pName.text = finalTableList[indexPath.row].PRODUCT_NAME
        cell.ptrQty.text = (finalTableList[indexPath.row].ORDER_QUANTITY ?? "0")+" * "+(finalTableList[indexPath.row].UNIT_PRICE ?? "0")
        cell.netTotal.text = finalTableList[indexPath.row].PRICE
        if finalTableList[indexPath.row].FREE_SKU_QUANTITY == nil || finalTableList[indexPath.row].FREE_SKU_QUANTITY == "0"{
            cell.offer.text = "-"
        }else{
        let str = finalTableList[indexPath.row].FREE_SKU_QUANTITY
        cell.offer.text = str
        }
        cell.redeem_points.text = "Points Credited : "
       cell.redeem_points.text?.append(finalTableList[indexPath.row].REDEEM_POINTS ?? "0")
        
        
        return cell
    }
 
    @IBAction func allCheckAction(_ sender: Any) {
        var i = 0
        if self.checkBoxAll.on == true {
            checkBoxCount = finalDataPending.pending_order_details?.count ?? 0
            i = 0
            for _ in finalTableList{
                checkTrack[i].check = true
                i += 1
            }
            
            mAsDelivered.isHidden = false
        }else{
            i = 0
            checkBoxCount = 0
            mAsDelivered.isHidden = true
            for _ in finalTableList{
                checkTrack[i].check = false
                i += 1
            }
        }
        tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sv = UIViewController.displaySpinner(onView: self.view)
        self.checkBoxAll.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        checkBoxAll.delegate = self
        mAsDelivered.layer.cornerRadius = 10
        mAsDelivered.layer.borderWidth = 1
        mAsDelivered.layer.borderColor = UIColor.black.cgColor
        loadData()
    }
    
   
    
    func loadData(){
        if status_name == "approved" {
            self.checkBoxAll.isHidden = true
            let url = Constants.stockisturl+"?end_point=getApprovedOrdersDetails&emp_id=\(String(chemist_id))&order_id=\(String(ord_id))&org_id=\(String(org_id))"
            
            loadData(url: url, complition: { (value) in
                guard let value = value else {
                    return
                }
                // process value
                self.manageTableRows(value: value)
            })
        }
        /////// Pending /////////////
        if status_name == "pending" {
            self.checkBoxAll.isHidden = false
            let url = Constants.stockisturl+"?end_point=getPendingOrdersDetails&emp_id=\(String(chemist_id))&order_id=\(String(ord_id))&org_id=\(String(org_id))"
            
            loadData(url: url, complition: { (value) in
                guard let value = value else {
                    return
                }
                // process value
                
                self.manageTableRows(value: value)
            })
        }
        
        if status_name == "decline" {
            self.checkBoxAll.isHidden = true
            let url = Constants.stockisturl+"?end_point=getDeclinedOrderDetails&emp_id=\(String(chemist_id))&order_id=\(String(ord_id))&org_id=\(String(org_id))"
            
            loadData(url: url, complition: { (value) in
                guard let value = value else {
                    return
                }
                // process value
                
                self.manageTableRows(value: value)
            })
        }
        
        if status_name == "postpone" {
            self.checkBoxAll.isHidden = false
            let url = Constants.stockisturl+"?end_point=getPostponeOrdersDetailsView&emp_id=\(String(chemist_id))&order_id=\(String(ord_id))&org_id=\(String(org_id))"
            
            loadData(url: url, complition: { (value) in
                guard let value = value else {
                    return
                }
                // process value
                
                self.manageTableRows(value: value)
            })
        }
    }
    
    func manageTableRows(value : Any) {
        var i = 0
        if self.status_name == "approved"{
        self.finalDataApproved = value as? ApprovedDetailModel
            if finalDataApproved.org_approved_order_details?.count ?? 0 > 0 {
            for  n in self.finalDataApproved.org_approved_order_details! {
                var model = ApprovedData()
                model = n
                self.finalTableList.append(model)
//                if n.PRICE != "0.00" {
//                    self.finalTableList.append(model)
//                }else {
//                    i = 0
//                    for n1 in self.finalTableList {
//                        if n1.SKU_ID == n.SKU_ID {
//                            self.finalTableList[i].FREE_SKU_QUANTITY = "Free" + n.ORDER_QUANTITY!
//                            break
//                        }
//                        i = i + 1
//                    }
//                }
//
            }
            }
            DispatchQueue.main.async {
                
                self.stockist_nm.text = self.finalDataApproved.org_approved_order_details?[0].SHOP_NAME
                self.invoice_id.text = self.finalDataApproved.org_approved_order_details?[0].SALES_INVOICE_NO
                self.date.text = self.finalDataApproved.org_approved_order_details?[0].LAST_MODIFIED
                self.discount.text = self.finalDataApproved.org_approved_order_details?[0].DISCOUNT
                self.gstIn.text = self.finalDataApproved.org_approved_order_details?[0].GST_NUMBER
                self.netTotal.text = self.finalDataApproved.org_approved_order_details?[0].TOTAL_PRICE
                self.address.text = self.finalDataApproved.org_approved_order_details?[0].ADDRESS
                self.status.text = self.status_name
                self.tableView.reloadData()
                UIViewController.removeSpinner(spinner: self.sv)
            }
        }else if self.status_name == "pending"{
            self.finalDataPending = value as? PendingDetailModel
            if finalDataPending.pending_order_details?.count ?? 0 > 0 {
            for  n in self.finalDataPending.pending_order_details! {
                var model = ApprovedData()
                model = n
                var trackModel = CheckTrack()
                trackModel.check = false
                checkTrack.append(trackModel)
                self.finalTableList.append(model)
//                if n.PRICE != "0.00" {
//                    self.finalTableList.append(model)
//                }else {
//                    i = 0
//                    for n1 in self.finalTableList {
//                        if n1.SKU_ID == n.SKU_ID {
//                            self.finalTableList[i].FREE_SKU_QUANTITY = "Free" + n.ORDER_QUANTITY!
//                            break
//                        }
//                        i = i + 1
//                    }
//                }
                
            }
            }
            DispatchQueue.main.async {

                self.mAsDelivered.isHidden = true
                self.stockist_nm.text = self.finalDataPending.pending_order_details?[0].SHOP_NAME
                self.invoice_id.text = self.finalDataPending.pending_order_details?[0].SALES_INVOICE_NO
                self.date.text = self.finalDataPending.pending_order_details?[0].LAST_MODIFIED
                self.discount.text = self.finalDataPending.pending_order_details?[0].DISCOUNT
                self.gstIn.text = self.finalDataPending.pending_order_details?[0].GST_NUMBER
                self.netTotal.text = self.finalDataPending.pending_order_details?[0].TOTAL_PRICE
                self.address.text = self.finalDataPending.pending_order_details?[0].ADDRESS
                self.status.text = self.status_name
                self.tableView.reloadData()
                UIViewController.removeSpinner(spinner: self.sv)
            }
        }else if self.status_name == "decline"{
                self.finalDataDecline = value as? DeclineDetailModel
                if finalDataDecline.declined_order_details?.count ?? 0 > 0 {
                    for  n in self.finalDataDecline.declined_order_details! {
                        var model = ApprovedData()
                        model = n
                        self.finalTableList.append(model)
//                        if n.PRICE != "0.00" {
//                            self.finalTableList.append(model)
//                        }else {
//                            i = 0
//                            for n1 in self.finalTableList {
//                                if n1.SKU_ID == n.SKU_ID {
//                                    self.finalTableList[i].FREE_SKU_QUANTITY = "Free" + n.ORDER_QUANTITY!
//                                    break
//                                }
//                                i = i + 1
//                            }
//                        }
                        
                    }
                }
                DispatchQueue.main.async {
                  
                    self.mAsDelivered.isHidden = true
                    self.stockist_nm.text = self.finalDataDecline.declined_order_details?[0].SHOP_NAME
                    self.invoice_id.text = self.finalDataDecline.declined_order_details?[0].SALES_INVOICE_NO
                    self.date.text = self.finalDataDecline.declined_order_details?[0].LAST_MODIFIED
                    self.discount.text = self.finalDataDecline.declined_order_details?[0].DISCOUNT
                    self.gstIn.text = self.finalDataDecline.declined_order_details?[0].GST_NUMBER
                    self.netTotal.text = self.finalDataDecline.declined_order_details?[0].TOTAL_PRICE
                    self.address.text = self.finalDataDecline.declined_order_details?[0].ADDRESS
                    self.status.text = self.status_name
                    self.tableView.reloadData()
                    UIViewController.removeSpinner(spinner: self.sv)
                }
            
        } else if self.status_name == "postpone" {
            self.finalDataPending = value as? PendingDetailModel
            if finalDataPending.pending_order_details?.count ?? 0 > 0 {
                for  n in self.finalDataPending.pending_order_details! {
                    var model = ApprovedData()
                    model = n
                    var trackModel = CheckTrack()
                    trackModel.check = false
                    checkTrack.append(trackModel)
                    self.finalTableList.append(model)
//                    if n.PRICE != "0.00" {
//                        self.finalTableList.append(model)
//                    }else {
//                        i = 0
//                        for n1 in self.finalTableList {
//                            if n1.SKU_ID == n.SKU_ID {
//                                self.finalTableList[i].FREE_SKU_QUANTITY = "Free" + n.ORDER_QUANTITY!
//                                break
//                            }
//                            i = i + 1
//                        }
//                    }
                    
                }
            }
            DispatchQueue.main.async {
                
                self.mAsDelivered.isHidden = true
                self.stockist_nm.text = self.finalDataPending.pending_order_details?[0].SHOP_NAME
                self.invoice_id.text = self.finalDataPending.pending_order_details?[0].SALES_INVOICE_NO
                self.date.text = self.finalDataPending.pending_order_details?[0].LAST_MODIFIED
                self.discount.text = self.finalDataPending.pending_order_details?[0].DISCOUNT
                self.gstIn.text = self.finalDataPending.pending_order_details?[0].GST_NUMBER
                self.netTotal.text = self.finalDataPending.pending_order_details?[0].TOTAL_PRICE
                self.address.text = self.finalDataPending.pending_order_details?[0].ADDRESS
                self.status.text = self.status_name
                self.tableView.reloadData()
                UIViewController.removeSpinner(spinner: self.sv)
            }
        }
        

    }
    

    
    func loadData( url : String, complition: @escaping (Any?) -> Void ) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
        do {
            // data we are getting from network request
            let decoder = JSONDecoder()
            if self.status_name == "approved" {
            let response = try decoder.decode(ApprovedDetailModel.self, from: data!)
            self.responseData = response
            }else if self.status_name == "pending" {
                let response = try decoder.decode(PendingDetailModel.self, from: data!)
                self.responseData = response
            }else if self.status_name == "decline" {
                let response = try decoder.decode(DeclineDetailModel.self, from: data!)
                self.responseData = response
            }else if self.status_name == "postpone" {
                let response = try decoder.decode(PendingDetailModel.self, from: data!)
                self.responseData = response
            }
            complition(self.responseData)
        }
        catch _ {

            print("Error at getting pending data!")

            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert", message: "Error at getting pending data! ", preferredStyle: UIAlertControllerStyle.alert)
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
    
    @IBAction func markAsDeliveredAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
        if mAsDelivered.titleLabel?.text == "MARK AS DELIVERED" {
        
        self.sv = UIViewController.displaySpinner(onView: self.view)
        guard let url = URL(string:"\(Constants.stockisturl)index.php?end_point=getDeliveredOrderByChemist&order_id=\(String(chemist_id))&order_id=\(String(ord_id))&flag=4")
            else {
                print("URL Error!")
                return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                
                // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(setOrderModel.self, from: data!)
                if response.status == "200" {
                    UIViewController.removeSpinner(spinner: self.sv)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "Order Approved Successfully!!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
        
                            self.performSegue(withIdentifier: "detail_to_ord", sender: nil)
                            
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
                }else{
                    DispatchQueue.main.async {
                        UIViewController.removeSpinner(spinner: self.sv)
                        let alert = UIAlertController(title: "Alert", message: "Order Not Approved!", preferredStyle: UIAlertControllerStyle.alert)
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
                
            catch _ {
                
                print("Error at getting wallet data!")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "Error at getting wallet data! ", preferredStyle: UIAlertControllerStyle.alert)
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
                }
                
            }
        }
        task.resume()
        
        }else { // Cancel Order Button
       
            var truncaterd = ""
            if checkBoxAll.on == true {
            let endIndex = cancelOrderDetailValues.index(cancelOrderDetailValues.endIndex, offsetBy: -1)
                truncaterd = cancelOrderDetailValues.substring(to: endIndex)
            }else{
                var myStr = ""
                for i in cancelOrderIndexes {
                    myStr = myStr + i
                }
                let endIndex = myStr.index(myStr.endIndex, offsetBy: -1)
                truncaterd = myStr.substring(to: endIndex)
            }
            
            let strurl = "\(Constants.stockisturl)index.php?end_point=markAsCancelOrder&order_id=\(String(finalTableList[0].ORDER_ID!))&prod_details=&prod_removed=\(String(truncaterd))&os=ios"
            
            guard let url = URL(string:strurl)

                else {
                    print("URL Error!")
                    return}

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {

                    // data we are getting from network request
                    let decoder = JSONDecoder()
                    let response : setOrderModel = try decoder.decode(setOrderModel.self, from: data!)
                    print(response)
//
//                        self.view.makeToast(response.MESSAGE)
                    if response.error == "true"{
                         DispatchQueue.main.async {
                        let odvc = OrdersViewController()
                        odvc.c_status = "pending"
                        odvc.flagForCancelOder = true
                        self.performSegue(withIdentifier: "detail_to_ord", sender: nil)
//                        odvc.pendingAction(self)
                        //at ordersviewcontroler flag not setting to true
                        //                    }
                        }
                    }
                }

                catch _ {

               self.view.makeToast("Error in Cancel order!")

                }
            }
            task.resume()
            
            
        }
        } else {
            self.view.makeToast("Please Connect to Internet!!!")
        }
    }
}

extension OrdersDetailViewController : SingleCheckProtocol {
    func isChecked(cell: OrderDetailTableViewCell) {
        
        let index = cancelOrderTrack.index(of: cell.cellData.SKU_ID!)
        if cell.checkBoxOne.on == true{
            print("Checked!")
            self.mAsDelivered.isHidden = false
            self.checkBoxCount = checkBoxCount + 1
           
            self.checkTrack[index!].check = true
            
            let str = cell.cellData.ORDL! + "~" + cell.cellData.SKU_ID! + "~" + cell.cellData.ORDER_QUANTITY! + "~" + cell.cellData.PRICE! + "*"
            cancelOrderIndexes[index!] = str
            
        }else{
            print("Unchecked!")
            self.checkTrack[index!].check = false
            cancelOrderIndexes[index!] = ""
            self.checkBoxCount = checkBoxCount - 1
        }
        if checkBoxCount <= 0 {
            self.mAsDelivered.isHidden = true
        }
        if checkBoxCount != finalDataPending.pending_order_details?.count {
            checkBoxAll.setOn(false, animated: false)
        }
    }
  
}
