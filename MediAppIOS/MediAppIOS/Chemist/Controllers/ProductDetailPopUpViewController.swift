//
//  ProductDetailPopUpViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 13/08/18.
//  Copyright © 2018 gstl. All rights reserved.
//

import UIKit
//import SDWebImage
import Kingfisher

class ProductDetailPopUpViewController: UIViewController {

    var pname = "", company = ""; var pcategory = "" ; var compo = "" ; var ppack = "";
    var pschemes = "" ; var pptr = "" ; var pmrp = ""
    var img : String = ""
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    @IBOutlet weak var product_img: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var composition: UILabel!
    @IBOutlet weak var pack: UILabel!
    @IBOutlet weak var schemes: UILabel!
    @IBOutlet weak var ptr: UILabel!
    @IBOutlet weak var mrp: UILabel!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var company_name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        product_name?.text = pname
        lbl?.text = pname
        category?.text = pcategory
        composition?.text = compo
        pack?.text = ppack
        schemes?.text = pschemes
        ptr?.text = "₹"+pptr
        mrp?.text = "₹"+pmrp
        company_name.text = company
        load_image(image_url_string: img)
        
        lbl.layer.cornerRadius = 10
        lbl.layer.borderWidth = 1
        lbl.layer.borderColor = UIColor.black.cgColor
        
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        product_img.isUserInteractionEnabled = true
        product_img.addGestureRecognizer(self.tapGestureRecognizer)
    }

    @IBAction func OnBackPress(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func load_image(image_url_string:String)
    {
        print(image_url_string)
        let url = URL(string: image_url_string) ?? URL(string: "http://leeford.in/wp-content/uploads/2017/09/image-not-found.jpg")!
        product_img.kf.setImage(with: url)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ZoomingViewController") as! ZoomingViewController
        vc.url = img
        navigationController?.pushViewController(vc,animated: true)
    }
    
  
}
