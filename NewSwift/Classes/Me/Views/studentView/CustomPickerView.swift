//
//  CustomPickerView.swift
//  NewSwift
//
//  Created by gail on 2019/6/25.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

typealias DefineClick = (_ index:NSInteger)->()


class CustomPickerView: UIView {

    lazy var pickerView:UIPickerView = {
        var pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: SCREEN_WIDTH, height:SCREEN_HEIGHT*0.4))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        return pickerView
    }()
    lazy var defineBtn:UIButton = {
        var button = UIButton(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH-70, y: 5, width: 60, height: 27)
        button.backgroundColor = GlobalColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(getPickerViewValue), for: .touchUpInside)
        return button
    }()
    lazy var cancelBtn:UIButton = {
        var button = UIButton(frame:CGRect.zero)
        button.frame = CGRect(x: 10, y: 5, width: 60, height: 27)
        button.setTitleColor(GlobalColor, for: .normal)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = GlobalColor.cgColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancelpickerView), for: .touchUpInside)
        return button
    }()
    
    lazy var toolBar:UIToolbar = {
       var toolBar = UIToolbar(frame: CGRect(x: 0, y: pickerView.frame.minY-50, width: SCREEN_WIDTH, height: 50))
        toolBar.backgroundColor = UIColor.white
        let cancelItem = UIBarButtonItem(customView: cancelBtn)
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let defineItem = UIBarButtonItem(customView: defineBtn)
        toolBar.setItems([cancelItem,spaceItem,defineItem], animated: true)
        return toolBar
    }()
    var contentArray : [String]?
    var defineClick:DefineClick?
    
    init(frame: CGRect ,contentArray:[String] ,defineClick:@escaping DefineClick) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(pickerView)
        addSubview(toolBar)
        self.contentArray = contentArray
        self.defineClick = defineClick
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
}
extension CustomPickerView : UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {//设置PickerView列数(dataSourse协议)
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.contentArray?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return contentArray?[row]
    }
    //设置列宽
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return 200
        
    }
    //设置行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    @objc func getPickerViewValue() {
        
        self.defineClick!(pickerView.selectedRow(inComponent: 0))
        UIView.animate(withDuration: 0.4) {
            self.y += SCREEN_HEIGHT*0.4 + 50
        }
    }
    @objc func cancelpickerView() {
        UIView.animate(withDuration: 0.4) {
            self.y += SCREEN_HEIGHT*0.4 + 50
        }
    }
}
