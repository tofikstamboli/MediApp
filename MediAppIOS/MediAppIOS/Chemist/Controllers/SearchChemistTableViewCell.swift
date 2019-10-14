//
//  SearchChemistTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 02/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

class SearchChemistTableViewCell:  UITableViewCell,UIPickerViewDelegate{

    @IBOutlet weak var productName: UILabel!

    @IBOutlet weak var schems: UILabel!
    
    @IBOutlet weak var productComposition: UILabel!
    
    @IBOutlet weak var pack: UILabel!
    
    @IBOutlet weak var ptr: UILabel!
    
    @IBOutlet weak var mrp: UILabel!
    
    @IBOutlet weak var offer: UILabel!
    

    
    @IBOutlet weak var QtyButton: UIButton!
  
    @IBOutlet weak var QTYText: UITextField!

    
    override func layoutSubviews() {
        super.layoutSubviews()
//        QtyButton.isHidden = true
//        QTYText.isHidden = true
      
     
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//
//    @IBAction func SwitchAction(_ sender: Any) {
//
//        if switch_btn.tag == 1 {
//        switch_btn.setOn(true, animated: true)
//            switch_btn.tag = 2
//            QtyButton.isHidden = false
//            QTYText.isHidden = false
//
//        }
//        else {
//            switch_btn.setOn(false, animated: true)
//            switch_btn.tag = 1
//            QtyButton.isHidden = true
//            QTYText.isHidden = true
//        }
//    }
//
    

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
   
}
