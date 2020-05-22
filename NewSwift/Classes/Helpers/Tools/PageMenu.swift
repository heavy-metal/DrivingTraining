//
//  PageMenu.swift
//  NewSwift
//
//  Created by gail on 2017/12/27.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

class PageMenu: UIView {
    
    lazy var selectedBtn:UIButton = UIButton(type: .custom)
    var isInitialize:Bool = false
    var titleArray:[String]?
    
    lazy var titleButtons:[UIButton] = [UIButton]()
    lazy var titleScrollView:UIScrollView = {
        let titleScr = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: 40) )
        titleScr.showsHorizontalScrollIndicator = false
        titleScr.bounces = false
        titleScr.backgroundColor = GlobalColor
        return titleScr
    }()
    
    lazy var contentScrollView:UIScrollView = {
        let y = titleScrollView.frame.maxY
        let contentScrollView = UIScrollView(frame: CGRect(x: 0, y: y, width: SCREEN_WIDTH, height: height-y))
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        contentScrollView.backgroundColor = UIColor.white
        return contentScrollView
    }()
    lazy var lineView = { () ->  UIView in
        var lineView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/CGFloat(titleArray?.count ?? 0), height: 2))
        
        return lineView
    }()
    
    var titleColor:UIColor?
    var selectedColor:UIColor?
    var parantVC:UIViewController?
    
    var cenX = 0
    
    init(frame: CGRect, titleColor:UIColor ,selectedColor:UIColor ,titleArray:[String] ,parantVC:UIViewController){
        super.init(frame: frame)
        
        self.titleColor = titleColor
        self.selectedColor = selectedColor
        self.titleArray = titleArray
        self.parantVC = parantVC
        
        addSubview(titleScrollView)

        addSubview(contentScrollView)
        
        setupAllTitle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lineView.y = titleScrollView.height - 5
    }
}
extension PageMenu{
    
    fileprivate func setupAllTitle(){
        
        guard let count = parantVC?.childViewControllers.count else {return}
        let btnW = count>4 ? 100 : width/CGFloat(count)
        let btnH = titleScrollView.height
        var btnX:CGFloat = 0
        for i in 0..<count {
            let titleButton = UIButton(type: .custom)
            titleButton.tag = i
//            let vc = viewController()?.childViewControllers[i]
            titleButton.setTitle(titleArray?[i], for: .normal)
            btnX = CGFloat(i) * btnW
            titleButton.setTitleColor(titleColor, for: .normal)
            titleButton.frame = CGRect(x:btnX, y: 0, width:btnW, height:btnH)
            
            titleButton.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
            titleButtons.append(titleButton)
            titleScrollView.addSubview(titleButton)
            
            if i==0 {
                titleBtnClick(btn: titleButton)
                titleButton.titleLabel?.sizeToFit()
                titleScrollView.addSubview(lineView)
                lineView.y = titleScrollView.height - 3
                lineView.width = (titleButton.titleLabel?.width)!/3
                lineView.centerX = titleButton.centerX
                cenX = Int(lineView.centerX)
                lineView.backgroundColor = titleButton.titleColor(for: .normal)?.withAlphaComponent(0.7)
            }
            
        }
        titleScrollView.contentSize = CGSize(width: CGFloat(count)*btnW, height: 0)
        contentScrollView.contentSize = CGSize(width: CGFloat(count)*SCREEN_WIDTH, height: 0)
    }
}

// MARK: - titleBtnClick
extension PageMenu {
    @objc fileprivate func titleBtnClick(btn:UIButton) {
        if selectedBtn == btn{
            NotificationCenter.default.post(name: NSNotification.Name.init(""), object: nil)
        }
        let index = btn.tag
        selButton(button: btn)
        contentScrollView.setContentOffset(CGPoint(x: CGFloat(index)*SCREEN_WIDTH, y: 0), animated: false)
        UIView.animate(withDuration: 0.1) {
            self.lineView.centerX = btn.centerX
            
        }
        setUpView(index: index)
        
        
    }
    /// - 选中标题
    private func selButton(button:UIButton) {
        
        selectedBtn.transform = CGAffineTransform.identity
        selectedBtn.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(selectedColor, for: .normal)
        setupTitleCenter(btn: button)
        button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        selectedBtn = button
    }
    /// - 标题居中
    private func setupTitleCenter(btn:UIButton) {
        
        if parantVC?.childViewControllers.count ?? 0 <= 4 { return }
        var offsetX : CGFloat = btn.centerX - SCREEN_WIDTH*0.5
        if offsetX < 0 { offsetX = 0 }
        
        let maxOffsetX : CGFloat = titleScrollView.contentSize.width - SCREEN_WIDTH
        if offsetX > maxOffsetX { offsetX = maxOffsetX }
        
        titleScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
        
    }
    
}
extension PageMenu {
    func setUpView(index:Int) {
        
        let childVc = parantVC?.childViewControllers[index]
        if childVc?.isViewLoaded == true {return}
        let childVcView = childVc?.view
        childVcView?.frame = CGRect(x: CGFloat(index)*SCREEN_WIDTH, y: 0, width: contentScrollView.width, height: contentScrollView.height)
        contentScrollView.addSubview(childVcView!)
    }
}

extension PageMenu:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let i = Int(scrollView.contentOffset.x/SCREEN_WIDTH)
        let titleBtn :UIButton = titleButtons[i]
        
        selButton(button: titleBtn)
        setUpView(index: i)
        
        UIView.animate(withDuration: 0.1) {
            self.lineView.centerX = titleBtn.centerX
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let leftI : NSInteger = NSInteger(scrollView.contentOffset.x/SCREEN_WIDTH)
        let rightI : NSInteger = leftI + 1
        
        let leftBtn = titleButtons[leftI]
        var rightBtn = UIButton()
        let count = titleButtons.count
        if rightI<count {
            rightBtn = titleButtons[rightI]
        }
        var scaleR:CGFloat = scrollView.contentOffset.x/SCREEN_WIDTH
        //you边缩放比例
        scaleR -= CGFloat(leftI)
        // 左边缩放比例
        let scaleL = 1-scaleR
        leftBtn.transform = CGAffineTransform.init(scaleX: scaleL*0.2+1, y: scaleL*0.2+1)
        rightBtn.transform = CGAffineTransform.init(scaleX: scaleR*0.2+1, y: scaleR*0.2+1)
        
       
    }
}
