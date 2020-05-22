//
//  TeachingStatisticsVC.swift
//  NewSwift
//
//  Created by gail on 2019/8/12.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import MWPhotoBrowser
class TeachingStatisticsVC: UITableViewController {
    
    var userId = ""
    var coachId = ""
    lazy var array = [StudyTimeModel]()
    lazy var photoArray = [MWPhoto]()
    lazy var titleBtn:UIButton = {
        var titleBtn = UIButton(type: .custom)
        titleBtn.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        titleBtn.setTitle(nowTime(), for: .normal)
        titleBtn.setTitleColor(UIColor.white, for: .normal)
        titleBtn.setImage(UIImage(named:"jiantou"), for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        return titleBtn
    }()
    
    lazy var headerView:TeachingStatisticsView = {
        var headerView = Bundle.main.loadNibNamed("TeachingStatisticsView", owner: nil, options: nil)?.first as! TeachingStatisticsView
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40)
        headerView.backgroundColor = UIColor.white
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentFindTimeCell", for: indexPath) as! StudentFindTimeCell
        cell.model = self.array[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.array[indexPath.row]
        photoArray.removeAll()
        photoArray.append(MWPhoto(url: URL(string: model.PhotoFile1)))
        photoArray.append(MWPhoto(url: URL(string: model.PhotoFile2)))
        photoArray.append(MWPhoto(url: URL(string: model.PhotoFile3)))
        let browser = MWPhotoBrowser(delegate: self)
        browser?.displayNavArrows = true
        browser?.alwaysShowControls = true
        self.navigationController?.pushViewController(browser!, animated: true)
    }

}
extension TeachingStatisticsVC {
    
    func setUI(){
        view.backgroundColor = grayBackColor
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "StudentFindTimeCell", bundle: nil), forCellReuseIdentifier: "StudentFindTimeCell")

        tableView.tableHeaderView = headerView
        navigationItem.titleView = titleBtn
        
        setUpHeaderReFresh()
    }
    
    func nowTime() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let time = formatter.string(from: currentDate)
        return time
    }
    
    @objc func titleBtnClick () {
        BRDatePickerView.showDatePicker(withTitle: "选择时间", dateType: .date, defaultSelValue: nil, minDateStr: nil, maxDateStr: nil, isAutoSelect: false) {[weak self] (str) in
            self?.titleBtn.setTitle(str, for: .normal)
            if str != "" && str != nil {self?.setUpHeaderReFresh()}
        }
    }
    
    func getHomeData(time:String) {
       
        HomeNetTool.coachDayStudySum(userId: userId, coachId: coachId, StudyDate: time,Success: {[weak self] (model) in
            self?.headerView.timeBtn.setTitle("总学时:\(model.TotalTimes)", for: .normal)
            self?.headerView.lichengBtn.setTitle("总里程:\(model.TotalMiles)", for: .normal)
            self?.headerView.studentCountBtn.setTitle("学员数:\(model.TotalStuCount)", for: .normal)
            self?.array = model.array!
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
        }) {[weak self] (error) in
            self?.tableView.mj_header.endRefreshing()
        }
    }
    
    fileprivate func setUpHeaderReFresh() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in

            self?.getHomeData(time: self?.titleBtn.titleLabel?.text ?? "")
        })
        
        tableView.mj_header.beginRefreshing()
    }
   
}
extension TeachingStatisticsVC : MWPhotoBrowserDelegate{
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.photoArray.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index < self.photoArray.count {
            return self.photoArray[NSInteger(index)]
        }
        return nil
    }
    
}
