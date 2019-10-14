//
//  CartTabTableViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 10/09/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import SQLite3

protocol CustomTableViewCellDelegate {
    func buttonTapped(cell:CartTabTableViewCell)
    func textChanged(cell:CartTabTableViewCell)
    func SetflagForCount(cell:CartTabTableViewCell,flag:Bool)
//    func addQty(cell:CartTabTableViewCell)
//    func subQty(cell:CartTabTableViewCell)
}
class CartTabTableViewCell: UITableViewCell {
var pid = ""
   
    @IBOutlet weak var cartProductName: UILabel!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var cartProductQty: UITextField!
    @IBOutlet weak var PtrLbl: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var prddisc: UILabel!
    @IBOutlet weak var freeoffers: UILabel!
    @IBOutlet weak var prdimg : UIImageView!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var subbtn: UIButton!
    
    
    var delegate: CustomTableViewCellDelegate!
    let dbcon = DBConnection()
    var opqptr : OpaquePointer! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        opqptr = dbcon.opendb()
        cartProductQty.keyboardType = .numberPad
        freeoffers.isHidden = true
        prddisc.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        }
    

    @IBAction func delBtnAction(_ sender: Any) {
        delegate.buttonTapped(cell:self)
    }
    @IBOutlet weak var myNumericTextField: UITextField! {
        didSet { myNumericTextField?.addDoneCancelToolbar() }
    }
    
    @IBAction func editingChnged(_ sender: Any) {
        
        if cartProductQty.text?.count == 0 || cartProductQty.text == "0" {
            delegate.SetflagForCount(cell: self,flag: true)
        }
        delegate.SetflagForCount(cell: self,flag: false)
        delegate.textChanged(cell: self)
    }
    
    
    @IBAction func addQtyAction(_ sender: Any) {
        if cartProductQty.text! ==  ""{
            cartProductQty.text = "1"
            delegate.SetflagForCount(cell: self,flag: true)
            delegate.textChanged(cell: self)
        }else{
        cartProductQty.text = String(Int(cartProductQty.text!)! + 1)
        delegate.SetflagForCount(cell: self,flag: true)
        delegate.textChanged(cell: self)
        }
    }
    
    @IBAction func subQtyAction(_ sender: Any) {
        if cartProductQty.text! ==  "" || Float(cartProductQty.text!) == 0 {
            cartProductQty.text = ""
            self.makeToast("Enter Only Positive Value!")
        }else{
        cartProductQty.text = String(Int(cartProductQty.text!)! - 1)
        delegate.SetflagForCount(cell: self,flag: true)
        delegate.textChanged(cell: self)
        }
    }
    
    }
    

