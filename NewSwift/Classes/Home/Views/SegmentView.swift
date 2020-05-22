//
//  SegmentView.swift
//  NewSwift
//
//  Created by gail on 2017/12/29.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

class SegmentView: UIView {
  
    lazy var selectedBtn:UIButton = UIButton(type: .custom)
    lazy var titleButtons:[UIButton] = [UIButton]()
    lazy var titleScrollView:UIScrollView = {
        let titleScr = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.width, height: 40))
        titleScr.showsHorizontalScrollIndicator = false
        titleScr.bounces = false
        
        return titleScr
    }()
    lazy var contentScrollView:UIScrollView = {
        let y = titleScrollView.frame.maxY
        let contentScrollView = UIScrollView()
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        return contentScrollView
    }()
    
    lazy var lineView = { () ->  UIView in
        var lineView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/CGFloat(titleArray.count), height: 1.8))

        return lineView
    }()
    
    lazy var titleArray:[String] = [String]()
    lazy var controllors:[UIViewController] = [UIViewController]()
     var parentVC : UIViewController = UIViewController()
    
     init(frame: CGRect, controllers:[UIViewController], titleArray:[String],parentC:UIViewController){
        
        super.init(frame: frame)
        
        self.controllors = controllers
        self.titleArray = titleArray
        parentVC = parentC
       
        
        self.addSubview(titleScrollView)
        
        self.addSubview(contentScrollView)
        
         setupAllTitle()
        
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleScrollView.frame = CGRect(x: 0, y: 0, width: self.width, height: 40)
        let y = titleScrollView.frame.maxY
        contentScrollView.frame = CGRect(x: 0, y: y, width: SCREEN_WIDTH, height:self.height-y-tabBarHeight)
        self.lineView.y = titleScrollView.height - 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - 创建title
extension SegmentView{
    
    fileprivate func setupAllTitle(){
        
        let count = controllors.count
        let btnW = count>4 ? 100 : self.width/CGFloat(count)
        let btnH = titleScrollView.height
        var btnX:CGFloat = 0
        for i in 0..<count {
            let titleButton = UIButton(type: .custom)
            titleButton.tag = i
            titleButton.setTitle(titleArray[i], for: .normal)
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btnX = CGFloat(i) * btnW
            titleButton.setTitleColor(UIColor.gray.withAlphaComponent(0.8), for: .normal)
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
                lineView.backgroundColor = titleButton.titleColor(for: .normal)?.withAlphaComponent(0.7)
            }
        }
        titleScrollView.contentSize = CGSize(width: CGFloat(count)*btnW, height: 0)
        contentScrollView.contentSize = CGSize(width: CGFloat(count)*SCREEN_WIDTH, height: 0)
    }
}

// MARK: - titleBtnClick
extension SegmentView {
    @objc fileprivate func titleBtnClick(btn:UIButton) {
        if selectedBtn == btn{
            NotificationCenter.default.post(name: NSNotification.Name.init("repeatClickTitle"), object: nil)
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
        selectedBtn.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        setupTitleCenter(btn: button)
        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        selectedBtn = button
    }
    /// - 标题居中
    private func setupTitleCenter(btn:UIButton) {
        
        if controllors.count <= 4 { return }
        var offsetX : CGFloat = btn.centerX - SCREEN_WIDTH*0.5
        if offsetX < 0 { offsetX = 0 }
        
        let maxOffsetX : CGFloat = titleScrollView.contentSize.width - SCREEN_WIDTH
        if offsetX > maxOffsetX { offsetX = maxOffsetX }
        
        titleScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    
    }
    
}
extension SegmentView {
    func setUpView(index:Int) {
        
        let childVc = controllors[index]
        if childVc.isViewLoaded == true {return}
        let childVcView = childVc.view
        childVcView?.frame = CGRect(x: CGFloat(index)*SCREEN_WIDTH, y: 0, width: contentScrollView.width, height: contentScrollView.height)
        contentScrollView.addSubview(childVcView!)
    }
}

extension SegmentView:UIScrollViewDelegate {
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
        leftBtn.transform = CGAffineTransform.init(scaleX: scaleL*0.3+1, y: scaleL*0.3+1)
        rightBtn.transform = CGAffineTransform.init(scaleX: scaleR*0.3+1, y: scaleR*0.3+1)
    }
}
extension SegmentView {
    @objc fileprivate func ToTopClick() {
        
        self.contentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
