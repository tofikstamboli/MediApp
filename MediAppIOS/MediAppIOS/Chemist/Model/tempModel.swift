//
//  tempModel.swift
//  MediAppIOS
//
//  Created by abhishek on 09/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import Foundation

class Product {
    
    var PRODUCT_ID,PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_COMPOSITION,PRODUCT_DISCRIPTION,SCHEME,SCHEM_DESCRIPTION,SCHEME_EXP,SCHEME_QTY,SCHEME_VALUE,SCHEME_IDm,PTR,PTS,MSP,CATEGORY,IMG_URL,MANUF_ID,MANUF_NAME,PROD_STATUS,PROD_QTY : String?
    
 
    init(PRODUCT_ID : String?,PRODUCT_NAME : String?,PRODUCT_TYPE : String?,PRODUCT_COMPOSITION : String?,PRODUCT_DISCRIPTION : String?,SCHEME : String?,SCHEM_DESCRIPTION : String?,SCHEME_EXP : String?,SCHEME_QTY : String?,SCHEME_VALUE : String?,SCHEME_IDm : String?,PTR : String?,PTS : String?,MSP : String?,CATEGORY : String?,IMG_URL : String?,MANUF_ID : String?,MANUF_NAME : String?,PROD_STATUS : String?,PROD_QTY : String?) {

        self.PRODUCT_NAME = PRODUCT_NAME
        self.PRODUCT_ID = PRODUCT_ID
        self.PRODUCT_TYPE = PRODUCT_TYPE
        self.PRODUCT_COMPOSITION = PRODUCT_COMPOSITION
        self.PRODUCT_DISCRIPTION = PRODUCT_DISCRIPTION
        self.SCHEME = SCHEME
        self.SCHEM_DESCRIPTION = SCHEM_DESCRIPTION
        self.SCHEME_EXP = SCHEME_EXP
        self.SCHEME_QTY = SCHEME_QTY
        self.SCHEME_VALUE = SCHEME_VALUE
        self.SCHEME_IDm = SCHEME_IDm
        self.PTR = PTR
        self.PTS = PTS
        self.MSP = MSP
        self.CATEGORY = CATEGORY
        self.IMG_URL = IMG_URL
        self.MANUF_ID = MANUF_ID
        self.MANUF_NAME = MANUF_NAME
        self.PROD_STATUS = PROD_STATUS
        self.PROD_QTY = PROD_QTY
    }
    
    func getMed() -> (String? , String? , String? , String? , String? , String? , String? ,String? , String?, String? , String? , String? , String? , String? , String?, String?, String?, String?, String?, String?) {
 return(PRODUCT_ID,PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_COMPOSITION,PRODUCT_DISCRIPTION,SCHEME,SCHEM_DESCRIPTION,SCHEME_EXP,SCHEME_QTY,SCHEME_VALUE,SCHEME_IDm,PTR,PTS,MSP,CATEGORY,IMG_URL,MANUF_ID,MANUF_NAME,PROD_STATUS,PROD_QTY)
        
        
    }
    
}



