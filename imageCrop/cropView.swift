//
//  File.swift
//  imageCrop
//
//  Created by Shinya Yamamoto on 2016/10/17.
//  Copyright © 2016年 Shinya Yamamoto. All rights reserved.
//

import UIKit

class cropView :UIView {
    @IBOutlet weak var crop:UIView!
    @IBOutlet weak var LAView:UIView!
    @IBOutlet weak var RAView:UIView!
    @IBOutlet weak var LBView:UIView!
    @IBOutlet weak var RBView:UIView!
    @IBOutlet weak var imageView: UIImageView!
    var originalImage: UIImage!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "cropView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.crop.alpha = 0.5
        self.crop.layer.borderColor = UIColor.blue.cgColor
        self.crop.layer.borderWidth = 2.0
        self.LAView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panViewGesture(_:))))
        self.RAView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panViewGesture(_:))))
        self.LBView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panViewGesture(_:))))
        self.RBView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panViewGesture(_:))))
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    func passCroppedImage() -> UIImage {
        let scale = imageView.image!.size.width / imageView.frame.size.width
        let rect = CGRect(x: self.crop.frame.origin.x * scale,
                          y: self.crop.frame.origin.y * scale,
                          width: self.crop.frame.size.width * scale,
                          height: self.crop.frame.size.height * scale)
        let imageRef:CGImage = imageView.image!.cgImage!.cropping(to: rect)!
        let croppedImage:UIImage = UIImage(cgImage: imageRef)
        print(croppedImage)
        return croppedImage
    }
    
//    func imageViewSizeToFit() {
//        
//        if imageView.image!.size.width > imageView.image!.size.height {
//            imageView.frame.size.height = imageView.image!.size.height * imageView.frame.size.width / imageView.image!.size.width
//        } else {
//            imageView.frame.size.width = imageView.image!.size.width * imageView.frame.size.height / imageView.image!.size.height
//        }
//        self.frame = imageView.bounds
//    }
    
//    func resize() {
//        self.crop.frame = CGRect(x: self.LAView.frame.minX,
//                                 y: self.LAView.frame.minY,
//                                 width: self.RAView.frame.maxX - self.LAView.frame.minX,
//                                 height: self.RBView.frame.maxY - self.RAView.frame.minY)
//    }
    
    func resetViews() {
        self.crop.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.RBView.frame.origin.x = self.frame.width - self.RBView.frame.width
        self.RBView.frame.origin.y = self.frame.height - self.RBView.frame.height
        self.RAView.frame.origin.x = self.frame.width - self.RAView.frame.width
        self.RAView.frame.origin.y = 0
        self.LAView.frame.origin.x = 0
        self.LAView.frame.origin.y = 0
        self.LBView.frame.origin.x = 0
        self.LBView.frame.origin.y = self.frame.height - self.LBView.frame.height
    }
    
    func panViewGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: sender.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
        
        print("\(self.crop.frame.width)" + "¥" + "\(self.frame.width)")
        
        
        //正方形リターン
        if (self.crop.frame.maxX > self.frame.width  ||
            self.crop.frame.maxY > self.frame.height ||
            self.crop.frame.minY < 0 ||
            self.crop.frame.minX < 0 ){
            self.crop.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            return
        }
        
        //右下リターン
        if self.RBView.frame.maxX > self.frame.width {
            self.RBView.frame.origin.x = self.frame.width - self.RBView.frame.width
            return
        }
        
        if self.RBView.frame.maxY > self.frame.height {
            self.RBView.frame.origin.y = self.frame.height - self.RBView.frame.height
            return
        }
        
        //右上リターン
        if self.RAView.frame.maxX > self.frame.width {
            self.RAView.frame.origin.x = self.frame.width - self.RAView.frame.width
            return
        }
        
        if self.RAView.frame.minY < 0 {
            self.RAView.frame.origin.y = 0
            return
        }
        
        //左上リターン
        if self.LAView.frame.minX < 0 {
            self.LAView.frame.origin.x = 0
            return
        }
        
        if self.LAView.frame.minY < 0 {
            self.LAView.frame.origin.y = 0
            return
        }
        
        //左下リターン
        if self.LBView.frame.minX < 0 {
            self.LBView.frame.origin.x = 0
            return
        }
        
        if self.LBView.frame.maxY > self.frame.height {
            self.LBView.frame.origin.y = self.frame.height - self.LBView.frame.height
            return
        }
        
        
        
        
        if (sender.view == self.RBView) {
            
            self.RAView.center.x = (sender.view?.center.x)!
            self.LBView.center.y = (sender.view?.center.y)!
        }
        else if (sender.view == self.RAView) {
            self.RBView.center.x = (sender.view?.center.x)!
            self.LAView.center.y = (sender.view?.center.y)!
        }
        else if (sender.view == self.LAView) {
            self.LBView.center.x = (sender.view?.center.x)!
            self.RAView.center.y = (sender.view?.center.y)!
        }
        else if (sender.view == self.LBView) {
            self.LAView.center.x = (sender.view?.center.x)!
            self.RBView.center.y = (sender.view?.center.y)!
        }
        
        self.crop.frame = CGRect(x: self.LAView.frame.minX
            ,
                                  y: self.LAView.frame.minY,
                                  width: self.RAView.frame.maxX - self.LAView.frame.minX,
                                  height: self.RBView.frame.maxY - self.RAView.frame.minY)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
