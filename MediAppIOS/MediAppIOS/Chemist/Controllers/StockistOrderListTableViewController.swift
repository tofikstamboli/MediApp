//
//  StockistOrderListTableViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 30/03/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class StockistOrderListTableViewController: UITableViewController {
    var prefrences = UserDefaults.standard
    var data = [org_delivered_order]()
    var itemData = DeliverdOrderDiscription()
        var sv = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        if data.count > 0 {
    self.navigationController?.navigationBar.topItem?.title = data[0].DELIVERY_PERSON_ID
        }
    }

  
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! stockiastNameTableViewCell
        cell.ord_date.text = data[indexPath.row].ORDER_DATE
        cell.ord_id.text = data[indexPath.row].ORDER_ID
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadData(index: indexPath.row ,ord_id: data[indexPath.row].ORDER_ID!, org_id: data[indexPath.row].S_ORG_ID!)
    }
    
    func loadData(index:Int , ord_id: String , org_id: String) {
        self.sv = UIViewController.displaySpinner(onView: self.view)
        let emp_id = prefrences.string(forKey: "EMP_ID")!
       
        let urlstr = "http://13.127.182.214/mediapp/miljon_advance/v1/index.php?end_point=getDeliveredOrderDetail&order_id=\(ord_id)&emp_id=\(emp_id)&org_id=\(org_id)"
        guard let url = URL(string:urlstr)
            
            else {
                print("URL Error!")
                return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                
                // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(DeliverdOrderDiscription.self, from: data!)
                self.itemData = response
                if self.itemData.stockistDeliveredOrderDetail != nil {
                DispatchQueue.main.async {
                    UIViewController.removeSpinner(spinner: self.sv)
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "OrderIdDiscriptionViewController") as! OrderIdDiscriptionViewController
                    vc.items = (self.itemData.stockistDeliveredOrderDetail?[0].ord_disc?.count)!
                
                    vc.data = (self.itemData.stockistDeliveredOrderDetail?[0].ord_disc)!
                    self.navigationController?.pushViewController(vc,animated: true)
                }
                }else{
                    DispatchQueue.main.async {
                    self.view.makeToast("Do Not Fetching Item Data!")
                        UIViewController.removeSpinner(spinner: self.sv)
                    }
                }
            }
                
            catch _ {
                
                print("Error at getting wallet data!")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "Error at getting data! ", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            UIViewController.removeSpinner(spinner: self.sv)
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

}
