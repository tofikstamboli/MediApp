//
//  OrderIdDiscriptionViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 31/03/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class OrderIdDiscriptionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var data = [Order_disciption]()
    var items = Int()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var item_s: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var invoiceid: UILabel!
    @IBOutlet weak var total: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if data.count == 0 {
            self.view.makeToast("data not fount !")
        }
        invoiceid.text = data[0].SALES_INVOICE_NO
        date.text = data[0].ORDER_DATE
        item_s.text = String(items)
        discount.text = data[0].DISCOUNT_AMOUNT
        total.text = data[0].GROSS_AMOUNT
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! itemDetailsUITableViewCell
        if data[indexPath.row].PRODUCT_NAME != nil {
        cell.product.text = data[indexPath.row].PRODUCT_NAME
        cell.qty.text = data[indexPath.row].ITEM_PRICE! + "×" + data[indexPath.row].APPROVED_QUANTITY!
        cell.total.text = data[indexPath.row].PRICE
        }
        return cell
        
    }

}
