//
//  RedeemOfferDetailVC.swift
//  MediAppIOS
//
//  Created by abhishek on 11/12/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class RedeemOfferDetailVC: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
     var walletData : WalletModel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if walletData != nil {
        return walletData.redeem_offer.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! redeemOfferTableViewCell
        if walletData != nil {
        cell.discription.text = walletData.redeem_offer[indexPath.row].DESCRIPTION
        cell.start_date.text = walletData.redeem_offer[indexPath.row].START_DATE
        cell.end_date.text = walletData.redeem_offer[indexPath.row].END_DATE
        }
        return cell
    }
    
    
   

    let transition:CATransition = CATransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        //Animation Part
//        transition.duration = 4
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromTop
//        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//        //
        tableView.dataSource = self
        tableView.delegate = self
    
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2.0

    }
}
