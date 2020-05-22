//
//  DetailBaseVC.swift
//  NewSwift
//
//  Created by gail on 2019/5/29.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class DetailBaseVC: UITableViewController {

    var canScroll : Bool = false
    var isFinishRefresh : Bool = false//是否已完成下拉刷新
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("Detail_goTop"), object: nil, queue: nil) { (_) in
            self.canScroll = true
            
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("Detail_leaveTop"), object: nil, queue: nil) { (_) in
            
            self.canScroll = false
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   

}
extension DetailBaseVC : UIGestureRecognizerDelegate {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isFinishRefresh == false {return} //是否已完成下拉刷新
        
        let offsetY = scrollView.contentOffset.y
        
        if canScroll==false {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        if offsetY < 0 {
            NotificationCenter.default.post(name: NSNotification.Name.init("Detail_leaveTop"), object: nil)
            
        }
    }
}
