//
//  SchedulingDetailVC.swift
//  NewSwift
//
//  Created by gail on 2019/8/27.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class SchedulingDetailVC: UITableViewController {
    
    lazy var titleArray = ["排版模版","培训部分","训练场",""]
    lazy var templateArray = [String]()
    lazy var addressArray = [String]()
    lazy var seduConfigsArray = [SeduConfigModel]()
    lazy var seduTimesArray = [SeduTimeModel]()
    lazy var regionModelArray = [RegionIdModel]()
    var userId = ""
    var configId = ""
    var coachId = ""
    var schDateString = ""
    var subject = ""
    var regionId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "生成排班"
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        getSeduConfigs()
        getRegionByUserId()
        tableView.register(SeduTimesCell.self, forCellReuseIdentifier: "SeduTimesCell")
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        backView.backgroundColor = grayBackColor
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: 50))
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        backView.addSubview(button)
        tableView.tableFooterView = backView
        view.backgroundColor = grayBackColor
    }

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return seduTimesArray.count == 0 ? 3+1 : 1 + 3 + 1 + seduTimesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 3 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingDetailCell")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "SchedulingDetailCell")
            }
            cell?.textLabel?.text = titleArray[indexPath.row]
            if cell?.detailTextLabel?.text == nil {cell?.detailTextLabel?.text = "请选择"}
            cell?.accessoryType = .disclosureIndicator
            let line = UIView(frame: CGRect(x: 0, y: 50-1, width: SCREEN_WIDTH, height: 1))
            line.backgroundColor = grayBackColor
            cell?.addSubview(line)
            cell?.selectionStyle = .none
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeduTimesCell", for: indexPath) as! SeduTimesCell
            if  indexPath.row == 4 {
                if seduTimesArray.count != 0 {
                    let line = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1))
                    line.backgroundColor = grayBackColor
                    cell.addSubview(line)
                    cell.intervalLabel.text = "时间区间"
                    cell.timeLabel.text = "每段时长"
                    cell.priceLabel.text = "每段价格"
                }
                cell.selectionStyle = .none
            }else if indexPath.row > 4 {
                let model = seduTimesArray[indexPath.row-5]
                cell.intervalLabel.text = "\(model.BeginTime) ~ \(model.EndTime)"
                cell.timeLabel.text = "\(model.Times)(分钟)"
                cell.priceLabel.text = "$\(model.Price)"
                cell.selectionStyle = .none
            }
            
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 2 {return}
        switch indexPath.row {
        case 0:
            if templateArray.count == 0 {return}
            BRStringPickerView.showStringPicker(withTitle: "请选择排班模板", dataSource: templateArray, defaultSelValue: nil, isAutoSelect: false) {[weak self] (str) in
                let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                cell?.detailTextLabel?.text = str as? String
                let model = self?.seduConfigsArray[self?.templateArray.index(of: str as! String) ?? 0]
                self?.configId = model?.ConfigId ?? ""
                self?.getSeduTimes()
            }
            break
        case 1:
            BRStringPickerView.showStringPicker(withTitle: "请选择培训部分", dataSource: ["第二部分","第三部分"], defaultSelValue: nil, isAutoSelect: false) {[weak self] (str) in
                let cell = self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0))
                cell?.detailTextLabel?.text = str as? String
                self?.subject = str as? String == "第二部分" ? "2" : "3"
            }
            break
        default:
            if addressArray.count == 0 {return}
            BRStringPickerView.showStringPicker(withTitle: "请选择训练场", dataSource: addressArray, defaultSelValue: nil, isAutoSelect: false) {[weak self] (str) in
                let cell = self?.tableView.cellForRow(at: IndexPath(row: 2, section: 0))
                cell?.detailTextLabel?.text = str as? String
                for model in self!.regionModelArray {
                    if model.Name ==  str as? String {
                        self?.regionId = model.RegionId
                    }
                }
            }
            
            break
        }
    }

}
extension SchedulingDetailVC {
    func getSeduConfigs(){
        HomeNetTool.getSeduConfigs(UserId: userId) {[weak self] (array) in
            self?.seduConfigsArray = array
            for model in array {
                self?.templateArray.append(model.ConfigName)
            }
        }
    }
    
    func getRegionByUserId() {
        HomeNetTool.getRegionByUserId(UserId: userId) { [weak self] (array) in
            self?.regionModelArray = array
            for model in array {
                self?.addressArray.append(model.Name)
            }
        }
    }
    
    func getSeduTimes() {
        HomeNetTool.GetSeduTimes(UserId: userId, ConfigId: configId) {[weak self] (array) in
            self?.seduTimesArray = array
            self?.tableView.reloadData()
        }
    }
    
    func scheduleBuildCoachDay(){
        HomeNetTool.scheduleBuildCoachDay(UserId: userId, ConfigId: configId, CoachId: coachId, SchDate: schDateString, Subject: subject, RegionId: regionId) {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func submitClick() {
        if subject == "" || regionId == "" || configId == "" || userId == "" {
            SVProgressHUD.showError(withStatus: "请把信息填写完整！")
            SVProgressHUD.dismiss(withDelay: 1.5, completion: nil)
            return
        }
        self.scheduleBuildCoachDay()
    }

    
}
