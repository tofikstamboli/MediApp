//
//  DBConnection.swift
//  MediAppIOS
//
//  Created by abhishek on 11/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import Foundation
import SQLite3

class DBConnection {
    
    var db:OpaquePointer?
   
   
    private let  fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("MediAppDatabase.sqlite")
  
    
    func opendb()->OpaquePointer{

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }

        return db!
    }
    
}
