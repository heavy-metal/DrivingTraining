//
//  ApplyBtn.swift
//  NewSwift
//
//  Created by gail on 2018/1/9.
//  Copyright © 2018年 NewSwift. All rights reserved.
//

import UIKit

class ApplyBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       setUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
        setUI()
    }
    
    
    func setUI () {
        setTitle("报名", for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        setTitleColor(UIColor.black, for: .normal)
        layer.cornerRadius = 15
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
    }
}

class StydyTimeBtn: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI1()
    }
    
    func setUI1 () {
//        setTitle("照片", for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 13)
        setTitleColor(UIColor.black, for: .normal)
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
    }
}
