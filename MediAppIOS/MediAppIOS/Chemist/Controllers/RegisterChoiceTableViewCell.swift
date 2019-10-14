//
//  RegisterChoiceTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 24/10/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class RegisterChoiceTableViewCell: UITableViewCell {

 
    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbl.layer.cornerRadius = 10
        lbl.layer.borderWidth = 2
        lbl.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
