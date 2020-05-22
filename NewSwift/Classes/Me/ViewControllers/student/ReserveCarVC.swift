//
//  ReserveCarVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/5.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class ReserveCarVC: UITableViewController {

    var currentPage = 1
    var page:Page?
    lazy var array = [ReserveModel]()
    var loginModel:LoginModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "Date")//解决约车时间只能上传一天
        view.backgroundColor = grayBackColor
        tableView.register(UINib(nibName: "CoachListCell", bundle: nil), forCellReuseIdentifier: "CoachListCell")
        tableView.separatorStyle = .none
        setUpHeaderReFresh()
        setUpFootReFresh()
        self.navigationItem.title = "选择约车教练"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachListCell", for: indexPath) as! CoachListCell
        let model = self.array[indexPath.row]
        cell.icon.sd_setImage(with: URL(string: model.CoachImage)!)
        cell.applyBtn.isHidden = true
        cell.coachNameLabel.text = model.Name
        cell.fromShoolLabel.text = model.SchoolName
        cell.starView.rating = CGFloat((model.StarLevel as NSString).doubleValue)
        cell.accessoryType = .disclosureIndicator
        let lineView = UIView(frame: CGRect(x: 0, y: 110-1, width: SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = grayBackColor
        cell.addSubview(lineView)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.array[indexPath.row]
        getTimeData(model: model)
    }

}
extension ReserveCarVC {
    
    fileprivate func getHomeData(firstGet: Bool){
        HomeNetTool.getReserveCoachList(currentPage: currentPage, UserId: loginModel?.userId ?? "", stuId: loginModel?.userId ?? "", Success: {[weak self] (page, array) in
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
extension ReserveCarVC {
    
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
extension ReserveCarVC {
    func getTimeData(model:ReserveModel) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show()
        HomeNetTool.GetTimeData(coachId: model.CoachId , UserId: loginModel?.userId ?? "", stuId: loginModel?.userId ?? "") {(array) in
            let vc = SchedulingRecordsVC()
            vc.loginModel = self.loginModel
            vc.timeModelArray = array
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
