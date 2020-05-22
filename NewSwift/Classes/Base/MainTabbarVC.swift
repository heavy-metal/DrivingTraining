//
//  MainTabbarVC.swift
//  SwiftNewProject
//
//  Created by gail on 2017/12/8.
//  Copyright © 2017年 XNX. All rights reserved.
//
//#63bf84
import UIKit

class MainTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addAllChildsControllors()
        
//        let customTabBar = CustomTabBar()
//        self.setValue(customTabBar, forKey: "tabBar")
    }
}

extension MainTabbarVC {
    
   fileprivate func addAllChildsControllors() {
    
    addChildVC(childVC: homeViewController(), title:"首页", image:UIImage(imageLiteralResourceName:"tabbar_home.png"), selectedImage:UIImage(named: "tabbar_home_selected.png")! )
    
    
    addChildVC(childVC: LoginViewController(), title:"我的", image:UIImage(imageLiteralResourceName:"tabbar_mine.png"), selectedImage:UIImage(named: "tabbar_mine_selected.png")! )
    }
    
    private func addChildVC(childVC:UIViewController,title:String,image:UIImage,selectedImage:UIImage) {
        childVC.tabBarItem.title = title
        childVC.tabBarItem.image = image
        childVC.tabBarItem.selectedImage = selectedImage
        let navVC = CustomNavigationVC(rootViewController: childVC)
        addChildViewController(navVC)
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let index = self.tabBar.items?.index(of: item)
        if index == 1 {
            let ipStr = UserDefaults.standard.value(forKey: "REMBER_IP") as? String
            if ipStr != IPADRESS {
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "ChangeIP"), object: nil)
            }
        }
        
//        var tabbarbuttonArray = [AnyObject]()
//        for tabBarButton in self.tabBar.subviews {
//            if tabBarButton .isKind(of: NSClassFromString("UITabBarButton")!) {
//                tabbarbuttonArray.append(tabBarButton)
//            }
//        }
//        let animate = CABasicAnimation.init(keyPath: "transform.scale")
//        animate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        animate.duration = 0.2
//        animate.repeatCount = 1
//        animate.autoreverses = true
//        animate.fromValue = NSNumber(value: 0.7)
//        animate.toValue = NSNumber(value:1.3)
//        if #available(iOS 13.0, *) {
//            tabbarbuttonArray[index!].layer?.add(animate, forKey: nil)
//        } else {
//            // Fallback on earlier versions
//        }
    }
}
