//
//  BaseViewController.swift
//  SwiftNewProject
//
//  Created by gail on 2017/12/8.
//  Copyright © 2017年 XNX. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    typealias HeaderRefresh = ()->()
    
//    var scrollView = UIScrollView()
    var canScroll : Bool = false
    var isFinishRefresh : Bool = false//是否已完成下拉刷新
//    var searchText = ""
//    var searchTag:NSInteger? //搜索了什么类型
    lazy var searchBar : UISearchBar = {
        
        var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        searchBar.placeholder = "搜索"
        searchBar.barTintColor = grayBackColor
        var searchField = searchBar.value(forKey: "searchField") as? UITextField
        searchField?.font = UIFont.systemFont(ofSize: 13)
        searchField?.backgroundColor = UIColor.white
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        (searchBar.subviews[0].subviews)[0].removeFromSuperview()
        searchBar.delegate = self
        return searchBar
    }()
    var searchVC:PYSearchViewController?
    
    lazy var districtNameArray = [String]()
    lazy var districtIndexArray = [NSInteger]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("goTop"), object: nil, queue: nil) { (_) in
            self.canScroll = true
        
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("leaveTop"), object: nil, queue: nil) { (_) in
            
            self.canScroll = false
        }
        //点击了首页的状态栏顶部
        NotificationCenter.default.addObserver(forName: NSNotification.Name("HomeClicktoTop"), object: nil, queue: nil) { (info) in
            let tab = info.object as! TouchTableView
            self.canScroll = false
            self.tableView.contentOffset = CGPoint(x: 0, y: 0)
            tab.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
//        //切换城市
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("changeCity"), object: nil, queue: nil) {[weak self] (_) in
//            self?.getDistrict()//获取地区信息
//        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BaseViewController : UIGestureRecognizerDelegate {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isFinishRefresh == false {return} //是否已完成下拉刷新
        
        let offsetY = scrollView.contentOffset.y
        
        if canScroll==false {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        if offsetY < 0 {
            NotificationCenter.default.post(name: NSNotification.Name.init("leaveTop"), object: nil)
        }
    }
}
extension BaseViewController {
    
    func repeatClickTitle(tableView:UITableView) {
        //重复点击菜单栏按钮
        NotificationCenter.default.addObserver(forName: NSNotification.Name("repeatClickTitle"), object: nil, queue: nil) { (_) in
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            self.isFinishRefresh = false
            tableView.mj_header.beginRefreshing()
        }

    }
    
   //获取地区信息
    func getDistrict () {

        HomeNetTool.getDistrict { (nameArray, indexArray) in
            self.districtNameArray = nameArray
            self.districtIndexArray = indexArray
        }
    }
    
}

extension BaseViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        view.endEditing(true)
        let searchTag = searchBar.tag
        let searchViewController = PYSearchViewController(hotSearches: districtNameArray, searchBarPlaceholder: "搜索") {[weak self] (vc, searchBar, searchText) in
            
            let searchResultVC = SearchResultVC()
            searchResultVC.searhType = SearchType(rawValue: searchTag)
            if (self?.districtNameArray.contains(searchText ?? ""))! == true {
                guard let inDex = self?.districtNameArray.index(of: searchText ?? "") else { return }
                searchResultVC.cityNumber = self?.districtIndexArray[inDex]
                searchResultVC.searchtext = ""
            }else {
                searchResultVC.searchtext = searchText ?? ""
            }
            vc?.navigationController?.pushViewController(searchResultVC, animated: true)
            
        }
        searchViewController?.hotSearchStyle = .rankTag
        searchViewController?.searchHistoryStyle = .borderTag
        searchViewController?.searchBar.text = ""
        self.searchVC = searchViewController
        
        let nav = CustomNavigationVC(rootViewController: searchViewController!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
        return false
        
    }

}
