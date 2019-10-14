//
//  FetchHttpData.swift
//  MediAppIOS
//
//  Created by iMac on 23/05/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import Foundation
import SQLite3
class FetchHttpData {

    static func updateDataModels <T : Codable> (url: String, type: T.Type, completionHandler:@escaping (_ details: Codable?) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                let dataFamilies = try JSONDecoder().decode(type, from: data)// error takes place here
                
                completionHandler(dataFamilies)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
                return
            }
            }.resume()
    }
}

class tabBarLook {
   static func cornerRaduiusSet(view:UIView){
        view.layer.cornerRadius = 10
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.orange.cgColor
    }
    
   static func feelAndColor(view:UIView){
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    static func setBorderWhite(view:UIView){
        view.layer.cornerRadius = 10
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    static func normalTabBarCorner(view:UIView){
        view.layer.cornerRadius = 10
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
    }
    static func highlitedTabBarCorner(view:UIView){
        view.layer.borderColor = UIColor.orange.cgColor
    }
}

//How to use ??
//let url = Constants.stockisturl + "?end_point=stockiestLogin&emp_id=\(String(emp_id))"
//FetchHttpData.updateDataModels(url: url, type: StockistConnData.self){
//    response in
//    self.tem = response as! StockistConnData
//    DispatchQueue.main.async {
//        self.tableView.reloadData()
//        UIViewController.removeSpinner(spinner: self.sv)
//    }
//}


class DropAllTables : NSObject {
    var db: OpaquePointer? = nil
    var dbStatement: OpaquePointer? = nil
    var StatementString : String!
    
    func DropTables(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MediAppDatabase.sqlite")
        if sqlite3_open(fileURL.path, &self.db) != SQLITE_OK {
            print("error opening database")
        }
        StatementString = "DROP TABLE \(Constants.TABLE_GST_PRODUCT_MASTER);"
        deleteSqlTableData(query: StatementString)
        StatementString = "DROP TABLE \(Constants.TABLE_GST_ADDTOCART_PRODUCT_MASTER);"
        deleteSqlTableData(query: StatementString)
    }
    func deleteSqlTableData(query : String) {

        if sqlite3_prepare(self.db, query, -1, &dbStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(self.db)!)
            print("error preparing insert: \(errmsg)")
            return
        }else{
            print("Success")
        }
        
        if sqlite3_step(self.dbStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(self.db)!)
            print("failure inserting operation: \(errmsg)")
            return
        }else{
            print("Success")
        }
        sqlite3_finalize(self.dbStatement)
    }
}
