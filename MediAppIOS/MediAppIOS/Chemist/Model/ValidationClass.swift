//
//  ValidationClass.swift
//  MediAppIOS
//
//  Created by abhishek on 01/02/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import Foundation
class validation {
//    var errmsg = ""
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidPhone(value: String) -> Bool {
        if value.count < 10 || value.count > 10{
            return false
        }
      return true
    }
    
    func isValidGST(value: String) -> Bool {
        let GST_REGEX = "^([0]{1}[1-9]{1}|[1-2]{1}[0-9]{1}|[3]{1}[0-7]{1})([a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}[zZ]{1}[0-9a-zA-Z]{1})+$"
        let gstTest = NSPredicate(format: "SELF MATCHES %@", GST_REGEX)
        let result = gstTest.evaluate(with: value)
        return result
    }
    func isValidPin(value : String)->Bool{
        if value.count == 6{
            return true
        }
        else{
            return false
        }
    }
    
    
    
    
}

public class fillAndColorClass {
    public func feelAndColor(view:UIView){
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.orange.cgColor
    }
}
