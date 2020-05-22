//
//  CustomTabBar.swift
//  NewSwift
//
//  Created by gail on 2017/12/8.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {
   fileprivate lazy var pushBtn:UIButton = {
        let btn = UIButton(imageName:"tabbar_pushBtn.png")
        addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()
    
}
extension CustomTabBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width:CGFloat = self.width
        let height:CGFloat = self.height
        
        let btnW = width/3.0
        let btnH = height
        var i = 0
        var x:CGFloat = 0
        
        for button in self.subviews {
            if button.isKind(of: NSClassFromString("UITabBarButton")!){
                
                if i==1 {
                   i += 1
                }
                x =  CGFloat (i) * btnW
                button.frame = CGRect(x: x, y: 0, width: btnW, height: btnH)
                i += 1
            }
        }
        pushBtn.center = CGPoint(x: width*0.5, y: height*0.5)
    }
}

// MARK: - pushBtn点击响应事件
extension CustomTabBar {
    @objc func btnClick() {
        
    }
    
}

