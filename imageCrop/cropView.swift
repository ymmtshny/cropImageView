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
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "cropView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func resize() {
        self.crop.frame = CGRect(x: self.LAView.frame.minX,
                                 y: self.LAView.frame.minY,
                                 width: self.RAView.frame.maxX - self.LAView.frame.minX,
                                 height: self.RBView.frame.maxY - self.RAView.frame.minY)
    }
}
