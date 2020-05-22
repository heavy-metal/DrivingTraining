//
//  homeViewController.swift
//  SwiftNewProject
//
//  Created by gail on 2017/12/8.
//  Copyright © 2017年 XNX. All rights reserved.
//

import UIKit

class homeViewController: UIViewController {
    
    lazy var tableView:TouchTableView = {
        
        var tableView = TouchTableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)

        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(rowsCell.self, forCellReuseIdentifier: "rowsCell")
        
        return tableView
    }()
     lazy var headerView: HeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headViewHeight))
    
    lazy var controllors:[UIViewController] = [SchoolListVC(),CoachListVC(),RegistVC()]
    lazy var titleArray:[String] = ["驾校","教练","报名点"]
    
    lazy var segmentView = { () -> SegmentView in
       var segmentView = SegmentView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NavBarHeight), controllers: controllors, titleArray: titleArray, parentC: self)
        return segmentView
    }()
    
    lazy var cityBtn:UIButton = {
        var cityBtn = UIButton(imageName: "jiantou")
        cityBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        cityBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cityBtn.addTarget(self, action: #selector(changeCityClick), for: .touchUpInside)
        return cityBtn
    }()
    
    var isTopIsCanNotMoveTabView : Bool?
    var isTopIsCanNotMoveTabViewPre : Bool?
    var canScroll : Bool?
    
    var jktjUrl = ""
    var jklcUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefault = UserDefaults.standard
        if userDefault.value(forKey: "CityName") == nil {
            userDefault.set("清远市", forKey: "CityName")
            cityBtn.setTitle("清远市", for: .normal)
            userDefault.synchronize()
        }else {
            let str = userDefault.value(forKey: "CityName") as? String
            cityBtn.setTitle(str, for: .normal)
            IPADRESS = str == "清远市" ? "http://125.89.196.8:2059" : "http://125.89.196.8:2069"
        }
        
        addChildVC()
        setUpUI()
        getHomeData()
        
        VersionManager.share.updateAppVersion()//更新版本
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("leaveTop"), object: nil, queue: nil) { (_) in
            self.canScroll = true
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension homeViewController {
    
    fileprivate func setUpUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        
        self.navigationItem.title = "星云轻驾培"

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cityBtn)
        
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            
            self?.getHomeData()
            NotificationCenter.default.post(name: NSNotification.Name.init("headerRefresh"), object: nil)
        })
        
    }
    fileprivate func getHomeData() {
        
        HomeNetTool.getHomeData(Success: { (result) in
            self.headerView.headerArray = result.imgArray
            self.tableView.mj_header.endRefreshing()
            self.jklcUrl = result.JklcUrl ?? ""
            self.jktjUrl = result.JktjUrl ?? ""
            self.tableView.reloadData()
            
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
        }
    }
    
}
extension homeViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        var cell:UITableViewCell?
    
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rowsCell", for: indexPath) as! rowsCell
            cell.jktjUrl = self.jktjUrl
            cell.jklcUrl = self.jklcUrl
            cell.selectionStyle = .none
            return cell

        default:
    
            var cell = tableView.dequeueReusableCell(withIdentifier: "homeCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "homeCell")
            }
            cell?.addSubview(segmentView)
            cell?.selectionStyle = .none
            return cell!
        }
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return COLLECTVIEW_HEIGHT
        case 1:
            return SCREEN_HEIGHT-NavBarHeight
        default:
            return 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y

        let tabOffsetY = tableView.rect(forSection: 0).minY - NavBarHeight + COLLECTVIEW_HEIGHT
        isTopIsCanNotMoveTabViewPre = isTopIsCanNotMoveTabView
        if offsetY >= tabOffsetY {
           scrollView.contentOffset = CGPoint(x: 0, y: tabOffsetY)
            isTopIsCanNotMoveTabView = true;
        }else{
            isTopIsCanNotMoveTabView = false;
        }
        if isTopIsCanNotMoveTabView != isTopIsCanNotMoveTabViewPre {
            if isTopIsCanNotMoveTabViewPre == false,isTopIsCanNotMoveTabView == true {
        
                NotificationCenter.default.post(name: NSNotification.Name.init("goTop"), object: nil)
                canScroll = false
            }
            if isTopIsCanNotMoveTabViewPre == true,isTopIsCanNotMoveTabView == false {
                if canScroll == false {
                    scrollView.contentOffset = CGPoint(x: 0, y: tabOffsetY)
                }
            }
        }
    }
    fileprivate func addChildVC()  {
        
        for i in 0..<titleArray.count {
            let vc = controllors[i] 
            vc.title = titleArray[i]
            self.addChildViewController(vc)
        }
    }
}

// MARK: - HomeClicktoTop
extension homeViewController {
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.canScroll = false
    }
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if self.canScroll == false {
            self.canScroll = true
            
            NotificationCenter.default.post(name: NSNotification.Name.init("HomeClicktoTop"), object: tableView)
            
        }
        return true
    }
    
    
    @objc func changeCityClick() {

        BRStringPickerView.showStringPicker(withTitle: "请选择您切换的城市", dataSource: ["清远市","梅州市"], defaultSelValue: nil, isAutoSelect: false) {[weak self] (str) in
            let cityStr = str as? String
            self?.cityBtn.setTitle(cityStr, for: .normal)

            let userDefault = UserDefaults.standard
            userDefault.set(str, forKey: "CityName")
            userDefault.synchronize()
            
            IPADRESS = cityStr == "清远市" ? "http://125.89.196.8:2059" : "http://125.89.196.8:2069"
            if self?.canScroll == false {
                self?.canScroll = true
                NotificationCenter.default.post(name: NSNotification.Name.init("HomeClicktoTop"), object: self?.tableView ?? nil)
            }
            self?.tableView.mj_header.beginRefreshing()

            NotificationCenter.default.post(name: NSNotification.Name.init("changeCity"), object: nil)
            
            
        }
    }
    
 
}
