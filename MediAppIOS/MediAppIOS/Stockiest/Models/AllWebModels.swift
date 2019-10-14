//
//  AllWebModels.swift
//  MediAppIOS
//
//  Created by iMac on 31/05/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import Foundation

struct StockistConnData : Codable {
    var status,error : String?
    var chemistinfo : [conInfo]?
}

struct conInfo : Codable {
    var STATUS,
    EMPLOYEE_ID,
    ORG_ID,
    IMEI,
    FST_NAME,
    NAME,
    MOBILE,
    MOBILE_ALT,
    EMAIL,
    CITY,
    STATE,
    ADDRESS,
    H_ID,
    SESSION_H_ID,
    CON_STATUS,
    ID,
    DRUG_LICENE_NO,
    GSTN_NUMBER : String?
}
