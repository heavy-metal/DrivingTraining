//
//  HistorySuggestVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/30.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class HistorySuggestVC: UIViewController {

    var loginModel:LoginModel?
    var page:Page?
    var currentPage = 1
    lazy var array = [SuggestModel]()
    
    lazy var tableView:UITableView = {
        
        var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "SuggestListCell", bundle: nil), forCellReuseIdentifier: "SuggestListCell")
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.backgroundColor = grayBackColor
        
        setUpHeaderReFresh()
        setUpFootReFresh()
    }
}
extension HistorySuggestVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestListCell", for: indexPath) as! SuggestListCell
        let model = array[indexPath.row]
        cell.titleLabel.text = model.Title
        cell.timeLabel.text = model.FeedbackTime
        cell.stateBtn.setTitle(model.opState, for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ReplySuggestVC()
        let model = array[indexPath.row]
        vc.suggestModel = model
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension HistorySuggestVC {
    
    func getHomeData(firstGet: Bool) {
        HomeNetTool.getSuggestListData(UserId: loginModel?.userId ?? "", currentPage: currentPage, Success: {[weak self] (page, array) in
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
extension HistorySuggestVC {
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
