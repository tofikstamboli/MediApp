//
//  RestWork.swift
//  MediAppIOS
//
//  Created by abhishek on 20/11/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import Foundation

class RestWork {
    var prefrences = UserDefaults.standard
    var emp_id : String = ""
    var WalletData : WalletModel!
    var callback : ((WalletModel)->())?
    func WalletDataFetch(){
        //////
        
        /////
        
        emp_id = prefrences.string(forKey: "EMP_ID")!
        guard let url = URL(string:Constants.wallet_url+"?username=\(emp_id)&function_name=getWalletValues")
            
            else {
                print("URL Error!")
                return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                // data we are getting from network request
                let decoder = JSONDecoder()
                let response = try decoder.decode(WalletModel.self, from: data!)
                self.WalletData = response
                self.callback?(response)
               //self.performSegue(withIdentifier: "stockistlistsegue", sender: nil)
                
            }
            
            catch _ {
                
            print("Error at getting wallet data! ")
                //self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
    }
  
    
}
