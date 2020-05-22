//
//  InquireDetailAboutCarVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/9.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class InquireDetailAboutCarVC: UITableViewController {
    
    var model:SearchCarOrderModel?
    
    var ratngStarModel:RatingStarModel?
    
    var loginModel:LoginModel?
    
    var ratingText:String?
    
    var firstScore:CGFloat = 0
    var secondScore:CGFloat = 0
    var thirdScore:CGFloat = 0
    var fourthScore:CGFloat = 0
    
    lazy var titleArray = ["教学质量:","教学态度:","教学规范:","行为准则:"]
    
    lazy var ratingArray = [firstScore,secondScore,thirdScore,fourthScore]
    
    lazy var starBackView:UIView = {
        var starBackView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 240))
        for i in 0..<titleArray.count {
            let titleLabel = UILabel(frame: CGRect(x: 10, y: (30+5)*i, width: 80, height: 30))
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            titleLabel.text = titleArray[i]
            let starView = LHRatingView(frame: CGRect(x: Int(titleLabel.frame.maxX+10), y: (30+5)*i, width: 120, height: 30))
            starView.delegate = self
            starView.tag = i+1000
            starView.ratingType = .INTEGER_TYPE//整颗星
            starBackView.addSubview(starView)
            starBackView.addSubview(titleLabel)
        }
        var textView = UITextView(frame: CGRect(x: 10, y: 31*4+20, width: SCREEN_WIDTH-20, height: 80))
        textView.backgroundColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textAlignment = .left
        textView.layer.cornerRadius = 12
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1.5
        textView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        textView.delegate = self
        textView.addSubview(placeHolderLabel)
        if model?.StuPjState==0 {starBackView.addSubview(textView)}
        return starBackView
    }()
    
    let placeHolderLabel:UILabel = {
       var placeHolderLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 200, height: 20))
        placeHolderLabel.text = "在此输入您的评语......"
        placeHolderLabel.textColor = UIColor.gray
        placeHolderLabel.font = UIFont.systemFont(ofSize: 14)
        return placeHolderLabel
    }()
    
    lazy var headView:UIView = {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        headView.backgroundColor = UIColor.groupTableViewBackground
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: 50))
        button.setTitle("提交", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        headView.addSubview(button)
        return headView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "约车订单"
        tableView.register(UINib(nibName: "InquireDetailCarOrderCell", bundle: nil), forCellReuseIdentifier: "InquireDetailCarOrderCell")
        tableView.separatorStyle = .none
        if model?.StuPjState==0 {tableView.tableFooterView = headView}
        if model?.StuPjState==1 {getData()}
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == 0 ? 270 : 240
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InquireDetailCarOrderCell", for: indexPath) as! InquireDetailCarOrderCell
            
            cell.model = self.model
            cell.loginModel = self.loginModel
            return cell
        }else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "starCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "starCell")
            }
            cell?.selectionStyle = .none
            if model?.StuPjState==1 {starBackView.isUserInteractionEnabled = false}
            cell?.addSubview(starBackView)
            return cell!
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }

}
extension InquireDetailAboutCarVC:ratingViewDelegate,UITextViewDelegate {
    func ratingView(_ view: LHRatingView!, score: CGFloat) {
        
        switch view.tag {
        case 1000:
            firstScore = score
            break
        case 1001:
            secondScore = score
            break
        case 1002:
            thirdScore = score
            break
        default:
            fourthScore = score
            break
        }
    }
    
    @objc func submitClick () {
        
        if firstScore == 0 || secondScore == 0 || thirdScore == 0 || thirdScore == 0 || fourthScore == 0 {
            SVProgressHUD.showError(withStatus: "评分不能有0颗星哦")
            SVProgressHUD.dismiss(withDelay: 1.5)
            return
        }
        
        HomeNetTool.OrderEvaluation(UserId: loginModel?.userId ?? "", orderNo: model?.OrderNo ?? "", Quality: NSInteger(firstScore), Attitude: NSInteger(secondScore), Standard: NSInteger(thirdScore), Honest: NSInteger(fourthScore), Content: ratingText ?? "") {
            SVProgressHUD.showSuccess(withStatus: "提交成功")
            SVProgressHUD.dismiss(withDelay: 1.5)
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "postOrder"), object: nil)
        }
    }
   
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = textView.text.count != 0
        ratingText = textView.text
    }
    
}

extension InquireDetailAboutCarVC {
    func getData(){//获取评分数据
        HomeNetTool.GetOrderEvaluation(UserId: loginModel?.userId ?? "", orderNo: model?.OrderNo ?? "") {[weak self] (model) in
            self?.ratngStarModel = model
            let arr = [model.Quality,model.Attitude,model.Standard,model.Honest]
            for i in 0..<arr.count {
                let starView = self?.view.viewWithTag(1000+i) as! LHRatingView
                starView.score = CGFloat(arr[i])
            }
        }
    }
}
