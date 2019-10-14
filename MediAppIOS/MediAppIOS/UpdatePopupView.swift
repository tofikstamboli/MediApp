//
//  UpdatePopupView.swift
//  MediAppIOS
//
//  Created by iMac on 10/09/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import Foundation

class UpdatePopUp : UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var UpateBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit(){
        Bundle.main.loadNibNamed("UpdatePopUp", owner: self, options: nil)
        addSubview(contentView)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.orange.cgColor
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
}
