//
//  ApplyViewController.swift
//  NewSwift
//
//  Created by gail on 2019/6/6.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class ApplyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var insID = ""
    var schoolName = ""
    var coachName = ""
    var className = ""
    var registName = ""
    var classID = ""
    var coachId = ""
    var registId = ""
    fileprivate var name = ""
    fileprivate var phoneNumber = ""
    fileprivate var remarks = ""
    fileprivate var applyCount = 0
//    fileprivate var textField:UITextField?
    
    lazy var nameArray = [String]()
    lazy var titleArray = [String]()
    lazy var imageArray = ["name","phone","renshu","mail"]
    lazy var placeholderArray = ["请输入您的名字，必填","请输入您的手机/电话，必填","报名人数，必填","备注"]
    lazy var tableView:UITableView = {
       var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .grouped)
//        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ApplyTextFieldCell.self, forCellReuseIdentifier: "ApplyTextFieldCell")
        tableView.register(SegmentCell.self, forCellReuseIdentifier: "SegmentCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "填写信息"
        view.addSubview(tableView)
        dealWithInfo()
        tableView.sectionFooterHeight = 0.01
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return titleArray.count
        }
        return 5
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 45 : 55
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "name_cell")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "name_cell")
            }
            cell?.textLabel?.text = titleArray[indexPath.row]
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
            cell?.detailTextLabel?.text = nameArray[indexPath.row]
            return cell!
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentCell", for: indexPath) as! SegmentCell
                cell.segment.tag = 600
                return cell
                
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyTextFieldCell", for: indexPath) as! ApplyTextFieldCell
                cell.icon.image = UIImage(named:imageArray[indexPath.row-1])
                cell.textField.placeholder = placeholderArray[indexPath.row-1]
                cell.textField.delegate = self
                cell.warnLabel.tag = 500 + indexPath.row
                cell.textField.tag = 400 + indexPath.row
//                cell.textField.setValue(UIFont.systemFont(ofSize: 14), forKeyPath: "_placeholderLabel.font")
                let placeholderLabel = object_getIvar(cell.textField, class_getInstanceVariable(UITextField.self, "_placeholderLabel")!) as! UILabel
                placeholderLabel.font = UIFont.systemFont(ofSize: 14)
                
                if indexPath.row == 2 || indexPath.row == 3 {
                    cell.textField.keyboardType = .numbersAndPunctuation
                }
                
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-20, height: 45))
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        label.text = section == 0 ? "    报名信息" : "    我的信息"
        label.textAlignment = .left
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

}
extension ApplyViewController {
    
    func dealWithInfo() {
        if schoolName != "" {
            nameArray.append(schoolName)
            titleArray.append("驾校")
        }
        if coachName != "" {
            nameArray.append(coachName)
            titleArray.append("教练")
        }
        if className != "" {
            nameArray.append(className)
            titleArray.append("班级")
        }
        if registName != "" {
            nameArray.append(registName)
            titleArray.append("报名点")
        }
        
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        backView.backgroundColor = UIColor.groupTableViewBackground
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: 50))
        button.setTitle("报名", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        backView.addSubview(button)
        tableView.tableFooterView = backView
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
 
    @objc fileprivate func submitClick () {//提交信息
        if name == "" {
            let warnLabel = self.view.viewWithTag(501) as? UILabel
            warnLabel?.text = "名字不能为空"
        }
        if phoneNumber == "" {
            let warnLabel = self.view.viewWithTag(502) as? UILabel
            warnLabel?.text = "手机号/电话不能为空"
        }
        if applyCount == 0 {
            let warnLabel = self.view.viewWithTag(503) as? UILabel
            warnLabel?.text = "报名人数至少为1"
        }
        if name != "" && phoneNumber != "" && applyCount != 0 {
            
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            
            let segment = self.view.viewWithTag(600) as! UISegmentedControl
            HomeNetTool.submitStudentApply(sexIndex: segment.selectedSegmentIndex == 0 ? 1 : 0, insId: self.insID, name: self.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "", moblie: self.phoneNumber, applyCount: self.applyCount, remarks: self.remarks.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "", coachId: coachId, registId: registId, classId: classID) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
}

extension ApplyViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dealWithKeyboardFrame()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var warnLabel : UILabel?
        switch textField.tag-400 {
        case 1:
            name = textField.text ?? ""
            warnLabel = self.view.viewWithTag(501) as? UILabel
            warnLabel?.text = textField.text?.count==0 ? "名字不能为空" : ""
            
        case 2:
            phoneNumber = textField.text ?? ""
            warnLabel = self.view.viewWithTag(502) as? UILabel
            warnLabel?.text = textField.text?.count==0 ? "手机号/电话不能为空" : ""
            
        case 3:
            applyCount = NSInteger(textField.text ?? "0") ?? 0
            warnLabel = self.view.viewWithTag(503) as? UILabel
            warnLabel?.text = (textField.text?.count==0 || textField.text == "0") ? "报名人数至少为1" : ""
            
        default:
            remarks = textField.text ?? ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag-400 < 4 {
            let nextTextField = self.view.viewWithTag(textField.tag+1) as! UITextField
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
}
extension ApplyViewController {
    /// mark 键盘遮挡问题
    func dealWithKeyboardFrame() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("UIKeyboardWillShowNotification"), object: nil, queue: nil) { (dic) in
            let info = dic.userInfo as! [String:Any]
            let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let btnMaxY = self.tableView.rectForRow(at: IndexPath(row: 4, section: 1)).maxY + 60
            if btnMaxY + keyboardFrame.size.height > SCREEN_HEIGHT && self.view.frame.minY == 0 {
                let offset = btnMaxY - keyboardFrame.minY + NavBarHeight + 10
                UIView.beginAnimations("keyBoardAvoid", context: nil)
                var frame = self.view.frame
                frame.origin.y -= offset
                self.view.frame = frame
                UIView.commitAnimations()
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("UIKeyboardWillHideNotification"), object: nil, queue: nil) { (dic) in
    
            UIView.beginAnimations("keyBoardAvoid", context: nil)
            self.view.frame = self.view.bounds
            UIView.commitAnimations()
        }
    }
}
