//
//  SearchChemistTableViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 02/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
import SQLite3

class SearchChemistTableViewController: UITableViewController {

    var ListOfProduct = [Product]()
    var data = [String]()
    var PRODUCT_ID,PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_COMPOSITION,PRODUCT_DISCRIPTION,SCHEME,SCHEM_DESCRIPTION,SCHEME_EXP,SCHEME_QTY,SCHEME_VALUE,SCHEME_IDm,PTR,PTS,MSP,CATEGORY,IMG_URL,MANUF_ID,MANUF_NAME,PROD_STATUS,PROD_QTY : String?
    
     var db: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension;
       // self.tableView.rowHeight = 50.0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ListOfProduct.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! SearchChemistTableViewCell

        // Configure the cell...
//        (pid , name , mid , dis ,schems, pack, ptr, mrp, offer) = (ListOfProduct[indexPath.row].getMed())
  
        (PRODUCT_ID,PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_COMPOSITION,PRODUCT_DISCRIPTION,SCHEME,SCHEM_DESCRIPTION,SCHEME_EXP,SCHEME_QTY,SCHEME_VALUE,SCHEME_IDm,PTR,PTS,MSP,CATEGORY,IMG_URL,MANUF_ID,MANUF_NAME,PROD_STATUS,PROD_QTY) = (ListOfProduct[indexPath.row].getMed())
        
        cell.productName?.text = PRODUCT_NAME
//        cell.pack?.text = PACK
        cell.schems?.text = SCHEME
        cell.productComposition?.text = PRODUCT_COMPOSITION
        cell.ptr?.text = PTR
        cell.mrp?.text = MSP

        return cell
   
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        let ProdDetailIntance = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailPopUpViewController") as! ProductDetailPopUpViewController;
        (PRODUCT_ID,PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_COMPOSITION,PRODUCT_DISCRIPTION,SCHEME,SCHEM_DESCRIPTION,SCHEME_EXP,SCHEME_QTY,SCHEME_VALUE,SCHEME_IDm,PTR,PTS,MSP,CATEGORY,IMG_URL,MANUF_ID,MANUF_NAME,PROD_STATUS,PROD_QTY) = (ListOfProduct[indexPath.row].getMed())

        //print(PRODUCT_NAME)
//        ProdDetailIntance.product_name?.text = PRODUCT_NAME
//        ProdDetailIntance.composition?.text = PRODUCT_COMPOSITION
        performSegue(withIdentifier: "showProductDetailSegue", sender: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sender = segue.destination as! ProductDetailPopUpViewController
        sender.pname = PRODUCT_NAME!
        sender.pcategory = CATEGORY!
        sender.compo = PRODUCT_COMPOSITION!
//        sender.ppack = PACK!
        sender.pschemes = SCHEME!
        sender.pptr = PTR!
        sender.pmrp = MSP!
        sender.img = IMG_URL!
        
    }
    
}

    
    

