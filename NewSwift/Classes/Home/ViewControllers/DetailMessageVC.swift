//
//  DetailMessageVC.swift
//  NewSwift
//
//  Created by gail on 2019/5/28.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class DetailMessageVC: DetailBaseVC {
    
    var detailType:DetailType?
    var schoolModel:SchoolModel?
    var coachModel:CoachModel?
    var registModel:RegistModel?
    
    lazy var schoolTitleArray = ["驾校名称","经营范围","电话","地址","车辆数","驾校简介"]
    lazy var schoolInfoArray = [schoolModel?.ShortName,schoolModel?.BusiScope,schoolModel?.RegTel,schoolModel?.Address,"\(schoolModel?.TracarNum ?? 0)",""]
    
    lazy var coachTitleArray = ["教练名字","教练性别","电话","经营范围","所属驾校","驾校区域"]
    lazy var coachInfoArray = [coachModel?.Name,coachModel?.Sex,coachModel?.Mobile,coachModel?.TeachPermitted,coachModel?.SchoolName,coachModel?.District]
    
    lazy var registTitleArray = ["报名点","所属驾校","电话","地址"]
    lazy var registInfoArray = [registModel?.RegSiteName,registModel?.SchoolName,registModel?.Tel,registModel?.District]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isFinishRefresh = true

        setUpUI()
    
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch detailType {
            
        case .school?:
            return schoolTitleArray.count
        case .coach?:
            return coachTitleArray.count
        default:
            return registTitleArray.count
       
    }
}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "message_CELL")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "message_CELL")

        }
        
        switch detailType {
        case .school?:
            cell?.textLabel?.text = schoolTitleArray[indexPath.row]
            cell?.detailTextLabel?.text = schoolInfoArray[indexPath.row]
        case .coach?:
            cell?.textLabel?.text = coachTitleArray[indexPath.row]
            cell?.detailTextLabel?.text = coachInfoArray[indexPath.row]
        default:
            cell?.textLabel?.text = registTitleArray[indexPath.row]
            cell?.detailTextLabel?.text = registInfoArray[indexPath.row]
        }
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.selectionStyle = .none
        let lineView = UIView(frame: CGRect(x: 0, y: 55-1, width: SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = UIColor.groupTableViewBackground
        cell?.addSubview(lineView)
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            var phoneNum = ""
            switch detailType {
            case .school?:
                phoneNum = schoolModel?.RegTel ?? ""
            case .coach?:
                phoneNum = coachModel?.Mobile ?? ""
            default:
                phoneNum = registModel?.Tel ?? ""
            }
            let phone = "tel:" + phoneNum
            if UIApplication.shared.canOpenURL(URL(string: phone)!) {
                UIApplication.shared.openURL(URL(string: phone)!)
            }
        }
    }
    
}
extension DetailMessageVC {
    fileprivate func setUpUI() {

        let btn = UIButton(frame: CGRect.zero)
        btn.setTitle("报名", for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "AmericanTypewriter-Bold", size: 17)

        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.backgroundColor = GlobalColor
        btn.titleLabel?.textAlignment = .center
     
        btn.frame = CGRect(x: 10, y: 10, width: SCREEN_WIDTH-20, height: 45)
        btn.addTarget(self, action: #selector(applyBtnClick), for: .touchUpInside)
        let backview = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        backview.addSubview(btn)
        tableView.tableFooterView = backview
    }
    @objc fileprivate func applyBtnClick () {
        let vc = ApplyViewController()
        switch detailType {
        case .school?:
            vc.insID = schoolModel?.InsId ?? ""
            vc.schoolName = schoolModel?.ShortName ?? ""
            
        case .coach?:
            vc.insID = coachModel?.InsId ?? ""
            vc.coachName = coachModel?.Name ?? ""
            vc.schoolName = coachModel?.SchoolName ?? ""
            vc.coachId = coachModel?.CoachId ?? ""
        default:
            vc.insID = registModel?.InsId ?? ""
            vc.schoolName = registModel?.SchoolName ?? ""
            vc.registName = registModel?.RegSiteName ?? ""
            vc.registId = registModel?.RegSiteId ?? ""
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

