//
//  FindStuyTimeViewController.swift
//  NewSwift
//
//  Created by gail on 2019/7/1.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class FindStuyTimeViewController: ZJPageMenu {
    
    lazy var titleArray = ["科目一","科目二","科目三","科目四"]
    
    lazy var controllors = [UIViewController]()
    
    var userId = ""
    
    var stuId = ""
    
    lazy var segmentView:SegmentView = {
        var segmentView = SegmentView(frame: CGRect(x: 0, y: NavBarHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NavBarHeight), controllers: controllors, titleArray: titleArray, parentC: self)
        return segmentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVC()
        
//        view.addSubview(segmentView)
       
        view.backgroundColor = UIColor.white
        
    }
  
}
extension FindStuyTimeViewController {
    fileprivate func addChildVC(){
        for i in 0..<titleArray.count {
            let vc = StudentFindTimeVC()
            vc.subjectIndex = i+1
            vc.title = titleArray[i]
            vc.userId = userId
            vc.stuId = stuId
            addChildViewController(vc)
            controllors.append(vc)
        }
    }
}
