//
//  ContentScrollView.swift
//  NewSwift
//
//  Created by gail on 2019/5/28.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class ContentScrollView: UIView {

    lazy var contentScrollView:UIScrollView = {
        
        let contentScrollView = CustomScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NavBarHeight-40))
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        return contentScrollView
    }()
    lazy var controllers = [UIViewController]()
    var isNavigaBar:Bool?
    
    init(frame: CGRect ,controllers:[UIViewController] ,isNavigaBar:Bool) {
        super.init(frame: frame)
        self.isNavigaBar = isNavigaBar
        self.controllers = controllers
        addSubview(contentScrollView)
        
        if isNavigaBar == true {
            contentScrollView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NavBarHeight)
        }
        
        contentScrollView.contentSize = CGSize(width: CGFloat(controllers.count)*SCREEN_WIDTH, height: 0)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "titleBtnClick"), object: nil, queue: nil) { (info) in
            let index = info.object as! NSInteger
            self.setupOneViewController(i: index)
            self.contentScrollView.setContentOffset(CGPoint(x: CGFloat(index)*SCREEN_WIDTH, y: 0), animated: false)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
}
extension ContentScrollView : UIScrollViewDelegate {
    
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let i = Int(scrollView.contentOffset.x/SCREEN_WIDTH)
       
         NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "scrollViewDidEnd"), object: i)
        
        setupOneViewController(i: i)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "scrollViewDidScroll1"), object: scrollView.contentOffset.x)
    }
    
    /// 添加一个子控制器的View
    private func setupOneViewController(i:NSInteger) {
        let vc = controllers[i]
        if vc.isViewLoaded==true { return }
        let x : CGFloat = CGFloat(i) * SCREEN_WIDTH
        vc.view.frame = CGRect(x: x, y: 0, width: contentScrollView.width, height: contentScrollView.height)
        contentScrollView.addSubview(vc.view)
    }
    
}
