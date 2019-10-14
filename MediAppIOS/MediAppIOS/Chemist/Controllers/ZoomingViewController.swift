//
//  ZoomingViewController.swift
//  MediAppIOS
//
//  Created by abhishek on 12/04/19.
//  Copyright © 2019 gstl. All rights reserved.
//

import UIKit

class ZoomingViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var myScroll: UIScrollView!
    @IBOutlet weak var img: UIImageView!
    
    var url : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        myScroll.delegate = self
        myScroll.minimumZoomScale = 1.0
        myScroll.maximumZoomScale = 10.0
        img.layer.borderWidth = 2
        img.layer.borderColor = UIColor.black.cgColor
        load_image()
    }
    func viewForZooming(in myScroll: UIScrollView) -> UIView? {
        return img
    }
    func load_image()
    {
      
        let url = URL(string: self.url) ?? URL(string: "http://leeford.in/wp-content/uploads/2017/09/image-not-found.jpg")!
        //        img.kf.indicatorType = .activity
        img.kf.indicatorType = .activity
        img.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        
    }
}
