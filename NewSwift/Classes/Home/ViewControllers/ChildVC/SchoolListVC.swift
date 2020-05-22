//
//  SchoolListVC.swift
//  NewSwift
//
//  Created by gail on 2017/12/12.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

class SchoolListVC: BaseViewController {
    var refreshCount = 1
    var page:Page?
    lazy var schoolList = [SchoolModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = searchBar
        searchBar.tag = 100
        view.backgroundColor = UIColor.groupTableViewBackground
        
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "SCHOOL_CELL")
        
        getDistrict()//获取地区信息
        
        setUpHeaderReFresh()
        
        setUpFootReFresh()
        
        //重复点击菜单栏按钮
        repeatClickTitle(tableView: tableView)
        
        //切换城市
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("changeCity"), object: nil, queue: nil) {[weak self] (_) in
            if self?.isViewLoaded == true {
               
                self?.getDistrict()
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                self?.isFinishRefresh = false
                self?.tableView.mj_header.beginRefreshing()
            }
        }
    }
   
}

extension SchoolListVC {
    
    func getHomeData(firstGet:Bool){
        
        HomeNetTool.getSchoollistData(currentPage:refreshCount, cityNumber: nil, searchText: "" ,Success: {[weak self] (page,array) in
            
            if firstGet == true {
               
                self?.schoolList = array
                
            }else{
                self?.schoolList.append(contentsOf: array)
            }
            
            self?.page = page
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.isFinishRefresh = true
        }) {[weak self] (error) in
            self?.tableView.mj_footer.isHidden = self?.schoolList.count == 0
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.isFinishRefresh = true
        }
    }
    
}
extension SchoolListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SCHOOL_CELL", for: indexPath) as! HomeTableViewCell
        cell.applyBtn.tag = 300
        cell.schoolModel = schoolList[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = schoolList[indexPath.row]
        let vc = DetailVC()
        vc.schoolModel = model
        vc.detailType = .school
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension SchoolListVC {
    
    fileprivate func setUpHeaderReFresh() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.refreshCount = 1
            self?.getHomeData(firstGet: true)
            
        })
    
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setUpFootReFresh() {
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            
            if self?.schoolList.count != 0 {
                self?.refreshCount += 1
            }
            
            if self?.page?.currentPage==self?.page?.totalPage {

                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                
            }else{
               self?.getHomeData(firstGet: false)
            }
        })
    }
   
}


