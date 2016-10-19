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
        self.imageViewSizeToFit()
    }
    
    //切り取り処理
    //切り取った後、imageViewのframeを更新
    @IBAction func cropImage(_ sender: AnyObject) {
        let scale = imageView.image!.size.width / imageView.frame.size.width
        let rect = CGRect(x: cView.crop.frame.origin.x * scale,
                          y: cView.crop.frame.origin.y * scale,
                          width: cView.crop.frame.size.width * scale,
                          height: cView.crop.frame.size.height * scale)
        let imageRef:CGImage = imageView.image!.cgImage!.cropping(to: rect)!
        let croppedImage:UIImage = UIImage(cgImage: imageRef)
        imageView.image = croppedImage
        
        print(croppedImage)
        self.imageViewSizeToFit()
        
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
        originalFrame = imageView.frame
        
        //ImageViewリサイズ
        imageView.translatesAutoresizingMaskIntoConstraints = true
        outerView.translatesAutoresizingMaskIntoConstraints = true
        
        self.imageViewSizeToFit()
        
        
        
        cView = cropView.instanceFromNib() as! cropView
        cView.backgroundColor = UIColor.clear
        cView.frame = imageView.frame
        cView.crop.alpha = 0.5
        cView.LAView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panViewGesture(_:))))
        cView.RAView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panViewGesture(_:))))
        cView.LBView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panViewGesture(_:))))
        cView.RBView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panViewGesture(_:))))
        self.outerView.addSubview(cView)
        cView.layoutIfNeeded()
        cView.resize()
        
        
        
    }
    
    func panViewGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: sender.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        print("\(cView.crop.frame.width)" + "¥" + "\(outerView.frame.width)")
        
        
        //正方形リターン
        if (cView.crop.frame.maxX > outerView.frame.width  ||
            cView.crop.frame.maxY > outerView.frame.height ||
            cView.crop.frame.minY < 0 ||
            cView.crop.frame.minX < 0 ){
            cView.crop.frame = CGRect(x: 0, y: 0, width: outerView.frame.width, height: outerView.frame.height)
            return
        }
        
        //右下リターン
        if cView.RBView.frame.maxX > outerView.frame.width {
           cView.RBView.frame.origin.x = outerView.frame.width - cView.RBView.frame.width
            return
        }

        if cView.RBView.frame.maxY > outerView.frame.height {
           cView.RBView.frame.origin.y = outerView.frame.height - cView.RBView.frame.height
           return
        }
        
        //右上リターン
        if cView.RAView.frame.maxX > outerView.frame.width {
            cView.RAView.frame.origin.x = outerView.frame.width - cView.RAView.frame.width
            return
        }
        
        if cView.RAView.frame.minY < 0 {
            cView.RAView.frame.origin.y = 0
            return
        }
        
        //左上リターン
        if cView.LAView.frame.minX < 0 {
            cView.LAView.frame.origin.x = 0
            return
        }
        
        if cView.LAView.frame.minY < 0 {
            cView.LAView.frame.origin.y = 0
            return
        }
        
        //左下リターン
        if cView.LBView.frame.minX < 0 {
            cView.LBView.frame.origin.x = 0
            return
        }
        
        if cView.LBView.frame.maxY > outerView.frame.height {
            cView.LBView.frame.origin.y = outerView.frame.height - cView.LBView.frame.height
            return
        }
        
        
        
        
        if (sender.view == cView.RBView) {
            
            cView.RAView.center.x = (sender.view?.center.x)!
            cView.LBView.center.y = (sender.view?.center.y)!
        }
        else if (sender.view == cView.RAView) {
            cView.RBView.center.x = (sender.view?.center.x)!
            cView.LAView.center.y = (sender.view?.center.y)!
        }
        else if (sender.view == cView.LAView) {
            cView.LBView.center.x = (sender.view?.center.x)!
            cView.RAView.center.y = (sender.view?.center.y)!
        }
        else if (sender.view == cView.LBView) {
            cView.LAView.center.x = (sender.view?.center.x)!
            cView.RBView.center.y = (sender.view?.center.y)!
        }
            
        cView.crop.frame = CGRect(x: cView.LAView.frame.minX,
                                  y: cView.LAView.frame.minY,
                                  width: cView.RAView.frame.maxX - cView.LAView.frame.minX,
                                  height: cView.RBView.frame.maxY - cView.RAView.frame.minY)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
//    - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//    {
//    // "hidden", "userInteractionEnabled", "alpha" の値を考慮する
//    if (self.button.isHidden || self.button.userInteractionEnabled == NO || self.button.alpha < 0.01) {
//    return [super hitTest:point withEvent:event];
//    }
//    
//    // button のあたり判定 rect を作成
//    CGRect rect = CGRectInset(self.button.frame, -20, -10);
//    // あたり判定 rect 内であれば、button を返し、button にイベントを受けられるようにする
//    if (CGRectContainsPoint(rect, point)) {
//    return self.button;
//    }
//    
//    // button のあたり判定外だったら従来の挙動に任せる
//    return [super hitTest:point withEvent:event];
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

