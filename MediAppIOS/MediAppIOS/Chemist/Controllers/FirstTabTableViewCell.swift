//
//  FirstTabTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 29/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

protocol MyCustomTabViewDeligate : class {
    func didTappedSwitch(cell: FirstTabTableViewCell)
    func didQTYEnter(cell: FirstTabTableViewCell)
    func didTvTap(cell: FirstTabTableViewCell)
    func didEndEditing(cell: FirstTabTableViewCell)
    func didAddQty(cell: FirstTabTableViewCell)
    func didSubQty(cell: FirstTabTableViewCell)
    func viewInfo(cell: FirstTabTableViewCell)
    func schemeTapped(cell: FirstTabTableViewCell)
}

class FirstTabTableViewCell: UITableViewCell,UITextFieldDelegate{

    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var tv: UITextField!
    @IBOutlet weak var BasicPrice: UILabel!
    @IBOutlet weak var discription: UILabel!
    @IBOutlet weak var offer: UILabel!
    @IBOutlet weak var actualPrice: UILabel!
    @IBOutlet weak var addQtyBtn: UIButton!
    @IBOutlet weak var subQtyBtn: UIButton!
    @IBOutlet weak var tbvcell: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var schems: UILabel!
    @IBOutlet weak var free: UILabel!
    
    var deligate: MyCustomTabViewDeligate!
    var ptr = "", mrp = ""
    var productDetail = Product(PRODUCT_ID: "", PRODUCT_NAME: "", PRODUCT_TYPE: "", PRODUCT_COMPOSITION: "", PRODUCT_DISCRIPTION: "", SCHEME: "", SCHEM_DESCRIPTION: "", SCHEME_EXP: "", SCHEME_QTY: "", SCHEME_VALUE: "", SCHEME_IDm: "", PTR: "", PTS: "", MSP: "", CATEGORY: "", IMG_URL: "", MANUF_ID: "", MANUF_NAME: "", PROD_STATUS: "", PROD_QTY: "")

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(SchemeClicked(_:)))
        self.schems.isUserInteractionEnabled = true
        self.schems.addGestureRecognizer(labelTap)
        mySwitch.setOn(false, animated: true)
        tv.isHidden = true
        addQtyBtn.isHidden = true
        subQtyBtn.isHidden = true
        free.isHidden = true
        tv.keyboardType = .numberPad //need to test
        tv.delegate = self
        
        
        tabBarLook.setBorderWhite(view: backView)
//        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        
    }
    @objc func SchemeClicked(_ sender: UITapGestureRecognizer) {
        print("labelTapped")
        deligate.schemeTapped(cell: self)
    }
 
    
 func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tv {
            deligate.didTvTap(cell: self)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        if textField == tv {
            deligate.didEndEditing(cell: self)
        }
    }
    
    func setupWithModel(model : Track) {
        
        free.isHidden = model.freeTrack
        
        mySwitch.setOn(model.invited, animated: false)
        if model.invited == true {
            tv.isHidden = false
            addQtyBtn.isHidden = false
            subQtyBtn.isHidden = false
        }else{
            tv.text = ""
            tv.isHidden = true
            addQtyBtn.isHidden = true
            subQtyBtn.isHidden = true
        }
        tv.text = model.qty
    }
    @IBOutlet weak var myNumericTextField: UITextField! {
        didSet { myNumericTextField?.addDoneCancelToolbar() }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        deligate.didQTYEnter(cell: self)
    }
  

    @IBAction func addQtyAction(_ sender: Any) {
        if tv.text != "" {
        let val = Int(tv.text!)
        tv.text = String(val! + 1)
        deligate.didAddQty(cell: self)
        }else{
            tv.text = "1"
        }
    }
    
    @IBAction func subQtyAction(_ sender: Any) {
        if tv.text != "" {
        let val = Int(tv.text!)
        if val! > 1 {
        tv.text = String(val! - 1)
        deligate.didSubQty(cell: self)
        }else{
            self.makeToast("Minimum Quantity Should be 1")
        }
        }
    }
    
    
    @IBAction func switchAction(_ sender: Any) {
        if mySwitch.isOn == true{
            tv.text = "1"
            tv.isHidden = false
            mySwitch.isOn = true
        }else{
            tv.text = ""
            tv.isHidden = true
            mySwitch.isOn = false
           
        }
            deligate.didTappedSwitch(cell: self)
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func viewInfoAct(_ sender: Any) {
        deligate.viewInfo(cell: self)
    }
    

}
