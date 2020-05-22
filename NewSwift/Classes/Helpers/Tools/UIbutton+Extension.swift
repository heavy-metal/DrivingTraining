//
//  UIbutton+Extension.swift
//  NewSwift
//
//  Created by gail on 2017/12/8.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

typealias tapHandle = () -> ()

enum directionType {
    case left
    case right
}
var heandler: tapHandle?
extension UIButton {
    
    convenience init(imageName:String) {
        self.init()
        setImage(UIImage(named:imageName), for: .normal)
        sizeToFit()
    }
    
    convenience init(directionType:directionType ,target:Any ,action:Selector ,ImgName:String) {
        self.init()
        setImage(UIImage(named:ImgName), for: .normal)
        sizeToFit()
        width = 70 ; y = 20 + (44-height)/2
        switch directionType {
        case .left:
            x = 4 ;
            contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
        case .right:
            x = SCREEN_WIDTH - width
        }
        
        addTarget(target, action: action, for: .touchUpInside)
    }
    convenience init(title:String){
    
        self.init()
    
        self.frame = CGRect(x: SCREEN_WIDTH-40-20-15, y: SCREEN_HEIGHT/4*3, width: 40, height: 40)
        layer.cornerRadius = 40/2
        clipsToBounds = true
        backgroundColor = GlobalColor.withAlphaComponent(0.3)
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
    }
    
}

