//
//  ZJPageMenu.swift
//  NewSwift
//
//  Created by gail on 2017/12/11.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

class ZJPageMenu: UIViewController {
    lazy var selectedBtn:UIButton = UIButton(type: .custom)
    var isInitialize:Bool = false
    lazy var titleButtons:[UIButton] = [UIButton]()
    lazy var titleScrollView:UIScrollView = {
        let titleScr = UIScrollView(frame: CGRect(x: 0, y: NavBarHeight, width: view.width, height: 40) )
        titleScr.showsHorizontalScrollIndicator = false
        titleScr.bounces = false
        return titleScr
    }()
    
    lazy var contentScrollView:UIScrollView = {
        let y = titleScrollView.frame.maxY
        let contentScrollView = UIScrollView(frame: CGRect(x: 0, y: y, width: SCREEN_WIDTH, height: view.height-y))
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        return contentScrollView
    }()
    lazy var lineView = { () ->  UIView in
        var lineView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/CGFloat(self.childViewControllers.count), height: 2))
        
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;

        view.addSubview(titleScrollView)
        
        view.addSubview(contentScrollView)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isInitialize == false {
            setupAllTitle()
            isInitialize = true
        }
    }
}
// MARK: - 创建title
extension ZJPageMenu{
    
    fileprivate func setupAllTitle(){
    
        let count = childViewControllers.count
        let btnW = count>4 ? 100 : view.width/CGFloat(count)
        let btnH = titleScrollView.height
        var btnX:CGFloat = 0
        for i in 0..<count {
            let titleButton = UIButton(type: .custom)
            titleButton.tag = i
            let vc = childViewControllers[i]
            titleButton.setTitle(vc.title, for: .normal)
            btnX = CGFloat(i) * btnW
            titleButton.setTitleColor(UIColor.gray, for: .normal)
            titleButton.frame = CGRect(x:btnX, y: 0, width:btnW, height:btnH)
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            titleButton.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
            titleButtons.append(titleButton)
            
            if i==0 {
                titleBtnClick(btn: titleButton)
                titleButton.titleLabel?.sizeToFit()
                titleScrollView.addSubview(lineView)
                lineView.y = titleScrollView.height - 3
                lineView.width = (titleButton.titleLabel?.width)!/4
                lineView.centerX = titleButton.centerX
                lineView.backgroundColor = titleButton.titleColor(for: .normal)?.withAlphaComponent(0.7)
            }
            titleScrollView.addSubview(titleButton)
        }
        titleScrollView.contentSize = CGSize(width: CGFloat(count)*btnW, height: 0)
        contentScrollView.contentSize = CGSize(width: CGFloat(count)*SCREEN_WIDTH, height: 0)
    }
}

// MARK: - titleBtnClick
extension ZJPageMenu {
    @objc fileprivate func titleBtnClick(btn:UIButton) {
        let index = btn.tag
        selButton(button: btn)
        setupOneViewController(i: index)
        UIView.animate(withDuration: 0.1) {
            self.lineView.centerX = btn.centerX
        }
        contentScrollView.setContentOffset(CGPoint(x: CGFloat(index)*SCREEN_WIDTH, y: 0), animated: false)
        
    }
    /// - 选中标题
    private func selButton(button:UIButton) {
      
            selectedBtn.transform = CGAffineTransform.identity
            selectedBtn.setTitleColor(UIColor.gray, for: .normal)
            button.setTitleColor(GlobalColor, for: .normal)
            setupTitleCenter(btn: button)
            button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            selectedBtn = button
    }
    /// - 标题居中
    private func setupTitleCenter(btn:UIButton) {
        
        if childViewControllers.count <= 4 { return }
        var offsetX : CGFloat = btn.centerX - SCREEN_WIDTH*0.5
        if offsetX < 0 { offsetX = 0 }
        
        let maxOffsetX : CGFloat = titleScrollView.contentSize.width - SCREEN_WIDTH
        if offsetX > maxOffsetX { offsetX = maxOffsetX }
        
        titleScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }

    /// 添加一个子控制器的View
    private func setupOneViewController(i:NSInteger) {
        let vc = childViewControllers[i]
        if vc.isViewLoaded==true { return }
        let x : CGFloat = CGFloat(i) * SCREEN_WIDTH
        vc.view.frame = CGRect(x: x, y: 0, width: contentScrollView.width, height: contentScrollView.height)
        contentScrollView.addSubview(vc.view)
    }
}
extension ZJPageMenu:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let i = Int(scrollView.contentOffset.x/SCREEN_WIDTH)
        let titleBtn :UIButton = titleButtons[i]
        
        selButton(button: titleBtn)
        setupOneViewController(i: i)
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
