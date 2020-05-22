//
//  SubmitOrderVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/22.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class SubmitOrderVC: UITableViewController {
    
    var timeStr = ""
    
    var moneyStr = ""
    
    var typeStr = ""
    
    var bookCount = ""
    
    var idStr = ""
    
    var coachId = ""
    
    var loginModel:LoginModel?
    
    lazy var titleArr = [timeStr,moneyStr,typeStr,bookCount]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MTListViewCell", for: indexPath) as! MTListViewCell
        cell.infoLabel.text = titleArr[indexPath.row]
        cell.topLine.backgroundColor = UIColor.orange
        cell.bottomLine.backgroundColor = indexPath.row == titleArr.count-1 ? UIColor.gray : UIColor.orange
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        scrollViewDidScroll(self.tableView)
    }
   
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MTListViewCell
        let bottomCell = tableView.cellForRow(at: IndexPath(row: titleArr.count-1, section: 0)) as? MTListViewCell
        topCell?.topLineTopConstraint.constant = min(0, scrollView.contentOffset.y)
        bottomCell?.bottomLineBottomConstraint.constant = -scrollView.contentOffset.y-scrollView.height
    }
}
extension SubmitOrderVC {
    fileprivate func setUpUI() {
        
        edgesForExtendedLayout = UIRectEdge.all
        view.backgroundColor = grayBackColor
        title = "生成订单"
        tableView.register(UINib(nibName: "MTListViewCell", bundle: nil), forCellReuseIdentifier: "MTListViewCell")
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        
        let btn = UIButton(frame: CGRect.zero)
        btn.setTitle("确认", for: .normal)
//        btn.titleLabel?.font = UIFont.init(name: "AmericanTypewriter-Bold", size: 17)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.textAlignment = .center
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        
        btn.frame = CGRect(x: 48, y: 10, width: SCREEN_WIDTH-48-16, height: 45)
        btn.addTarget(self, action: #selector(SubmitOrderClick), for: .touchUpInside)
        let backview = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        backview.addSubview(btn)
        tableView.tableFooterView = backview
    }
    @objc fileprivate func SubmitOrderClick () {
        HomeNetTool.getOrderAdd(UserId: loginModel?.userId ?? "", StuId: loginModel?.userId ?? "", CoachId: coachId, SeduIds: idStr) {
            SVProgressHUD.showSuccess(withStatus: "提交成功")
            SVProgressHUD.dismiss(withDelay: 1.2)
            let vc = InquireAboutCar()
            vc.loginModel = self.loginModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
