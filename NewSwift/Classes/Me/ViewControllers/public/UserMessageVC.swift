

//
//  UserMessageVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/1.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit


class UserMessageVC: UITableViewController {
    
    var loginType:LoginType?
    var checkCarModel:CheckCarModel?
    var coachModel:CoachModel?
    var userId:String?
    var insId:String?
    var stuId = ""
    var isCheckCar:Bool?
    var isSchoolCheckCoach:Bool?
    
    lazy var studentLoginTitleArr = ["姓名","所属驾校","统一编号","证件号","手机","注册日期","培训车型","培训状态","第一部分","第二部分","第三部分","第四部分","上次登录时间"]
    lazy var studentInfoArr = [String]()
    lazy var coachLoginTitleArr = ["姓名","所属驾校","统一编号","证件号","手机","准考车型","教练星级","车牌号","上次登录时间"]
    lazy var coachInfoArr = [String]()
    lazy var schoolLoginTitleArr = ["驾校名称","统一编号","分类等级","经营范围","行政区划","车辆数量","报名电话","地址"]
    lazy var schoolInfoArr = [String]()
    lazy var checkCarTitleArray = ["车牌号","统一编号","车牌颜色","培训车型","购买日期","备案状态","生产厂家","品牌","车架号","发动机号"]
    lazy var checkCarInfoArray = [checkCarModel?.LicNum,checkCarModel?.CarNum,checkCarModel?.PlateColor,checkCarModel?.PerDriType,checkCarModel?.BuyDate,checkCarModel?.SyncState,checkCarModel?.Manufacture,checkCarModel?.Brand,checkCarModel?.FraNum,checkCarModel?.EngNum]
    
    lazy var checkCachTitleArray = ["姓名","性别","所属驾校","行政区划","编号","证件号","手机","准教车型","教练星级","车牌号","用户状态","上次登录时间","冻结日期","冻结原因"]
    
    lazy var checkCoachInfoArray = [coachModel?.Name,coachModel?.Sex,coachModel?.SchoolName,coachModel?.District,coachModel?.CoachNum,coachModel?.IdCard,coachModel?.Mobile,coachModel?.TeachPermitted,"\(coachModel?.StarLevel ?? 0)星",coachModel?.LicNum,coachModel?.UserState,coachModel?.LastTime,coachModel?.StopDate,coachModel?.StopReason]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 55
        tableView.separatorStyle = .none
        
        getData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isCheckCar == true {return checkCarInfoArray.count}
        
        if isSchoolCheckCoach == true {return checkCoachInfoArray.count}
        
        switch loginType {
        case .student?:
            return studentInfoArr.count
        case .coach?:
            return coachInfoArr.count
        default:
            return schoolInfoArr.count
        }
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "message_CELL")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "message_CELL")
        }
        
        if isCheckCar == true {
            cell?.textLabel?.text = checkCarTitleArray[indexPath.row]
            cell?.detailTextLabel?.text = checkCarInfoArray[indexPath.row]
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            let lineView = UIView(frame: CGRect(x: 0, y: 55-1, width: SCREEN_WIDTH, height: 1))
            lineView.backgroundColor = UIColor.groupTableViewBackground
            cell?.addSubview(lineView)
            return cell!
        }
        if isSchoolCheckCoach == true {
            cell?.textLabel?.text = checkCachTitleArray[indexPath.row]
            cell?.detailTextLabel?.text = checkCoachInfoArray[indexPath.row]
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            let lineView = UIView(frame: CGRect(x: 0, y: 55-1, width: SCREEN_WIDTH, height: 1))
            lineView.backgroundColor = UIColor.groupTableViewBackground
            cell?.addSubview(lineView)
            return cell!
        }
        
        switch loginType {
        case .student?:
            cell?.textLabel?.text = studentLoginTitleArr[indexPath.row]
            cell?.detailTextLabel?.text = studentInfoArr[indexPath.row]
            break
        case .coach?:
            cell?.textLabel?.text = coachLoginTitleArr[indexPath.row]
            cell?.detailTextLabel?.text = coachInfoArr[indexPath.row]
            break
        default:
            cell?.textLabel?.text = schoolLoginTitleArr[indexPath.row]
            cell?.detailTextLabel?.text = schoolInfoArr[indexPath.row]
            break
       
        }
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        let lineView = UIView(frame: CGRect(x: 0, y: 55-1, width: SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = UIColor.groupTableViewBackground
        cell?.addSubview(lineView)
        
        return cell!
    }
  
}
extension UserMessageVC {
    fileprivate func getData () {
        if isCheckCar == true || isSchoolCheckCoach == true {return}
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show()
        switch loginType {
            
        case .student?:
            let stuid = stuId == "" ? userId : stuId
            HomeNetTool.getStudentBasicMessage(UserId: userId ?? "", StuId: stuid ?? "") {[weak self] (model) in

                self?.studentInfoArr = [model.Name,model.SchoolName,model.StuNum,model.IdCard,model.Mobile,model.ApplyDate,model.TrainType,model.StudyState,model.State1,model.State2,model.State3,model.State4,model.LastTime]
                self?.tableView.reloadData()
            }
        case .coach?:
            HomeNetTool.getCoachBasicMessage(UserId: userId ?? "", coachId: userId ?? "") {[weak self] (model) in

                self?.coachInfoArr = [model.Name,model.SchoolName,model.CoachNum,model.IdCard,model.Mobile,model.TeachPermitted,model.StarLevel,model.LicNum,model.LastTime]
                self?.tableView.reloadData()
            }
            
        case .school?:
            HomeNetTool.getSchoolBasicMessage(UserId: userId ?? "", insId: insId ?? "") {[weak self] (model) in

                self?.schoolInfoArr = [model.ShortName,model.InsCode,model.Level,model.BusiScope,model.District,String(model.TracarNum) ,model.RegTel,model.Address]
                self?.tableView.reloadData()
            }
            
        default: break
        }
    }
}
