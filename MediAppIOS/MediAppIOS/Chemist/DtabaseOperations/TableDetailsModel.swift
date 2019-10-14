//
//  ArticleMode.swift
//  MediAppIOS
//
//  Created by abhishek on 02/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit

struct Table_Details: Decodable {
    let status: String
    let error: String
    let check_book: [CHECK_BOOK]
    let stk_book: [stk_book]
   

    
}
struct  CHECK_BOOK : Decodable {
    let table_name : String
    let status : String
    let h_id : String


}

struct stk_book : Decodable {
    let table_name : String
    let h_id : Int
    let v_insert : String
    

    
}
