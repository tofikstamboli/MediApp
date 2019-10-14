//
//  PopuPView.swift
//  MediAppIOS
//
//  Created by iMac on 03/06/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class PopuPView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var howItWorkTitle: UILabel!
    @IBOutlet weak var hItWorkDis: UILabel!
    @IBOutlet weak var general_TC: UILabel!
    @IBOutlet weak var schemTC: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    

    func commonInit(){
        Bundle.main.loadNibNamed("PopUpView", owner: self, options: nil)
        makeToast("Wait ... Data is loading!!!")
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
}
