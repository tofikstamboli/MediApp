//
//  itemDetailsUITableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 31/03/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class itemDetailsUITableViewCell: UITableViewCell {

    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
