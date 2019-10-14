//
//  TransactionViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 02/01/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var transData = [RedeemList]()
    var deferredData = [RedeemList]()
    var redeemedData = [RedeemList]()
    var creditedData = [RedeemList]()
    var closedData = [RedeemList]()
    var searchList = [RedeemList]()
    var currentProductList = [RedeemList]()
    var defc,redc,credc,closec : Int!
    var creditBalance : String!
    @IBOutlet var miljon_wallet_credit: UILabel!
    var current_tab : String = "1"
    @IBOutlet var tableView: UITableView!
    @IBOutlet var deferred_tab: UIButton!
    @IBOutlet var redeemed_tab: UIButton!
    @IBOutlet var credited_tab: UIButton!
    @IBOutlet var closed_tab: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    var searching : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        deferred_tab.titleLabel?.textColor = UIColor.gray
        
        defc = 0 ; redc = 0 ; credc = 0 ; closec = 0
        deferredData = transData ; redeemedData = transData ; creditedData = transData
        closedData = transData
        currentProductList = transData
        searchList = transData
       currentProductList.removeAll()
        searchList.removeAll()
        miljon_wallet_credit.text = creditBalance
        for (_, element) in transData.enumerated() {
            if element.STATUS == "1" {
                currentProductList.append(element) //search
                searchList.append(element) //search
                defc = defc + 1
                
            }
        }
        
        tabBarLook.normalTabBarCorner(view: self.credited_tab)
        tabBarLook.normalTabBarCorner(view: self.redeemed_tab)
        tabBarLook.normalTabBarCorner(view: self.closed_tab)
        tabBarLook.normalTabBarCorner(view: self.deferred_tab)
        tabBarLook.highlitedTabBarCorner(view: self.deferred_tab)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
       
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchList.count
 
        }else {
         return currentProductList.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TansactionTableViewCell
        if searching {
            cells.id.text = String(indexPath.row+1)
            cells.date.text = searchList[indexPath.row].DATE
            cells.status.text = searchList[indexPath.row].POINT_STATUS
            cells.points.text = searchList[indexPath.row].PTS_ID
        }else {
        
            cells.id.text = String(indexPath.row+1)
            cells.date.text = currentProductList[indexPath.row].DATE
            cells.status.text = currentProductList[indexPath.row].POINT_STATUS
            cells.points.text = currentProductList[indexPath.row].PTS_ID
        }
        return cells
    }
    
    @IBAction func Deferred_tap(_ sender: Any) {
        tabBarLook.normalTabBarCorner(view: self.credited_tab)
        tabBarLook.normalTabBarCorner(view: self.redeemed_tab)
        tabBarLook.normalTabBarCorner(view: self.closed_tab)
        tabBarLook.highlitedTabBarCorner(view: self.deferred_tab)
        current_tab = "1"
        var i = 0
        currentProductList.removeAll()
        searchList.removeAll()
        for (_,e) in transData.enumerated(){
            if e.STATUS == "1" {
                currentProductList.append(e)
                searchList.append(e)
                i = i + 1
            }
        }
        searching = false
        tableView.reloadData()
    }
    
    @IBAction func Credited_tap(_ sender: Any) {
        tabBarLook.normalTabBarCorner(view: self.deferred_tab)
        tabBarLook.normalTabBarCorner(view: self.redeemed_tab)
        tabBarLook.normalTabBarCorner(view: self.closed_tab)
        tabBarLook.highlitedTabBarCorner(view: self.credited_tab)
        current_tab = "2"
        var i = 0
       
        currentProductList.removeAll()
        for (_,e) in transData.enumerated(){
            if e.STATUS == "2" {
                currentProductList.append(e)
                i = i + 1
            }
        }
        searching = false
        tableView.reloadData()
    }
    
    @IBAction func Redeemed_Action(_ sender: Any) {
        tabBarLook.normalTabBarCorner(view: self.deferred_tab)
        tabBarLook.normalTabBarCorner(view: self.credited_tab)
        tabBarLook.normalTabBarCorner(view: self.closed_tab)
        tabBarLook.highlitedTabBarCorner(view: self.redeemed_tab)
        
        var i = 0
        current_tab = "3"
        currentProductList.removeAll()
        for (_,e) in transData.enumerated(){
            if e.STATUS == "3" {
                currentProductList.append(e)
                i = i + 1
            }
        }
        searching = false
        tableView.reloadData()
    }
    
    
    
    @IBAction func Closed_tap(_ sender: Any) {
        tabBarLook.normalTabBarCorner(view: self.deferred_tab)
        tabBarLook.normalTabBarCorner(view: self.credited_tab)
        tabBarLook.normalTabBarCorner(view: self.redeemed_tab)
        tabBarLook.highlitedTabBarCorner(view: self.closed_tab)
        
        var i = 0
        current_tab = "4"
        currentProductList.removeAll()
        for (_,e) in transData.enumerated(){
            if e.STATUS == "4" {
                currentProductList.append(e)
                i = i + 1
            }
        }
        searching = false
        tableView.reloadData()
    }
    
}



extension TransactionViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchList.removeAll()
        if searchText.count == 0 {
            searchList.removeAll()
            searching = false
            tableView.reloadData()
        }else{
            searchList.removeAll()
            searchList = currentProductList.filter({ $0.DATE!.lowercased().contains(searchText.lowercased()) || $0.POINT_STATUS!.lowercased().contains(searchText.lowercased()) || $0.PTS_ID!.lowercased().contains(searchText.lowercased()) || $0.STATUS!.lowercased().contains(searchText.lowercased())})
            
            //  searchProduct = Array(Set(searchProduct))
            searching = true
            tableView.reloadData()
            //  viewDidLoad()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchList.removeAll()
        searching = false
        tableView.reloadData()
    }

}
