//
//  StockistListViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 10/10/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class StockistListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
     var mystockistlist : avilableStockistModel!
    @IBOutlet weak var tableView: UITableView!
    var emp_id : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
 

    func assignStockist(stk : avilableStockistModel){
        self.mystockistlist = stk
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mystockistlist.stockist?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockistListTableViewCell
        cell.stockistName.text = mystockistlist.stockist?[indexPath.row].FST_NAME
    
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emp_id = mystockistlist.stockist?[indexPath.row].EMPLOYEE_ID
        //prepration(emp: emp_id)
//        performSegue(withIdentifier: "availableMedicine", sender: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "availableMedicineViewController") as! availableMedicineViewController
//        newViewController.mystockistlist = stockistList
        
        
       if mystockistlist.stockist != nil {
        for i in 0...mystockistlist.stockist!.count {
            if mystockistlist.stockist![i].EMPLOYEE_ID == emp_id {
                newViewController.avlMedicine = mystockistlist.stockist![i].stockistlist!
                break
            }
        }
        self.present(newViewController, animated: true, completion: nil)
       }else{
        self.view.makeToast("Something Went Wrong")
        }
        
        
    }

    
    @IBAction func backToCart(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "availableMedicine" {
       let  sender = segue.destination as! availableMedicineViewController
            if mystockistlist.stockist != nil {
            for i in 0...mystockistlist.stockist!.count {
                if mystockistlist.stockist![i].EMPLOYEE_ID == emp_id {
                sender.avlMedicine = mystockistlist.stockist![i].stockistlist!
                    break
                }
              }
            }else{
              self.view.makeToast("Something Went Wrong")
            }
        }
    }
    

}
