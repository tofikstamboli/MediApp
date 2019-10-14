//
//  RedeemOfferViewController.swift
//  MediAppIOS
//
//  Created by Globalspace Mac Mini on 29/12/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit



class RedeemOfferViewController: UIViewController,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,redeemCellProtocol,BEMCheckBoxDelegate {
    

    @IBOutlet weak var tableVew: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var str = [RedeemOffer]()
    var redeemOption = [RedeemOption]()
    var statusOfSwitch = [Bool]()
    var statusOfDropDown = [Bool]()
    var ddStatus : Bool = false
    var isOptionValueNeeded : Bool = false
    var ddSelected : Bool = false
    var arrOfRids = [String]()
    var index : Int = 0
    var selected_RdmID : String!
    var selected_points : String!
    var selected_option_id : String!
    var selected_tbv_row : Int!
    var sv : UIView!
    var selectedOptionRow : Int!
    var dropDataList = [String]()
    var optionIds = [String]()
    var Current_Points : String!

    let prefrences = UserDefaults.standard
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return str.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RedeemVoucherTableViewCell
        cell.deligare = (self as redeemCellProtocol)
        cell.discLab.text = str[indexPath.row].DESCRIPTION
        cell.endDate.text = str[indexPath.row].END_DATE
        cell.checkBox.on = statusOfSwitch[indexPath.row]
        cell.dropDown.isHidden = statusOfDropDown[indexPath.row]
        cell.imageVIEW.isHidden = statusOfDropDown[indexPath.row]
        cell.cellPoints = str[indexPath.row].POINTS
        cell.cellRid = str[indexPath.row].RDM_ID
        if ddStatus == true {
        if indexPath.row == selected_tbv_row {
            cell.dropDown.titleLabel?.text = dropDataList[selectedOptionRow]
        }
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableVew.delegate = self
        tableVew.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        submitBtn.isHidden = true
        let fac = fillAndColorClass()
        fac.feelAndColor(view: self.collectionView)
        tableVew.estimatedRowHeight = tableVew.rowHeight
        tableVew.rowHeight = UITableViewAutomaticDimension
        for i in str {
            let tmp = ""
            arrOfRids.append(tmp)
            statusOfSwitch.append(false)
            statusOfDropDown.append(true)
            arrOfRids[index] = i.RDM_ID!
            index = index + 1
        }
    }

    func tapOfSwitch(cell: RedeemVoucherTableViewCell) {
        let indexPath = arrOfRids.index(of: cell.cellRid)
        self.selected_RdmID = ""
        ddStatus = false
        selected_tbv_row = tableVew.indexPath(for: cell)?.row
        cell.dropDown.titleLabel?.text = "OPTIONS                                                         "
        self.selected_points = ""
        ddSelected = false
        isOptionValueNeeded = false
        collectionView.isHidden = true
        var tmp = 0
        for _ in str{
            statusOfSwitch[tmp] = false
            statusOfDropDown[tmp] = true
            dropDataList.append("")
            optionIds.append("")
            tmp = tmp + 1
        }
        self.tableVew.reloadData()
        if cell.checkBox.on == true {
        dropDataList.removeAll()
        optionIds.removeAll()
        submitBtn.isHidden = false
        statusOfSwitch[indexPath!] = true
        self.selected_RdmID = cell.cellRid
        self.selected_points = cell.cellPoints
            
            for i in redeemOption {
                if cell.cellRid == i.RDM_ID {
                    isOptionValueNeeded = true
                    self.statusOfDropDown[indexPath!] = false
                    for j in i.REDEEM_DATA {
                        dropDataList.append(j.OPTION_NAME ?? "Data Not Found")
                        optionIds.append(j.REEDEMED_OPTION_MASTER_ID ?? "")
                    }
                }
            }
        }else{
            self.submitBtn.isHidden = true
            self.collectionView.isHidden = true
        }
        tableVew.reloadData()
    }
    
    func tapOfDropDown(cell: RedeemVoucherTableViewCell) {

     ddStatus = true
     selected_tbv_row = tableVew.indexPath(for: cell)?.row
        if dropDataList.count > 2 {
            collectionView.frame = CGRect(x: 30, y: 66, width: collectionView.frame.width, height: collectionView.frame.height + 60)
        }else{
            collectionView.frame = CGRect(x: 30 , y: 66, width: collectionView.frame.width, height: 120)
        }
        
    collectionView.isHidden = false
    collectionView.reloadData()
    }
    
    @IBAction func voucherSubmitAction(_ sender: Any) {
        
        self.sv = UIViewController.displaySpinner(onView: self.view)
        let a = Int(selected_points) ?? 0
        let b = Int(Current_Points) ?? 0
        if b >= a {
            if isOptionValueNeeded == true && ddSelected == false {
                self.view.makeToast("Please select option !")
                UIViewController.removeSpinner(spinner: self.sv)
            }else{
               getData()
            }
        }else{
            self.view.makeToast("Your Points is low !")
            UIViewController.removeSpinner(spinner: self.sv)
        }
    }
    
    func getData(){
        let emp_id = prefrences.string(forKey: "EMP_ID")!
        let URL = "\(Constants.stockisturl)wallet.php?function_name=sendWalletValue&username=\(emp_id)&redeem_value=\(String(self.selected_points))&rdm_id=\(String(self.selected_RdmID))&option_id=\(String(self.selected_option_id ?? ""))"

        FetchHttpData.updateDataModels(url: URL, type: voucherSubmit.self){
            response in
            let data = response as! voucherSubmit
            DispatchQueue.main.async {
                self.view.makeToast(data.msg)
                let alert = UIAlertController(title: "Alert", message: data.msg, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        UIViewController.removeSpinner(spinner: self.sv)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    }}))
                self.present(alert, animated: true, completion: nil)
               
            }
        }

    }
    
}


extension RedeemOfferViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return dropDataList.count
    }
    
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RedeemValueCollectionViewCell
        cell.stockistName.text = dropDataList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedOptionRow = indexPath.row
        selected_option_id = optionIds[selectedOptionRow]
        collectionView.isHidden = true
        ddSelected = true
        tableVew.reloadData()
    }
}
