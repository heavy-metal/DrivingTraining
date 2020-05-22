//
//  TitleScrollView.swift
//  NewSwift
//
//  Created by gail on 2019/5/28.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class TitleScrollView: UIView ,UIScrollViewDelegate{

    lazy var selectedBtn:UIButton = UIButton(type: .custom)
    var isInitialize:Bool = false
    var titleColor:UIColor?
    var selectColor:UIColor?
    var isNavigaBar:Bool?
    lazy var titleButtons:[UIButton] = [UIButton]()
    lazy var titleArray = [String]()
    lazy var titleScrollView:UIScrollView = {
        let width = isNavigaBar == true ? SCREEN_WIDTH-55 : SCREEN_WIDTH
        let titleScr = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: 40) )
        titleScr.delegate = self
        titleScr.showsHorizontalScrollIndicator = false
        titleScr.bounces = false
        return titleScr
    }()
    lazy var lineView = { () ->  UIView in
        var lineView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/CGFloat(titleArray.count), height: 1.8))
        lineView.y = 40-3
        return lineView
    }()
    
    init(frame: CGRect ,titleArray:[String] ,titleColor:UIColor ,selectColor:UIColor ,isNavigaBar:Bool) {
        super.init(frame: frame)
        self.titleColor = titleColor
        self.selectColor = selectColor
        self.titleArray = titleArray
        self.isNavigaBar = isNavigaBar
        addSubview(titleScrollView)
        
       
        setupAllTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupAllTitle(){
        
        let count = titleArray.count
        var btnW = count>4 ? 100 : SCREEN_WIDTH/CGFloat(count)
        if isNavigaBar == true && count <= 4 {
             btnW = (SCREEN_WIDTH-55)/CGFloat(count)
        }
        
        let btnH = titleScrollView.height
        var btnX:CGFloat = 0
        for i in 0..<count {
            let titleButton = UIButton(type: .custom)
            titleButton.tag = i
            titleButton.setTitle(titleArray[i], for: .normal)
            btnX = CGFloat(i) * btnW
            titleButton.setTitleColor(titleColor, for: .normal)
            titleButton.frame = CGRect(x:btnX, y: 0, width:btnW, height:btnH)
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: isNavigaBar! ? 14 : 16)
            titleButton.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
            titleButtons.append(titleButton)
            
            if i==0 {
                
                titleBtnClick(btn: titleButton)
                titleButton.titleLabel?.sizeToFit()
                lineView.width = (titleButton.titleLabel?.width)!/2
                lineView.centerX = titleButton.centerX
                lineView.backgroundColor = titleButton.titleColor(for: .normal)?.withAlphaComponent(0.7)
                titleScrollView.addSubview(lineView)
            }
            titleScrollView.addSubview(titleButton)
        }
        titleScrollView.contentSize = CGSize(width: CGFloat(count)*btnW, height: 0)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "scrollViewDidEnd"), object: nil, queue: nil) { (info) in
            
            let i = info.object as! NSInteger
            let titleBtn:UIButton = self.titleButtons[i]
            self.selButton(button: titleBtn)
            UIView.animate(withDuration: 0.1) {
                self.lineView.centerX = titleBtn.centerX
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "scrollViewDidScroll1"), object: nil, queue: nil) { (info) in
            self.dealWithFont(x: info.object as! CGFloat)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func titleBtnClick(btn:UIButton) {
        let index = btn.tag
        selButton(button: btn)
        UIView.animate(withDuration: 0.1) {
            self.lineView.centerX = btn.centerX
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("titleBtnClick"), object: index)

    }
    /// - 选中标题
    private func selButton(button:UIButton) {
        
        selectedBtn.transform = CGAffineTransform.identity
        selectedBtn.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(selectColor, for: .normal)
        setupTitleCenter(btn: button)
        button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        selectedBtn = button
    }
    /// - 标题居中
    private func setupTitleCenter(btn:UIButton) {
        
        if titleArray.count <= 4 { return }
        var offsetX : CGFloat = btn.centerX - SCREEN_WIDTH*0.5
        if offsetX < 0 { offsetX = 0 }
        
        let maxOffsetX : CGFloat = titleScrollView.contentSize.width - SCREEN_WIDTH
        if offsetX > maxOffsetX { offsetX = maxOffsetX }
        
        titleScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    
    func dealWithFont(x:CGFloat) {
    
        let leftI : NSInteger = NSInteger(x/SCREEN_WIDTH)
        let rightI : NSInteger = leftI + 1

        let leftBtn = titleButtons[leftI]
        var rightBtn = UIButton()
        let count = titleButtons.count
        if rightI<count {
            rightBtn = titleButtons[rightI]
        }
        var scaleR:CGFloat = x/SCREEN_WIDTH
        //you边缩放比例
        scaleR -= CGFloat(leftI)
        // 左边缩放比例
        let scaleL = 1-scaleR
        leftBtn.transform = CGAffineTransform.init(scaleX: scaleL*0.2+1, y: scaleL*0.2+1)
        rightBtn.transform = CGAffineTransform.init(scaleX: scaleR*0.2+1, y: scaleR*0.2+1)
    }
}
