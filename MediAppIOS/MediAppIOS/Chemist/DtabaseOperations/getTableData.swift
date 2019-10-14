//
//  getTableData.swift
//  MediAppIOS
//
//  Created by abhishek on 11/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import Foundation
import SQLite3
class GetTableData {
    
    var ListOfProduct = [Product]()
    
        let queryString = "SELECT * FROM \(Constants.TABLE_GST_PRODUCT_MASTER)"
        
        let conn = DBConnection()
        var stmt : OpaquePointer? = nil

}
