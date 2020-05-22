//
//  CoachScheduleByDayVC.swift
//  NewSwift
//
//  Created by gail on 2019/8/20.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class CoachScheduleByDayVC: UITableViewController {
    
    var dateString = ""
    var userId = ""
    var coachId = ""
    var currentPage = 1
    var page:Page?
    var isFirst = true
    lazy var array = [ScheduleByDayModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        view.backgroundColor = grayBackColor
        tableView.register(UINib(nibName: "CoachScheduleByDayCell", bundle: nil), forCellReuseIdentifier: "CoachScheduleByDayCell")

        setUpFootReFresh()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "生成排班", style: .plain, target: self, action: #selector(classClick))
        navigationItem.title = dateString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setUpHeaderReFresh()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachScheduleByDayCell", for: indexPath) as! CoachScheduleByDayCell
        cell.model = array[indexPath.row]
        return cell
    }
    

  
}

extension CoachScheduleByDayVC {//
    func getData(firstGet:Bool) {
        HomeNetTool.getCoachScheduleByDay(UserId: userId, CoachId: coachId, dateString: dateString, currentPage: currentPage, Success: {[weak self] (page, array) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.tableView.mj_footer.isHidden = page.totalPage == 1 || array.count == 0
            self?.page = page
            if firstGet == true {
                self?.array = array
                if array.count == 0 && self?.isFirst == true {
                    self?.classClick()
                    self?.isFirst = false
                }
            }else{
                self?.array.append(contentsOf: array)
            }
            self?.tableView.reloadData()
           
        }) {[weak self] (error) in
            self?.tableView.mj_footer.isHidden = self?.array.count == 0
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }
    }
    fileprivate func setUpHeaderReFresh() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.currentPage = 1
            self?.getData(firstGet: true)
            
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
                self?.getData(firstGet: false)
            }
        })
    }
    
    @objc func classClick () {
        let vc = SchedulingDetailVC()
        vc.userId = userId
        vc.coachId = coachId
        vc.schDateString = dateString
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
