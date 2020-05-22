//
//  FindBookCarVC.swift
//  NewSwift
//
//  Created by gail on 2019/8/14.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class FindBookCarVC: UITableViewController {

    lazy var titleBtn:UIButton = {
        var titleBtn = UIButton(type: .custom)
        titleBtn.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        titleBtn.setTitle(nowTime(), for: .normal)
        titleBtn.setTitleColor(UIColor.white, for: .normal)
        titleBtn.setImage(UIImage(named:"jiantou"), for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        return titleBtn
    }()
    var page:Page?
    var currentPage = 1
    lazy var array = [SearchCarOrderModel]()
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = titleBtn
        tableView.register(UINib(nibName: "InquireDetailCarOrderCell", bundle: nil), forCellReuseIdentifier: "InquireDetailCarOrderCell")
        tableView.separatorStyle = .none
        view.backgroundColor = grayBackColor
        
        setUpHeaderReFresh()
        setUpFootReFresh()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InquireDetailCarOrderCell", for: indexPath) as! InquireDetailCarOrderCell
        cell.model = array[indexPath.row]
        cell.cancelOrderBtn.isHidden = true
        let lineView = UIView(frame: CGRect(x: 0, y: 280-5, width: SCREEN_WIDTH, height: 5))
        lineView.backgroundColor = grayBackColor
        cell.addSubview(lineView)
        return cell
    }
    

  
}
extension FindBookCarVC {
    
    @objc func titleBtnClick() {
        BRDatePickerView.showDatePicker(withTitle: "选择时间", dateType: .date, defaultSelValue: nil, minDateStr: nil, maxDateStr: nil, isAutoSelect: false) {[weak self] (str) in
            self?.titleBtn.setTitle(str, for: .normal)
            if str != "" && str != nil {self?.setUpHeaderReFresh()}
        }
    }
    func nowTime() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let time = formatter.string(from: currentDate)
        return time
    }
    func getHomeData (firstGet:Bool) {
        HomeNetTool.SearchOrder(UserId: userId, currentPage: currentPage, Date: self.titleBtn.titleLabel?.text ?? "", Success: {[weak self] (page, array) in
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
