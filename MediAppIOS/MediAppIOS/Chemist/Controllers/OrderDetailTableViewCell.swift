//
//  OrderDetailTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 15/01/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

protocol SingleCheckProtocol : class {
    func isChecked(cell: OrderDetailTableViewCell)
}

class OrderDetailTableViewCell: UITableViewCell,BEMCheckBoxDelegate {
    var thisIndex = 0
    @IBOutlet weak var pName: UILabel!    
    @IBOutlet weak var ptrQty: UILabel!
    @IBOutlet weak var netTotal: UILabel!
    @IBOutlet weak var redeem_points: UILabel!
    @IBOutlet weak var offer: UILabel!
    var cellData = ApprovedData()
    @IBOutlet weak var checkBoxOne: BEMCheckBox!
    var del : SingleCheckProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       checkBoxOne.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    
    @IBAction func sigleCheckAction(_ sender: Any) {
        del.isChecked(cell: self)
    }
}
