//
//  redeemOfferTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 12/12/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class redeemOfferTableViewCell: UITableViewCell {

    @IBOutlet weak var discription: UILabel!
    @IBOutlet weak var start_date: UILabel!
    @IBOutlet weak var end_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
