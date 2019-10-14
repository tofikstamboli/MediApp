//
//  OrdersViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 15/11/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var approvedBtn: UIButton!
    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var postponeBtn: UIButton!
    var flagFistTime = false
    var flagForCancelOder = false
    var emp_id : String!
    var sv = UIView()
    let preferences = UserDefaults.standard
    var c_status : String!
    var searching : Bool = false
    var stockistAppreovedData : StockistApprovedModel?
    var searchList : [StockistApprovedOrders]?
    var stockistPendingData : StokistPendingModel?
    var pendingSearchList : [StockistPendingOrder]?
    var stockistDeclineData : StockistDeclinedModel?
    var declineSearchList : [StockistDeclineOrder]?
    var chemistPostponeData : PostponeDetailModel?
    var postponeSearchList : [StockistDeclineOrder]?
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if c_status == "approved" {
            if searching {
                return searchList?.count ?? 0
            }else{
                return stockistAppreovedData?.stockistApprovedOrders.count ?? 0
            }
        } else if c_status == "pending" {
            if searching {
                return pendingSearchList?.count ?? 0
            }else{
                return stockistPendingData?.stockistPendingOrdersFromChm.count ?? 0
            }
        }else if c_status == "decline" {
            if searching {
                return declineSearchList?.count ?? 0
            }else{
                return stockistDeclineData?.stockistDeclinedOrdersFromChm.count ?? 0
            }
        }else if c_status == "postpone" {
            if searching {
                return postponeSearchList?.count ?? 0
            }else{
                return chemistPostponeData?.postpone_order_details?.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrdersTableViewCell
        
        if c_status == "approved" {
            if searching {
                cell.date_lbl.text = searchList?[indexPath.row].ORDER_DATE
                cell.name_lbl.text = searchList?[indexPath.row].ADDRESS
                cell.order_lbl.text = searchList?[indexPath.row].ORDER_ID
            } else {
                cell.date_lbl.text = stockistAppreovedData?.stockistApprovedOrders[indexPath.row].ORDER_DATE
                cell.name_lbl.text = stockistAppreovedData?.stockistApprovedOrders[indexPath.row].ADDRESS
                cell.order_lbl.text = stockistAppreovedData?.stockistApprovedOrders[indexPath.row].ORDER_ID
            }
        } else if c_status == "pending" {
            if searching {
                cell.date_lbl.text = pendingSearchList?[indexPath.row].ORDER_DATE
                cell.name_lbl.text = pendingSearchList?[indexPath.row].SHOP_NAME
                cell.order_lbl.text = pendingSearchList?[indexPath.row].ORDER_ID
            } else {
                cell.date_lbl.text = stockistPendingData?.stockistPendingOrdersFromChm[indexPath.row].ORDER_DATE
                cell.name_lbl.text = stockistPendingData?.stockistPendingOrdersFromChm[indexPath.row].SHOP_NAME
                cell.order_lbl.text = stockistPendingData?.stockistPendingOrdersFromChm[indexPath.row].ORDER_ID
            }
        } else if c_status == "decline" {
            if searching {
                cell.date_lbl.text = declineSearchList?[indexPath.row].ORDER_DATE
                cell.name_lbl.text = declineSearchList?[indexPath.row].SHOP_NAME
                cell.order_lbl.text = declineSearchList?[indexPath.row].ORDER_ID
            } else {
                cell.date_lbl.text = stockistDeclineData?.stockistDeclinedOrdersFromChm[indexPath.row].ORDER_DATE
                cell.name_lbl.text = stockistDeclineData?.stockistDeclinedOrdersFromChm[indexPath.row].SHOP_NAME
                cell.order_lbl.text = stockistDeclineData?.stockistDeclinedOrdersFromChm[indexPath.row].ORDER_ID
            }
        } else if c_status == "postpone" {
            if searching {
                cell.date_lbl.text = postponeSearchList?[indexPath.row].ORDER_DATE
                cell.name_lbl.text = postponeSearchList?[indexPath.row].SHOP_NAME
                cell.order_lbl.text = postponeSearchList?[indexPath.row].ORDER_ID
            }else {
                cell.date_lbl.text = chemistPostponeData?.postpone_order_details? [indexPath.row].ORDER_DATE
                cell.name_lbl.text = chemistPostponeData?.postpone_order_details?[indexPath.row].SHOP_NAME
                cell.order_lbl.text = chemistPostponeData?.postpone_order_details?[indexPath.row].ORDER_ID
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrdersDetailViewController") as! OrdersDetailViewController
        vc.chemist_id = emp_id
        if c_status == "approved" {
            
            if searching {
                vc.status_name = c_status
                vc.ord_id = searchList?[indexPath.row].ORDER_ID
                vc.org_id = searchList?[indexPath.row].ORG_ID
//                vc.stockist_nm.text = searchList[indexPath.row]
            }else {
                vc.status_name = c_status
                vc.ord_id = stockistAppreovedData?.stockistApprovedOrders[indexPath.row].ORDER_ID
                vc.org_id = stockistAppreovedData?.stockistApprovedOrders[indexPath.row].ORG_ID
            }
        }else if c_status == "pending" {
            if searching {
                vc.status_name = c_status
                vc.ord_id = pendingSearchList?[indexPath.row].ORDER_ID
                vc.org_id = pendingSearchList?[indexPath.row].ORG_ID
            }else {
                vc.status_name = c_status
                vc.ord_id = stockistPendingData?.stockistPendingOrdersFromChm[indexPath.row].ORDER_ID
                vc.org_id = stockistPendingData?.stockistPendingOrdersFromChm[indexPath.row].ORG_ID
            }
            
        }else if c_status == "decline" {
            if searching {
                vc.status_name = c_status
                vc.ord_id = declineSearchList?[indexPath.row].ORDER_ID
                vc.org_id = declineSearchList?[indexPath.row].ORG_ID
            }else {
                vc.status_name = c_status
                vc.ord_id = stockistDeclineData?.stockistDeclinedOrdersFromChm[indexPath.row].ORDER_ID
                vc.org_id = stockistDeclineData?.stockistDeclinedOrdersFromChm[indexPath.row].ORG_ID
            }
        } else if c_status == "postpone" {
            if searching {
                vc.status_name = c_status
                vc.ord_id = postponeSearchList?[indexPath.row].ORDER_ID
                vc.org_id = postponeSearchList?[indexPath.row].ORG_ID
            }else {
                vc.status_name = c_status
                vc.ord_id = chemistPostponeData?.postpone_order_details?[indexPath.row].ORDER_ID
                vc.org_id = chemistPostponeData?.postpone_order_details?[indexPath.row].ORG_ID
            }
        }
  
        navigationController?.pushViewController(vc,animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        approvedBtn.layer.cornerRadius = 10
        approvedBtn.layer.cornerRadius = 10
        approvedBtn.layer.borderWidth = 2
        approvedBtn.layer.borderColor = UIColor.white.cgColor
        flagFistTime = true
        tabBarLook.normalTabBarCorner(view: self.pendingBtn)
        tabBarLook.normalTabBarCorner(view: self.declineBtn)
        tabBarLook.normalTabBarCorner(view: self.postponeBtn)
        tabBarLook.highlitedTabBarCorner(view: self.approvedBtn)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton

        self.approvedAction(self)
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.cornerRaduiusSet(view: self.pendingBtn)
//        self.cornerRaduiusSet(view: self.declineBtn)
//        self.cornerRaduiusSet(view: self.postponeBtn)
//        self.feelAndColor(view: self.approvedBtn)
    
      
        
//        if flagFistTime != true {
//        self.approvedAction(self)
//        }
        }
    

    
    func loadTable() {
        DispatchQueue.main.async {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 150
            self.tableView.reloadData()
            UIViewController.removeSpinner(spinner: self.sv)
            
        }
        
    }
    @IBAction func approvedAction(_ sender: Any) {
        c_status = "approved"
        tabBarLook.normalTabBarCorner(view: self.pendingBtn)
        tabBarLook.normalTabBarCorner(view: self.declineBtn)
        tabBarLook.normalTabBarCorner(view: self.postponeBtn)
        tabBarLook.highlitedTabBarCorner(view: self.approvedBtn)
        loadData()
    }
    
  
    func loadData(){
        self.sv = UIViewController.displaySpinner(onView: self.view)
        emp_id = preferences.string(forKey: "EMP_ID")!
        self.stockistAppreovedData?.stockistApprovedOrders.removeAll()
        
        ///////////////////////////////////////Appreoved //////////////////////////////////////
        guard let url = URL(string:"\(Constants.stockisturl)index.php?end_point=getApprovedOrders&emp_id=\(String(self.emp_id))&flag=4")
            
            else {
                print("URL Error!")
                return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                
                // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(StockistApprovedModel.self, from: data!)
                
                self.stockistAppreovedData = response
                self.searchList  = response.stockistApprovedOrders
                self.loadTable()
                
            }
                
            catch _ {
                
                print("Data Not Found!")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "Data Not Found! ", preferredStyle: UIAlertControllerStyle.alert)
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
        }
        task.resume()
        
        ////////////////////////////////////////////////////////////////////////////
        
    }
    @IBAction func pendingAction(_ sender: Any) {
        self.sv = UIViewController.displaySpinner(onView: self.view)
        self.c_status = "pending"
        
        tabBarLook.normalTabBarCorner(view: self.approvedBtn)
        tabBarLook.normalTabBarCorner(view: self.declineBtn)
        tabBarLook.normalTabBarCorner(view: self.postponeBtn)
        tabBarLook.highlitedTabBarCorner(view: self.pendingBtn)
        self.stockistPendingData?.stockistPendingOrdersFromChm.removeAll()
        self.pendingSearchList?.removeAll()
        guard let url = URL(string:"\(Constants.stockisturl)index.php?end_point=getPendingOrders&emp_id=\(String(emp_id))")
            
            else {
                print("URL Error!")
                return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                
                // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(StokistPendingModel.self, from: data!)
                self.stockistPendingData = response
                self.pendingSearchList  = response.stockistPendingOrdersFromChm
                self.loadTable()
                
            }
                
            catch _ {
                
                print("Data Not Found!!")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "Data Not Found! ", preferredStyle: UIAlertControllerStyle.alert)
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
        }
        task.resume()
    }
    @IBAction func declineAction(_ sender: Any) {
        self.sv = UIViewController.displaySpinner(onView: self.view)
        self.c_status = "decline"
        searching = false
        tabBarLook.normalTabBarCorner(view: self.approvedBtn)
        tabBarLook.normalTabBarCorner(view: self.pendingBtn)
        tabBarLook.normalTabBarCorner(view: self.postponeBtn)
        tabBarLook.highlitedTabBarCorner(view: self.declineBtn)
        guard let url = URL(string:"\(Constants.stockisturl)index.php?end_point=getDeclinedOrders&emp_id=\(String(emp_id))")
            
            else {
                print("URL Error!")
                return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                
                // data we are getting from network request
                if data != nil {
                let decoder = JSONDecoder()
                let response = try decoder.decode(StockistDeclinedModel.self, from: data!)
                self.stockistDeclineData = response
                self.declineSearchList  = response.stockistDeclinedOrdersFromChm
                self.loadTable()
                }
            }
                
            catch _ {
                
                print("Data Not Found!")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "Data Not Found! ", preferredStyle: UIAlertControllerStyle.alert)
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
        }
        task.resume()
    }
    
    
    @IBAction func postponeAction(_ sender: Any) {
        
        self.sv = UIViewController.displaySpinner(onView: self.view)
        self.c_status = "postpone"
        searching = false
        tabBarLook.normalTabBarCorner(view: self.approvedBtn)
        tabBarLook.normalTabBarCorner(view: self.pendingBtn)
        tabBarLook.normalTabBarCorner(view: self.declineBtn)
        tabBarLook.highlitedTabBarCorner(view: self.postponeBtn)
        
        let url = "\(Constants.stockisturl)index.php?end_point=getPostponeOrdersDetails&emp_id=\(String(emp_id))&flag=4"
        FetchHttpData.updateDataModels(url: url, type: PostponeDetailModel.self) {
            response in

            self.chemistPostponeData = response as? PostponeDetailModel
            self.postponeSearchList = self.chemistPostponeData?.postpone_order_details
            self.loadTable()
        }

        
    }
    
}

extension OrdersViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if c_status == "approved" {
            
            if searchText.count == 0 {
                searchList?.removeAll()
                searching = false
                loadData()
            }else{
                
                searchList = stockistAppreovedData?.stockistApprovedOrders.filter({ $0.ADDRESS.lowercased().contains(searchText.lowercased()) || $0.ORDER_ID.lowercased().contains(searchText.lowercased()) || $0.ORDER_DATE.lowercased().contains(searchText.lowercased())})
            }
        }else if c_status == "pending" {
            
            if searchText.count == 0 {
                
                self.pendingSearchList?.removeAll()
                searching = false
                pendingAction(self)
                tableView.reloadData()
            }else{
                
                pendingSearchList = stockistPendingData?.stockistPendingOrdersFromChm.filter({ $0.SHOP_NAME.lowercased().contains(searchText.lowercased()) || $0.ORDER_ID.lowercased().contains(searchText.lowercased()) || $0.ORDER_DATE.lowercased().contains(searchText.lowercased())})
                
            }
        }else if c_status == "decline" {
            
            if searchText.count == 0 {
                self.declineSearchList?.removeAll()
                searching = false
                declineAction(self)
                tableView.reloadData()
            }else{
                declineSearchList = stockistDeclineData?.stockistDeclinedOrdersFromChm.filter({ $0.SHOP_NAME!.lowercased().contains(searchText.lowercased()) || $0.ORDER_ID!.lowercased().contains(searchText.lowercased()) || $0.ORDER_DATE!.lowercased().contains(searchText.lowercased())})
            }
        }else if c_status == "postpone" {
            if searchText.count == 0 {
                self.postponeSearchList?.removeAll()
                searching = false
                postponeAction(self)
                tableView.reloadData()
            }else{
                postponeSearchList = chemistPostponeData?.postpone_order_details?.filter({ $0.SHOP_NAME!.lowercased().contains(searchText.lowercased()) || $0.ORDER_ID!.lowercased().contains(searchText.lowercased()) || $0.ORDER_DATE!.lowercased().contains(searchText.lowercased())})
            }
        }
        
        searching = true
        tableView.reloadData()
        
    }
}


