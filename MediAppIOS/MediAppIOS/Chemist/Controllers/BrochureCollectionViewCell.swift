//
//  BrochureCollectionViewCell.swift
//  MediAppIOS
//
//  Created by abhishek on 10/04/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class BrochureCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lablel: UILabel!
    @IBOutlet weak var composition: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var pack: UILabel!
    @IBOutlet weak var ptr: UILabel!
    @IBOutlet weak var mrp: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        imgView.isUserInteractionEnabled = true
//        imgView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
//    {
//
//
//    }
}
