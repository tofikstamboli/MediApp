//
//  OrdersTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 08/01/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet var order_lbl: UILabel!
    @IBOutlet var date_lbl: UILabel!
    @IBOutlet var name_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
