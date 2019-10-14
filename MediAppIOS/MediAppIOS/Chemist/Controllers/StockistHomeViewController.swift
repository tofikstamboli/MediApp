//
//  StockistHomeViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 29/10/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class StockistHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    var data = [String]()
    var tem = StockistConnData()
    var sv = UIView()
    let prefrences = UserDefaults.standard
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.setTitle("Connections", forSegmentAt: 0)
        segment.setTitle("Orderes", forSegmentAt: 1)
        self.sv = UIViewController.displaySpinner(onView: self.view)
            loadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
     
    }

 
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tem.chemistinfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StockistConnectionsTableViewCell
        cell.title.text = tem.chemistinfo?[indexPath.row].FST_NAME
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.index = indexPath.row
       performSegue(withIdentifier: "popup", sender: nil)

    }
   
    
    func loadData(){
        let emp_id = prefrences.string(forKey: "EMP_ID")!
        let url = Constants.stockisturl + "?end_point=stockiestLogin&emp_id=\(String(emp_id))"
        FetchHttpData.updateDataModels(url: url, type: StockistConnData.self){
            response in
            self.tem = response as! StockistConnData
            DispatchQueue.main.async {
                self.tableView.reloadData()
                 UIViewController.removeSpinner(spinner: self.sv)
            }
        }
        
    }
    
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1 {
        performSegue(withIdentifier: "toStockOrders", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStockOrders" {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.buildNavigationDrawer(drawer: "stockiest2")
    }
        if segue.identifier == "popup" {
            let send = segue.destination as! PopUpViewController
            let str = tem.chemistinfo![index].FST_NAME
            send.mytitle = str

        }
    }
}

