//
//  CoachSchedulingVC.swift
//  NewSwift
//
//  Created by gail on 2019/8/15.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class CoachSchedulingVC: UITableViewController {
    
    var userId = ""
    var coachId = ""
    lazy var array = [SchedulingModel]()
    lazy var calendar:BSLCalendar = {
        var calendar = BSLCalendar(frame: CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: 300))
        calendar.selectDate {[weak self] (year, month, day) in
            let monthStr = "\(month)".count == 1 ? "0\(month)":"\(month)"
            let dayStr = "\(day)".count == 1 ? "0\(day)":"\(day)"
    
            let vc = CoachScheduleByDayVC()
            vc.dateString = "\(year)-\(monthStr)-\(dayStr)"
            vc.userId = self?.userId ?? ""
            vc.coachId = self?.coachId ?? ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return calendar
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpHeaderReFresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "排班"
        tableView.separatorStyle = .none
        tableView.tableHeaderView = calendar
        tableView.register(UINib(nibName: "MTListViewCell", bundle: nil), forCellReuseIdentifier: "MTListViewCell")
//        setUpHeaderReFresh()
        tableView.rowHeight = 64
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("changeMonth"), object: nil, queue: nil) { [weak self] (_) in
            
            self?.setUpHeaderReFresh()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MTListViewCell", for: indexPath) as! MTListViewCell
        let model = array[indexPath.row]
        cell.infoLabel.text = "\(model.SchDate)   已约\(model.YwMinute)分钟，可约\(model.KyMinute)分钟"
        cell.topLine.backgroundColor = UIColor.orange
        cell.bottomLine.backgroundColor = indexPath.row == array.count-1 ? UIColor.gray : UIColor.orange
        cell.infoLabel.font = UIFont.systemFont(ofSize: 14)
        cell.infoLabel.textColor = UIColor.darkGray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = array[indexPath.row]
        let vc = CoachScheduleByDayVC()
        vc.dateString = model.SchDate
        vc.userId = self.userId
        vc.coachId = self.coachId 
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        scrollViewDidScroll(self.tableView)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MTListViewCell
        let bottomCell = tableView.cellForRow(at: IndexPath(row: array.count-1, section: 0)) as? MTListViewCell
        topCell?.topLineTopConstraint.constant = min(0, scrollView.contentOffset.y)
        bottomCell?.bottomLineBottomConstraint.constant = -scrollView.contentOffset.y-scrollView.height
    }
    
}
extension CoachSchedulingVC {
    
    func getData() {
        let array = calendar.weeks.yearLabel.text?.components(separatedBy: "年")
        guard let year = (array?.first as NSString?)?.integerValue else { return }
        
        let str1 = array?.last?.prefix((array?.last!.count)!-1)
        
        let month = (str1! as NSString).integerValue
        
        HomeNetTool.getCoachScheduleMonthGroup(UserId: userId, CoachId: coachId, Year: year, Month: month, Success: {[weak self] (array) in
            self?.array = array
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
        }) {[weak self] (error) in
            self?.tableView.mj_header.endRefreshing()
        }
    }
    
    fileprivate func setUpHeaderReFresh() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            
            self?.getData()
        })
        tableView.mj_header.beginRefreshing()
    }
}
