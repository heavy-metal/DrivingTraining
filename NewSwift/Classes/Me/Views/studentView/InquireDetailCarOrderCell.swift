//
//  InquireDetailCarOrderCell.swift
//  NewSwift
//
//  Created by gail on 2019/7/9.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class InquireDetailCarOrderCell: UITableViewCell {

    @IBOutlet weak var orderStateLabel: UILabel!
    @IBOutlet weak var studentPhoneLabel: UILabel!
    @IBOutlet weak var coachPhoneLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var amountYFLabel: UILabel!
    @IBOutlet weak var truePayMoneyLabel: UILabel!
    @IBOutlet weak var payStateLabel: UILabel!
    @IBOutlet weak var payTimeLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var trainingPeriodLabel: UILabel!
    @IBOutlet weak var regionNameLabel: UILabel!
    @IBOutlet weak var cancelOrderBtn: ApplyBtn!
    
    var loginModel:LoginModel?
    
    var model:SearchCarOrderModel? {
        didSet{
            orderStateLabel.text = model?.orderState
            studentPhoneLabel.text = model?.StuMobile
            coachPhoneLabel.text = model?.CoachMobile
            studentNameLabel.text = model?.StuName
            coachNameLabel.text = model?.CoachName
            subjectLabel.text = model?.Subject
            orderNoLabel.text = model?.OrderNo
            amountYFLabel.text = model?.AmountYF
            truePayMoneyLabel.text = model?.AmountSF
            payStateLabel.text = model?.payState
            payTimeLabel.text = model?.PayDate
            orderTimeLabel.text = model?.OrderDate
            trainingPeriodLabel.text =  "\(model?.BeginTime ?? "") - \(model?.EndTime ?? "")"
            regionNameLabel.text = model?.RegionName
        }
    }
    @IBAction func cancelOrderClick(_ sender: ApplyBtn) {
        HomeNetTool.cancelOrder(UserId: loginModel?.userId ?? "", orderNo: model?.OrderNo ?? "") {
            SVProgressHUD.showSuccess(withStatus: "成功取消订单！")
            SVProgressHUD.dismiss(withDelay: 1.3)
            self.viewController()?.navigationController?.popViewController(animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        cancelOrderBtn.setTitle("取消订单", for: .normal)
        cancelOrderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }
}
