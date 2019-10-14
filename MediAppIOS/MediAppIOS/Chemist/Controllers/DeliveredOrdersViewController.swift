//
//  DeliveredOrdersViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 30/03/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class DeliveredOrdersViewController: UIViewController {
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var filterBtn: UIButton!
    var filterValue = ""
    var prefrences = UserDefaults.standard
    var deliveredOrdData = [stockistDeliveredOrdersFromChm]()
    var searchData = [stockistDeliveredOrdersFromChm]()
    var sv = UIView()
    var searching = false
    var data = ["Hello","Worlds","MediApp"]
    var tblData = ["7-Days","15-Days","30-Days","3-Months","6-months","1-year","2-year"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterPicker.delegate = self
        self.filterPicker.dataSource = self
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        self.searchBar.delegate = self
        filterPicker.tintColor = .white
        filterPicker.dataSource = tblData as? UIPickerViewDataSource
        tabBarLook.cornerRaduiusSet(view: filterBtn)
        loadDeliveredOrders(filter: "7-Days")
    }
    
    @IBAction func filterAction(_ sender: Any) {
        loadDeliveredOrders(filter: filterValue)
    }
    
    
    @IBAction func backToHome(_ sender: Any) {
    navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func loadDeliveredOrders(filter:String) {
        self.sv = UIViewController.displaySpinner(onView: self.view)
        let emp_id = prefrences.string(forKey: "EMP_ID")!
        let urlstr = "\(Constants.stockisturl)index.php?end_point=getDeliveredOrders&emp_id=\(emp_id)&order_type=Unpaid&filter=\(filter)"

        FetchHttpData.updateDataModels(url: urlstr, type: DeleveredOrderData.self) {
            response in
            let resp = response as! DeleveredOrderData
            if resp.status == "200" {
                self.deliveredOrdData = resp.stockistDeliveredOrdersFromChm!
                self.searchData = resp.stockistDeliveredOrdersFromChm!
                DispatchQueue.main.async {
                    UIViewController.removeSpinner(spinner: self.sv)
                    self.myCollectionView.reloadData()
                }
            }else{
                DispatchQueue.main.async {
                    UIViewController.removeSpinner(spinner: self.sv)
                    self.view.makeToast("Data Not Found!")
                }
            }
        }
    }

    
}

extension DeliveredOrdersViewController : UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searching == false {
        return self.deliveredOrdData.count
        }else{
            return self.searchData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DeliveredOrderCollectionViewCell
        if self.searching == false{
        cell.ord_id.text = deliveredOrdData[indexPath.row].ORDER_ID
        cell.delivered_date.text = deliveredOrdData[indexPath.row].DELIVERED_DATE
        cell.shop_name.text = deliveredOrdData[indexPath.row].SHOP_NAME
        }else{
            cell.ord_id.text = searchData[indexPath.row].ORDER_ID
            cell.delivered_date.text = searchData[indexPath.row].DELIVERED_DATE
            cell.shop_name.text = searchData[indexPath.row].SHOP_NAME
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText.count != 0 {
            searchData = self.deliveredOrdData.filter({
                $0.ORDER_ID!.lowercased().contains(searchText.lowercased()) ||
                $0.DELIVERED_DATE!.lowercased().contains(searchText.lowercased()) ||
                $0.SHOP_NAME!.lowercased().contains(searchText.lowercased()) })
            searching = true
        }else{
            searching = false
        }
        self.myCollectionView.reloadData()
    }
    
}



extension DeliveredOrdersViewController : UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tblData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.filterValue = tblData[row]
        return tblData[row]
    }
}
