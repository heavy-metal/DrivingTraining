//
//  CommonPageViewController.swift
//  NewSwift
//
//  Created by gail on 2019/7/30.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class CommonPageViewController: UIViewController {

    lazy var config:XLPageViewControllerConfig = {
        var config = XLPageViewControllerConfig.default()
        config.titleViewStyle = .segmented
        config.showTitleInNavigationBar = true
        config.separatorLineHidden = true
        config.titleViewInset = UIEdgeInsetsMake(5, 0, 5, 45)
        config.segmentedTintColor = UIColor.white
        return config
    }()
    
    lazy var pageViewController = XLPageViewController(config: config)
    lazy var titles = [String]()
    lazy var vcArray = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        pageViewController.view.frame = view.bounds
        pageViewController.delegate = self
        pageViewController.dataSource = self
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
    }
 
}

extension CommonPageViewController:XLPageViewControllerDelegate,XLPageViewControllerDataSrouce {
    
    func pageViewControllerNumberOfPage() -> Int {
        return titles.count
    }
    
    
    func pageViewController(_ pageViewController: XLPageViewController, viewControllerFor index: Int) -> UIViewController {
        return vcArray[index]
    }
    
    func pageViewController(_ pageViewController: XLPageViewController, titleFor index: Int) -> String {
        return titles[index]
    }
    
    func pageViewController(_ pageViewController: XLPageViewController, didSelectedAt index: Int) {
        
    }
    
    
}
