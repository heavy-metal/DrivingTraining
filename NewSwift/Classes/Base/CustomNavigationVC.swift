//
//  CustomNavigationVC.swift
//  SwiftNewProject
//
//  Created by gail on 2017/12/8.
//  Copyright © 2017年 XNX. All rights reserved.
//

import UIKit

class CustomNavigationVC: UINavigationController {
    lazy var tipLabel : UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18)]
        navigationBar.barTintColor = GlobalColor
        navigationBar.tintColor = UIColor.white
        
        CustomGestureRecognizer()
}
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            if !(viewController is MineViewController) {
                viewController.hidesBottomBarWhenPushed = true
            }
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(directionType:.left ,imageName: "btn_navBack", target: self, action: #selector(BackBtnClick))
        }
        
        /// 水珠翻页效果
        let animation = CATransition()
        animation.type = "rippleEffect"
        animation.subtype = "fromBottom"
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        view.layer.add(animation, forKey: nil)
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
    @objc func BackBtnClick() {
        
        if self.viewControllers.last is MineViewController {
            
            signOut()
            
        }else if self.viewControllers.last is InquireAboutCar{
            
            for vc in self.viewControllers {
                if vc is homeViewController || vc is MineViewController {
                    popToViewController(vc, animated: true)
                }
            }
            
        }else {
            popViewController(animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
   
}
// MARK: - 全屏手势
extension CustomNavigationVC {
    
    fileprivate func CustomGestureRecognizer() {
        
        let target = interactivePopGestureRecognizer?.delegate
        
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: target!, action: Selector(("handleNavigationTransition:")))
        
        pan.delegate = self as UIGestureRecognizerDelegate
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.view.addGestureRecognizer(pan)
        
        
    }
}

// MARK: - 是否触发手势
extension CustomNavigationVC:UIGestureRecognizerDelegate{

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (viewControllers.last?.isKind(of: MineViewController.self))!{
            return false
        }
        return viewControllers.count > 1
    }
   
}

// MARK: - 退出登录提示
extension CustomNavigationVC {
    func signOut () {
        let alert = UIAlertController(title: "退出登录", message: "\n您确定要退出当前帐号?\n", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
            ZJKeyChain.delete("Login")
            UserDefaults.standard.removeObject(forKey: "StudentAlreadyRegistered")
            self?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        okAction.setValue(UIColor.darkGray, forKey: "_titleTextColor")
        cancelAction.setValue(UIColor.darkGray, forKey: "_titleTextColor")
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
