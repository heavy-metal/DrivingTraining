//
//  PublicListController.swift
//  NewSwift
//
//  Created by gail on 2019/6/12.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class PublicListController: UITableViewController {

    var getListIndex : NSInteger = 0
    var currentPage = 1
    var page:Page?
    lazy var publicArray = [PublicModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        setUpHeaderReFresh()
        setUpFootReFresh()
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "public_CELL")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return publicArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "public_CELL", for: indexPath) as! HomeTableViewCell
        
        cell.publicModel = publicArray[indexPath.row]
        return cell
    }

    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let publicModel = publicArray[indexPath.row]
        let web = CZJWebViewController(urlString: publicModel.FileUrl)
        self.navigationController?.pushViewController(web, animated: true)
    }

}
extension PublicListController {
    func getHomeData(firstGet:Bool){
        HomeNetTool.getPubliclistData(currentPage: currentPage, getListIndex: getListIndex, Success: {[weak self] (page, array) in
            if firstGet == true {
                
                self?.publicArray = array
                
            }else{
                self?.publicArray.append(contentsOf: array)
            }
            
            self?.page = page
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.isHidden = page.totalPage == 1 || self?.publicArray.count == 0
            self?.tableView.mj_footer.endRefreshing()
        }) {[weak self] (error) in
            self?.tableView.mj_footer.isHidden = self?.publicArray.count == 0
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }
    }
    fileprivate func setUpHeaderReFresh() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.currentPage = 1
            self?.getHomeData(firstGet: true)
            
        })
        
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setUpFootReFresh() {
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            
            if self?.publicArray.count != 0 {
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
