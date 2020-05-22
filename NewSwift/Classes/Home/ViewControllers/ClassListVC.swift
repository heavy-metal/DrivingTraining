

//
//  ClassListVC.swift
//  NewSwift
//
//  Created by gail on 2019/5/28.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class ClassListVC: DetailBaseVC {
    
    var insId = ""
    var page:Page?
    var currentPage = 1
    var coachName = ""
    lazy var array = [ClassModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        
        setUpHeaderReFresh()
        
        setUpFootReFresh()
        
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ClassInfoCell", bundle: nil), forCellReuseIdentifier: "ClassInfoCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return self.array.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassInfoCell", for: indexPath) as! ClassInfoCell
        cell.model = self.array[indexPath.row]
        cell.coachName = self.coachName
        if cell.insId == "" {cell.insId = self.insId}
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.array[indexPath.row]
        let webVC = CZJWebViewController(urlString: model.FileUrl)
        self.navigationController?.pushViewController(webVC, animated: true)
    }

}
extension ClassListVC {
    
    fileprivate func getHomeData(firstGet: Bool){
        HomeNetTool.GetClassList(currentPage: currentPage, insId: insId, Success: {[weak self] (page, array) in
            self?.page = page
            if firstGet == true {
                
                self?.array = array
                
            }else{
                self?.array.append(contentsOf: array)
            }
            self?.tableView.mj_footer.isHidden = page.totalPage == 1 || self?.array.count == 0
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.isFinishRefresh = true
        }) { [weak self] (error) in
            self?.tableView.mj_footer.isHidden = self?.array.count == 0
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.isFinishRefresh = true
        }
    }
}
extension ClassListVC {
    
    fileprivate func setUpHeaderReFresh() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.currentPage = 1
            self?.getHomeData(firstGet: true)
        })
        
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setUpFootReFresh() {
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            
            if self?.array.count != 0 {
                self?.currentPage += 1
            }
            
            if self?.page?.currentPage==self?.page?.totalPage {
                
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                
            }else{
                self?.getHomeData(firstGet: false)
            }
        })
        
    }
    
}
