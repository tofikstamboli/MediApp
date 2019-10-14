//
//  stockiastNameTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 30/03/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class stockiastNameTableViewCell: UITableViewCell {

    @IBOutlet weak var ord_id: UILabel!
    @IBOutlet weak var ord_date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
