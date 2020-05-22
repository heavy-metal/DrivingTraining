//
//  InquireAboutCar.swift
//  NewSwift
//
//  Created by gail on 2019/7/8.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class InquireAboutCar: UITableViewController {
    
    var page:Page?
    var currentPage = 1
    var loginModel:LoginModel?
    lazy var array = [SearchCarOrderModel]()
    
    lazy var searchController:UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = true
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
        searchBar.placeholder = "搜索"
        searchBar.sizeToFit()
        searchBar.delegate = self
        let searchField = searchBar.value(forKey: "searchField") as! UITextField
        searchField.tintColor = GlobalColor
        searchField.font = UIFont.systemFont(ofSize: 15)
        let searchFieldBackgroudView = searchField.subviews.first
        searchFieldBackgroudView?.backgroundColor = UIColor.white
        searchFieldBackgroudView?.layer.cornerRadius = 15
        searchFieldBackgroudView?.layer.masksToBounds = true
        if #available(iOS 13.0, *){
            
            let searchTextField = searchBar.searchTextField
            searchTextField.tintColor = GlobalColor
            searchTextField.backgroundColor = UIColor.white
            searchTextField.layer.cornerRadius = 15
            searchTextField.layer.masksToBounds = true
            searchController.hidesNavigationBarDuringPresentation = false
            
        }else{
            searchBar.setValue("取消", forKey: "_cancelButtonText")
        }
        
        
        searchBar.barTintColor = UIColor.white
        searchBar.tintColor = UIColor.white

        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        setUpHeaderReFresh()
        setUpFootReFresh()
        navigationItem.title = "预约订单"
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "InquireAboutCarCell", bundle: nil), forCellReuseIdentifier: "InquireAboutCarCell")
        
     
        navigationItem.titleView = searchController.searchBar
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("postOrder"), object: nil, queue: nil) {[weak self] (_) in
            self?.currentPage = 1
            self?.array.removeAll()
            self?.getHomeData(firstGet: true)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
}

extension InquireAboutCar  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InquireAboutCarCell", for: indexPath) as! InquireAboutCarCell
        cell.model = self.array[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.array[indexPath.row]
        let vc = InquireDetailAboutCarVC()
        vc.model = model
        vc.loginModel = self.loginModel
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
}

extension InquireAboutCar {
    
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
extension InquireAboutCar {
    
    func getHomeData (firstGet:Bool) {
        HomeNetTool.GetSearchCarOrderData(currentPage: currentPage, UserId: loginModel?.userId ?? "", stuId: loginModel?.userId ?? "", Success: {[weak self] (page, array) in
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
        }) {[weak self] (error) in
            self?.tableView.mj_footer.isHidden = self?.array.count == 0
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }
    }

}
extension InquireAboutCar:UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
