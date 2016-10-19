//
//  ViewController.swift
//  imageCrop
//
//  Created by Shinya Yamamoto on 2016/10/17.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var cView:cropView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var cropButton: UIButton!
    let originalImage = UIImage(named: "samle")
    var originalFrame = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func tapResetButton(_ sender: AnyObject) {
        imageView.frame = originalFrame
        imageView.image = originalImage
        self.imageView.isHidden = true
        cView.isHidden = false
        cView.resetViews()
    }
    
    //切り取り処理
    //切り取った後、imageViewのframeを更新
    @IBAction func cropImage(_ sender: UIButton) {
        
        if sender.currentTitle == "切り取り" {
            self.imageView.image = cView.passCroppedImage()
            self.imageView.isHidden = false
            cView.isHidden = true
            sender.setTitle("切り取り開始", for: .normal)
        } else {
            self.imageView.isHidden = true
            self.cView.isHidden = false
            sender.setTitle("切り取り", for: .normal)
        }
        
        
    }
    
    
    func imageViewSizeToFit() {
        
        if imageView.image!.size.width > imageView.image!.size.height {
            imageView.frame.size.height = imageView.image!.size.height * imageView.frame.size.width / imageView.image!.size.width
        } else {
            imageView.frame.size.width = imageView.image!.size.width * imageView.frame.size.height / imageView.image!.size.height
        }
        outerView.frame = imageView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.backgroundColor = UIColor.red
        
        
        //ImageViewリサイズ
        imageView.translatesAutoresizingMaskIntoConstraints = true
        outerView.translatesAutoresizingMaskIntoConstraints = true
        self.imageViewSizeToFit()
        originalFrame = imageView.frame
        
        
        cView = cropView.instanceFromNib() as! cropView
        cView.imageView.image = self.imageView.image
        cView.frame = imageView.frame
        self.outerView.addSubview(cView)
        
        self.imageView.isHidden = true
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

