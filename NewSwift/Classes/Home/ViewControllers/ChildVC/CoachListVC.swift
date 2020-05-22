//
//  CoachListVC.swift
//  NewSwift
//
//  Created by gail on 2017/12/12.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit

class CoachListVC: BaseViewController {
    var refreshCount = 1
    var page:Page?
    lazy var coachList = [CoachModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        tableView.register(UINib(nibName: "CoachListCell", bundle: nil), forCellReuseIdentifier: "CoachListCell")
        
        tableView.tableHeaderView = searchBar
        searchBar.tag = 101
        
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

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.coachList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachListCell", for: indexPath) as! CoachListCell
        cell.model = self.coachList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = coachList[indexPath.row]
        let vc = DetailVC()
        vc.coachModel = model
        vc.detailType = .coach
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension CoachListVC {
    func getData(firstGet:Bool) {
        
        HomeNetTool.getCoachListData(currentPage: refreshCount, cityNumber: nil, searchText: "" ,Success: {[weak self] (page, array) in
            
            if firstGet == true {
                
                self?.coachList = array
            }else{
                self?.coachList.append(contentsOf: array)
            }
            self?.page = page
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.isFinishRefresh = true
        }) {[weak self] (error) in
            self?.tableView.mj_footer.isHidden = self?.coachList.count == 0
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.isFinishRefresh = true
        }
    }
    
    fileprivate func setUpHeaderReFresh() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.refreshCount = 1
            self?.getData(firstGet: true)
            
        })
        
        tableView.mj_header.beginRefreshing()
    }
        
    fileprivate func setUpFootReFresh() {
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            
            if self?.coachList.count != 0 {
                self?.refreshCount += 1
            }
            
            if self?.page?.currentPage==self?.page?.totalPage {
                
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                
            }else{
                self?.getData(firstGet: false)
            }
        })
    }
}
