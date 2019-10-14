//
//  LoadDataProcesses.swift
//  MediAppIOS
//
//  Created by abhishek on 27/11/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import Foundation

class  loadBackData {
    var response1 : connection_model!
     let preferences = UserDefaults.standard
    func loadConnectionData(empid : String){
        while(response1 == nil){
                let newurl = URL(string:"http://13.127.182.214/mediapp/miljon_new/v1?end_point=stockiestLogin&emp_id=\(empid)")
        
                print( "Hello")
        
        let task = URLSession.shared.dataTask(with: newurl!) { (data, response, error) in
                    do {
                        // data we are getting from network request
                        let decoder = JSONDecoder()
        
                        let response = try decoder.decode(connection_model.self, from: data!)
                        self.response1 = response
                  
                        //return response.chemistinfo.count
                        print("Response",response)
        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
                task.resume()
    }
        
        preferences.set(response1, forKey: "ConnectionsData")
       
            }
}
