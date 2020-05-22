//
//  StateStudyVCTableViewController.swift
//  DistanceEducation
//
//  Created by gail on 2018/10/18.
//  Copyright © 2018 NewSwift. All rights reserved.
//

import UIKit

class StateStudyVC: UITableViewController {

    lazy var headerView = Bundle.main.loadNibNamed("StudyStateHeaderView", owner: nil, options: nil)?.first as! StudyStateHeaderView
    lazy var partArray = ["第一部分","第二部分","第三部分","第四部分"]
    
    var model:StudyStateModel?

    var userId = ""
    var stuId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "学习进度"
//        view.addSubview(navBarView)
        
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50)
        tableView.rowHeight = 190
        tableView.tableHeaderView = headerView
        tableView.register(UINib(nibName: "StudyStateCell", bundle: nil), forCellReuseIdentifier: "StudyStateCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        getData()
    }
    
   
    
  
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyStateCell", for: indexPath) as! StudyStateCell
        cell.partLabel.text = partArray[indexPath.row]
        
        if indexPath.row == 0 {
            cell.partStateLabel.text = "(\(model?.State1 ?? ""))"
            cell.part1NetHourLabel.text = "已学 (\(model?.T_Times1 ?? 0.0)/\(model?.P_Times1 ?? 0.0))"
            cell.part2FaceHourLabel.text = "面授 (\(model?.H_Times1 ?? 0.0)/\(model?.P_Theory1 ?? 0.0))"
            cell.throughHourLabel.text = "通过 (\(model?.C_Times1 ?? 0.0)/\(model?.P_Times1 ?? 0.0))"
            cell.part1ProgressView.progress =  CGFloat((model?.T_Times1 ?? 0.0) / (model?.P_Times1 ?? 0.0))

            cell.part2ProgressView.progress = CGFloat((model?.H_Times1 ?? 0.0)/(model?.P_Theory1 ?? 0.0))
            cell.part3ProgressView.progress = CGFloat((model?.C_Times1 ?? 0.0)/(model?.P_Times1 ?? 0.0))
            
        }else if indexPath.row == 1 {
            cell.partStateLabel.text = "(\(model?.State2 ?? ""),里程\(model?.Miles2 ?? 0.0))"
            cell.part1NetHourLabel.text = "已学 (\(model?.T_Times2 ?? 0.0)/\(model?.P_Times2 ?? 0.0))"
            cell.part2FaceHourLabel.text = "模拟 (\(model?.S_Times2 ?? 0.0))"
            cell.throughHourLabel.text = "通过 (\(model?.C_Times2 ?? 0.0)/\(model?.P_Times2 ?? 0.0))"
            cell.part1ProgressView.progress =  CGFloat((model?.T_Times2 ?? 0.0) / (model?.P_Times2 ?? 0.0))
            
            cell.part2ProgressView.progress = CGFloat((model?.S_Times2 ?? 0.0) == 0.0 ? 0.0 : 1.0)
            cell.part3ProgressView.progress = CGFloat((model?.C_Times2 ?? 0.0)/(model?.P_Times2 ?? 0.0))

        }else if indexPath.row == 2 {
            cell.partStateLabel.text = "(\(model?.State3 ?? ""),里程\(model?.Miles3 ?? 0.0))"
            cell.part1NetHourLabel.text = "已学 (\(model?.T_Times3 ?? 0.0)/\(model?.P_Times3 ?? 0.0))"
            cell.part2FaceHourLabel.text = "模拟 (\(model?.S_Times3 ?? 0.0))"
            cell.throughHourLabel.text = "通过 (\(model?.C_Times3 ?? 0.0)/\(model?.P_Times3 ?? 0.0))"
            cell.part1ProgressView.progress =  CGFloat((model?.T_Times3 ?? 0.0) / (model?.P_Times3 ?? 0.0))
            
            cell.part2ProgressView.progress = CGFloat((model?.S_Times3 ?? 0.0) == 0.0 ? 0.0 : 1.0)
            cell.part3ProgressView.progress = CGFloat((model?.C_Times3 ?? 0.0)/(model?.P_Times3 ?? 0.0))

        }else if indexPath.row == 3 {
            cell.partStateLabel.text = "(\(model?.State4 ?? ""))"
            cell.part1NetHourLabel.text = "已学 (\(model?.T_Times4 ?? 0.0)/\(model?.P_Times4 ?? 0.0))"
            cell.part2FaceHourLabel.text = "面授 (\(model?.H_Times4 ?? 0.0)/\(model?.P_Theory4 ?? 0.0))"
            cell.throughHourLabel.text = "通过 (\(model?.C_Times4 ?? 0.0)/\(model?.P_Times4 ?? 0.0))"
            cell.part1ProgressView.progress =  CGFloat((model?.T_Times4 ?? 0.0) / (model?.P_Times4 ?? 0.0))
            
            cell.part2ProgressView.progress = CGFloat((model?.H_Times4 ?? 0.0)/(model?.P_Theory4 ?? 0.0))
            cell.part3ProgressView.progress = CGFloat((model?.C_Times4 ?? 0.0)/(model?.P_Times4 ?? 0.0))
        }
        return cell
    }
   
}
extension StateStudyVC {

    fileprivate func getData () {
        
        let stuid = stuId == "" ? userId : stuId
        HomeNetTool.GetStudyStateData(UserId: userId, stuId: stuid) { (model) in
            self.model = model
            self.headerView.model = model
            self.tableView.reloadData()
        }
    }
}
