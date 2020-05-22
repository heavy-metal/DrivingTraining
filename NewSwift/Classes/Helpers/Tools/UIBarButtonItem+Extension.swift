//
//  UIBarButtonItem+Extension.swift
//  NewSwift
//
//  Created by gail on 2017/12/21.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit


extension UIBarButtonItem  {
    
    enum directionType {
        case left
        case right
    }
    
    convenience init(directionType:directionType, imageName:String, target:Any, action:Selector) {
         let btn = UIButton(type: .custom)
        btn.sizeToFit()
        btn.setImage(UIImage(named:imageName), for: .normal)
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        switch directionType {
        case .left:
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        case .right:
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5)
        }
        self.init(customView:btn)
    }
    
}

