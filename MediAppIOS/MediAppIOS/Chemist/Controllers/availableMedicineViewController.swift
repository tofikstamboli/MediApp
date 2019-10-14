//
//  availableMedicineViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 12/10/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class availableMedicineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    var spinnerView = UIView()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prp: UILabel!
    @IBOutlet weak var total_mrp: UILabel!
    @IBOutlet weak var sub_total: UILabel!
    @IBOutlet weak var total_mrp_lbl: UILabel!
    @IBOutlet weak var net_total_lbl: UILabel!
    @IBOutlet weak var net_total: UILabel!
    @IBOutlet weak var orderbtn: UIButton!
    let prefrences = UserDefaults.standard
    var s_total : Float = 0
    var total_mrp_val : Float = 0
    var avlMedicine : [StockistList] = []
    let ctvc = CartTabViewController()
    var count = 0
    var products = ""
    var EMP_ID = ""
    var msg = ""
    var totalPotentialRP : Float = 0.0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return avlMedicine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! availableMedicineTableViewCell
        cell.prod_name.text = avlMedicine[indexPath.row].PROD_NAME
        cell.comp_name.text = avlMedicine[indexPath.row].COMPANY_NAME
        cell.qty.text = avlMedicine[indexPath.row].QUANTITY
        cell.qty.text?.append(" * ")
        cell.ptr.text = avlMedicine[indexPath.row].MSP_PER
        cell.mrp.text = "MRP: ₹"
        cell.mrp.text?.append(avlMedicine[indexPath.row].MRP)
        let val1 = avlMedicine[indexPath.row].QUANTITY
        let val2 = avlMedicine[indexPath.row].MSP_PER
        let total = Float(val1)! * Float(val2)!
        s_total += total
        self.totalPotentialRP += total * Float(avlMedicine[indexPath.row].REDEEM_VALUE)!
        total_mrp_val += Float(avlMedicine[indexPath.row].MRP)!
        cell.cell_total.text = "₹"
        cell.cell_total.text?.append(String(total))
        if avlMedicine[indexPath.row].PRODUCT_STATUS == "AVAILABLE" {
            cell.prod_status.text = "AVAILABLE"
        }else{
            cell.prod_status.text = "NOT AVAILABLE"
        }
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        calculations()
//        // check text and do something
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
    
        tabBarLook.cornerRaduiusSet(view: self.tableView)
        tabBarLook.cornerRaduiusSet(view: self.orderbtn)
        EMP_ID = avlMedicine[0].EMPLOYEE_ID
        for i in 0...(avlMedicine.count-1) {
            self.products.append("\(avlMedicine[i].SKU_ID)~\(avlMedicine[i].QUANTITY)~\(avlMedicine[i].SCHEME_ID),")
        }
        let endIndex = products.index(products.endIndex, offsetBy: -1)
		        products = products.substring(to: endIndex)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        calculations()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  calculations() {
        self.sub_total.text = "₹"
        self.sub_total.text?.append(String(s_total))
        self.prp.text = String((self.totalPotentialRP.rounded(.towardZero)))
        
        self.total_mrp.text = "₹"
        self.total_mrp.text?.append(String(self.total_mrp_val))
        self.net_total.text = "₹"
        self.net_total.text?.append(String(s_total))
    }


    
    @IBAction func func_orderNow(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
        Tab1ViewController.vdlcount = 0
            self.spinnerView = UIViewController.displaySpinner(onView: self.view)
            let empid = prefrences.string(forKey: "EMP_ID")!
        guard let url = URL(string:"\(Constants.stockisturl2)?end_point=setOrder&emp_id=\(String(empid))&product=\(products)&delivery_date=2015-12-15&order_priority=normal&offer_id=null&org_id=\(avlMedicine[0].ORG_ID)")
        
            else {
                return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                // data we are getting from network request
                let decoder = JSONDecoder()
                  print(url)
                let response = try decoder.decode(setOrderModel.self, from: data!)
                //self.stockistList = response
              //  self.performSegue(withIdentifier: "stockistlistsegue", sender: nil)
                self.msg = response.MESSAGE
                if response.status == "200" {
                    UIViewController.removeSpinner(spinner: self.spinnerView)
                let alert = UIAlertController(title: "Alert", message: self.msg , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        self.performSegue(withIdentifier: "ordernow_to_cart", sender: nil)
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("meeta")
                    }}))
                self.present(alert, animated: true, completion: nil)
                print(response)
                }else{
                    self.view.makeToast("Order Not Placed !!! Please try again")
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        }else {
            self.view.makeToast("Please Check Connection!")
        }

        
        
    }
    @IBAction func backAction(_ sender: Any) {
navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//        appDelegate?.buildNavigationDrawer()

        //ctvc.actionFromOrderNow(avsl: avlMedicine)
        if segue.identifier == "ordernow_to_cart" {
       let sender = CartTabViewController()
        sender.actionFromOrderNow(avsl: avlMedicine)
    }
    }
}
