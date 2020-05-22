//
//  CustomTextField.swift
//  DistanceEducation
//
//  Created by gail on 2018/6/4.
//  Copyright © 2018年 NewSwift. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 22
        clipsToBounds = true
        leftViewMode = .always
        self.tintColor = GlobalColor
        returnKeyType = .go
        //只要输入框有内容就出现
        
//        let clearBtn = self.value(forKey: "_clearButton") as! UIButton
//        clearBtn.setImage(UIImage(named: "back"), for: .normal)
        self.clearButtonMode = .whileEditing
        
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        iconRect.origin.x += 15 //右边偏15
        return iconRect
    }
    //文字与输入框的距离
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 0)
        
    }
    //控制文本的位置
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 0)
    }
}
