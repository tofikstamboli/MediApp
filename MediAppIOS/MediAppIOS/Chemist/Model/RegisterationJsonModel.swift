//
//  RegisterationJsonModel.swift
//  MediAppIOS
//
//  Created by abhishek on 30/10/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import Foundation

struct  regiSuccessModel : Codable {
    var status : String
    var message : String
    var user_id : String
    var device_id : String
    var token : String
    var password : String
    var name : String
    var email : String
    var mobile : String
    var shop_name : String
    var landmark : String
    var city : String
    var state : String
    var pin : String
}
