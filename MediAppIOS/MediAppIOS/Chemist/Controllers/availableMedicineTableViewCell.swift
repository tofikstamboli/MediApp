//
//  availableMedicineTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 15/10/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class availableMedicineTableViewCell: UITableViewCell {

    @IBOutlet weak var prod_name: UILabel!
    @IBOutlet weak var comp_name: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var ptr: UILabel!
    @IBOutlet weak var cell_total: UILabel!
    @IBOutlet weak var mrp: UILabel!
    @IBOutlet weak var prod_status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
