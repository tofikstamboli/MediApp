//
//  BrochureViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 10/04/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit
import SQLite3
import Kingfisher

class BrochureViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    let data = ["hello","world","hello","world","hello","world"]
    var db: OpaquePointer?
    var stmt:OpaquePointer?
    var index = 0
    private var ProductListObject = [Product]()
    var tapGestureRecognizer = UITapGestureRecognizer()
    var thisImageUrl : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.dataSource = self
       
        loadData()
    }
    
    
    func loadData() {
        ProductListObject.removeAll()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MediAppDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &self.db) != SQLITE_OK {
            print("error opening database")
        }
        
        let queryString = "SELECT * FROM \(Constants.TABLE_GST_PRODUCT_MASTER)"
        
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            //Thread 1: EXC_BAD_ACCESS (code=1, address=0x8) sometime this error come here
            let PRODUCT_ID = String(cString: sqlite3_column_text(stmt, 0))
            let PRODUCT_NAME = String(cString: sqlite3_column_text(stmt, 1))
            let PRODUCT_TYPE = String(cString: sqlite3_column_text(stmt, 2))
            let PRODUCT_COMPOSITION = String(cString: sqlite3_column_text(stmt, 3))
            let PRODUCT_DISCRIPTION = String(cString: sqlite3_column_text(stmt, 4))
            let SCHEME = String(cString: sqlite3_column_text(stmt, 5))
            let SCHEM_DESCRIPTION = String(cString: sqlite3_column_text(stmt, 6))
            let SCHEME_EXP = String(cString: sqlite3_column_text(stmt, 7))
            let SCHEME_QTY = String(cString: sqlite3_column_text(stmt, 8))
            let SCHEME_VALUE = String(cString: sqlite3_column_text(stmt, 9))
            let SCHEME_ID = String(cString: sqlite3_column_text(stmt, 10))
            let PTR = String(cString: sqlite3_column_text(stmt, 11))
            let PTS = String(cString: sqlite3_column_text(stmt, 12))
            let MSP = String(cString: sqlite3_column_text(stmt, 13))
            let CATEGORY = String(cString: sqlite3_column_text(stmt, 14))
            let IMG_URL = String(cString: sqlite3_column_text(stmt, 15))
            let trimmedString = IMG_URL.trimmingCharacters(in: .whitespacesAndNewlines)
            let newUrl = trimmedString.replacingOccurrences(of: " ", with: "%20")
            let MANUF_ID = String(cString: sqlite3_column_text(stmt, 16))
            let MANUF_NAME = String(cString: sqlite3_column_text(stmt, 17))
            let PROD_STATUS = String(cString: sqlite3_column_text(stmt, 18))
            let PROD_QTY = String(cString: sqlite3_column_text(stmt, 19))
            
            
            ProductListObject.append(Product(PRODUCT_ID: PRODUCT_ID, PRODUCT_NAME: PRODUCT_NAME, PRODUCT_TYPE: PRODUCT_TYPE, PRODUCT_COMPOSITION: PRODUCT_COMPOSITION, PRODUCT_DISCRIPTION: PRODUCT_DISCRIPTION, SCHEME: SCHEME, SCHEM_DESCRIPTION: SCHEM_DESCRIPTION, SCHEME_EXP: SCHEME_EXP, SCHEME_QTY: SCHEME_QTY, SCHEME_VALUE: SCHEME_VALUE, SCHEME_IDm: SCHEME_ID, PTR: PTR, PTS: PTS, MSP: MSP, CATEGORY: CATEGORY, IMG_URL: newUrl, MANUF_ID: MANUF_ID, MANUF_NAME: MANUF_NAME, PROD_STATUS: PROD_STATUS, PROD_QTY: PROD_QTY))
            
        
        }
    
    }
    
    func load_image(img : ImageView , image_url_string:String)
    {
        print(image_url_string)
        let url = URL(string: image_url_string) ?? URL(string: "http://leeford.in/wp-content/uploads/2017/09/image-not-found.jpg")!
        img.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        
    }
    
  
//        performSegue(withIdentifier: "zoomSegue", sender: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ZoomingViewController") as! ZoomingViewController
//        //        vc.delegate = (self as! ChildViewControllerDelegate)
//        vc.img? = img
//        navigationController?.pushViewController(vc,animated: true)

    
    
}

extension BrochureViewController : UICollectionViewDataSource,UICollectionViewDelegate {

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductListObject.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BrochureCollectionViewCell
        cell.lablel.text = ProductListObject[indexPath.row].PRODUCT_NAME
        cell.imgView.kf.indicatorType = IndicatorType.activity
        load_image(img: cell.imgView, image_url_string: ProductListObject[indexPath.row].IMG_URL ?? "http://leeford.in/wp-content/uploads/2017/09/image-not-found.jpg")
        cell.composition.text = ProductListObject[indexPath.row].PRODUCT_COMPOSITION
        cell.category.text = ProductListObject[indexPath.row].CATEGORY
        cell.pack.text = ProductListObject[indexPath.row].PRODUCT_DISCRIPTION
        cell.ptr.text = ProductListObject[indexPath.row].PTR
        cell.mrp.text = ProductListObject[indexPath.row].MSP
        
        self.index = indexPath.row
       
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.imgView.isUserInteractionEnabled = true
        cell.imgView.addGestureRecognizer(self.tapGestureRecognizer)
        return cell
    }
    

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
        {
            let p = tapGestureRecognizer.location(in: self.collectionView)
            let indexPath = self.collectionView.indexPathForItem(at: p)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ZoomingViewController") as! ZoomingViewController
            vc.url = ProductListObject[indexPath?.row ?? 0].IMG_URL ?? "http://leeford.in/wp-content/uploads/2017/09/image-not-found.jpg"
                navigationController?.pushViewController(vc,animated: true)

        }
}
