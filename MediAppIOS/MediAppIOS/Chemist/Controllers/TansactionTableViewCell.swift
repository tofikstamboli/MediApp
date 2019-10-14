//
//  TansactionTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 03/01/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class TansactionTableViewCell: UITableViewCell {

    
    @IBOutlet var id: UILabel!
    @IBOutlet var points: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tabBarLook.cornerRaduiusSet(view: view)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
