//
//  LoginModel.swift
//  MediAppIOS
//
//  Created by abhishek on 26/10/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import Foundation
struct LoginModel : Codable {
    var status : String
    var error : String
    var user_info : user_info
}

struct user_info : Codable {
    var STATUS, SHOP_NAME, DEVICE_ID, REG_ID, IMEI, EMP_ID, H_ID, CONFIG_PROD_STATUS, FST_NAME, EMAIL_ID, MOBILE, PASSWORD, PHOTO, FST_ORD_FLAG, SHIPPING_ADDRESS, CITY, STATE, pin_area, POSTAL_CODE, ERROR, LATLONGFLAG, ORG_ID, token : String?
//        var STATUS, SHOP_NAME, DEVICE_ID, REG_ID, IMEI, EMP_ID, H_ID, CONFIG_PROD_STATUS, FST_NAME, EMAIL_ID, MOBILE, PASSWORD, PHOTO, FST_ORD_FLAG, SHIPPING_ADDRESS, CITY, STATE, LANDMARK, POSTAL_CODE, ERROR, LATLONGFLAG, token : String?
    
}
