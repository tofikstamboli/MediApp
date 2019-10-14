//
//  RedeemVoucherTableViewCell.swift
//  MediAppIOS
//
//  Created by Globalspace Mac Mini on 29/12/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
//import DropDown
protocol redeemCellProtocol : class {
    func tapOfSwitch(cell : RedeemVoucherTableViewCell)
    func tapOfDropDown(cell : RedeemVoucherTableViewCell)
}

class RedeemVoucherTableViewCell: UITableViewCell,BEMCheckBoxDelegate {


    @IBOutlet weak var discLab: UILabel!
    @IBOutlet weak var endDate: UILabel!
    var cellRid : String!
    var cellPoints : String!
    var deligare : redeemCellProtocol!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var dropDown: UIButton!
    @IBOutlet weak var imageVIEW: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        dropDown.isHidden = true
        dropDown.titleLabel?.numberOfLines = 1
        dropDown.titleLabel?.adjustsFontSizeToFitWidth = true
        dropDown.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func checkAction(_ sender: Any) {
         deligare.tapOfSwitch(cell: self)
    }
    
    @IBAction func dropDownAction(_ sender: Any) {
        deligare.tapOfDropDown(cell: self)
    }
    

}
