//
//  MyDremDestinationVC.swift
//  MediAppIOS
//
//  Created by abhishek on 13/12/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import Kingfisher
import iOSDropDown
import Toast_Swift

class MyDremDestinationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let transition:CATransition = CATransition()
    var prefrences = UserDefaults.standard
    var empid : String!
    var walletImage : [WalletImge]?
    var optionData : [RedeemOption]?
    var redeemType : [Redeem_Type_Master]?
    var selected_rid : String!
    var selectedSceam : String!
    var currentOfferList : [WalletImge]?
    @IBOutlet weak var detailPopUp: PopuPView!
    @IBOutlet weak var tableView: UITableView!
 
    @IBOutlet weak var selectedDropDown: DropDown!
    //   let dropDown = DropDown()
    
    @IBOutlet weak var scrollDownLbl: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentOfferList != nil {
        return currentOfferList!.count
        }else{
        return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? myDremDestTableViewCell
        if currentOfferList != nil {
            let urlimg = self.currentOfferList![indexPath.row].URL!.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string:urlimg)
        cell!.offerImg.kf.setImage(with:url)
        }
        return cell!
    }

 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath) as! myDremDestTableViewCell

        detailPopUp.backBtn.tag = indexPath.row
        detailPopUp.backBtn.addTarget(self, action: #selector(self.backBtnAction(_:)), for: .touchUpInside);
        
        
        detailPopUp.submitBtn.addTarget(self, action: #selector(self.submitDataAction(_:)), for: .touchUpInside)
        
        self.selected_rid = currentOfferList![indexPath.row].RDM_ID
        self.selectedSceam = currentOfferList![indexPath.row].ALT_DESCRIPTION
        
        if currentOfferList != nil {
            let urlimg = self.currentOfferList![indexPath.row].URL!.replacingOccurrences(of: " ", with: "%20")
            let url = URL(string:urlimg)
            detailPopUp.imageView.kf.indicatorType = .activity
            detailPopUp.imageView.kf.setImage(with: url)
        }
        
        if redeemType != nil {
            
            
            for i in redeemType! {
                if i.GRTM_ID == "GRTM_1" {
                    detailPopUp.hItWorkDis.text = i.HOW_IT_WORK
                    detailPopUp.general_TC.text = i.GENERAL_TERMS_AND_CONDITION
                    detailPopUp.schemTC.text = i.SCHEME_TERMS_AND_CONDITION
                }else if i.GRTM_ID == "GRTM_2" {
                    detailPopUp.hItWorkDis.text = i.HOW_IT_WORK
                    detailPopUp.general_TC.text = i.GENERAL_TERMS_AND_CONDITION
                    detailPopUp.schemTC.text = i.SCHEME_TERMS_AND_CONDITION
                }
            }
        detailPopUp.isHidden = false
        scrollDownLbl.isHidden = true
        }
    }
    
    @objc func backBtnAction(_ sender : UIButton){
        // call your segue code here
        print("BackButtonPressed")
        detailPopUp.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = 353;
//        self.submitButton.isHidden = true
        detailPopUp.isHidden = true
        scrollDownLbl.isHidden = false
        
       
       
        loadOfferList()
        
//        dropDown.anchorView = selectDropDown
        
        if redeemType != nil { 
        for i in redeemType! {
           selectedDropDown.optionArray.append(i.REEDEM_TYPE!)
        }
        }
        
        
        
        selectedDropDown.didSelect { (item, index, id) in
            print("Selected item: \(item) at index: \(index)")
            //self.offer_list_lbl.text = item
       self.prefrences.set(self.redeemType![index].GRTM_ID, forKey: "SelectedOfferListId")
            self.selectedDropDown.selectedRowColor = .orange
        self.loadOfferList()
        }
        
//       dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
//           self.offer_list_lbl.text = item
//            self.prefrences.set(self.redeemType![index].GRTM_ID, forKey: "SelectedOfferListId")
//            self.loadOfferList()
//        }
        
        empid = self.prefrences.string(forKey: "EMP_ID")
       print(String(empid))
        
        if walletImage?.count == 0 {
            self.view.makeToast("Offeres Not Avilable Now !")
            let alert = UIAlertController(title: "Alert", message: "Offers Not Avilable Now !", preferredStyle: UIAlertControllerStyle.alert)
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
        
//// -----> Animation
//        transition.duration = 4
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromBottom
//        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
////<----- Animation
        
 
}
    
    func loadOfferList() {
        let curList = prefrences.string(forKey: "SelectedOfferListId")
        currentOfferList = walletImage
        currentOfferList!.removeAll()
        for (_,j) in walletImage!.enumerated() {
            if j.GRTM_ID == curList{
                currentOfferList!.append(j)
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func BackBtnAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func ShowOfferDropDown(_ sender: Any) {
//    //dropDown.show()
//    }

    
    @objc func submitDataAction(_ sender: Any) {

        //----Submit data--->
         print(String(self.selected_rid))
        let urlstr = "\(Constants.stockisturl2)?end_point=getRedeemOfferPopup&CHEMIST_ID=\(String(empid))&RDM_ID=\(String(self.selected_rid))"
        guard let url = URL(string:urlstr)

            else {
                print("URL Error!")
                return}

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(OfferSubmit.self, from: data!)
                if response.status == "200"{
                    DispatchQueue.main.async {
                       
                        self.view.makeToast("Schem Selected Successfully!")
                        let alert = UIAlertController(title: "Alert", message: "Data Submited Successfully..! ", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                let vc = self.storyboard!.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                                self.prefrences.set(self.selectedSceam, forKey: "MyDreamDestination")
                                self.navigationController?.pushViewController(vc,animated: true)
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
                    let alert = UIAlertController(title: "Alert", message: "Error at Offer sumbmit ... ! ", preferredStyle: UIAlertControllerStyle.alert)
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


                    //        vc.delegate = (self as! ChildViewControllerDelegate)



                }

            }
        }
        task.resume()

    }
    
}

