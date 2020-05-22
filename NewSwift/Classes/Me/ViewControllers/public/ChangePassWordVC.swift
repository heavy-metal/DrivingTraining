//
//  ChangePassWordVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/25.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

enum ChangeType:String {
    
    case Student
    case Coach
    case School
}

class ChangePassWordVC: UITableViewController {

    var loginModel:LoginModel?
    var changeType:ChangeType = .Student
    
    lazy var imageArray = ["phone","phone"]
    lazy var placeholderArray = ["请输入您的旧密码","请输入您的新密码"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "修改密码"
        view.backgroundColor = grayBackColor
        tableView.register(ApplyTextFieldCell.self, forCellReuseIdentifier: "ApplyTextFieldCell")
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        backView.backgroundColor = UIColor.groupTableViewBackground
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: 50))
        button.setTitle("确认", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        backView.addSubview(button)
        tableView.tableFooterView = backView
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyTextFieldCell", for: indexPath) as! ApplyTextFieldCell
        cell.textField.placeholder = placeholderArray[indexPath.row]
        cell.textField.isSecureTextEntry = true
        cell.icon.image = UIImage(named:imageArray[indexPath.row])
        cell.textField.delegate = self
        cell.textField.tag = 200 + indexPath.row
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

    @objc fileprivate func submitClick () {
        let oldTextField = self.view.viewWithTag(200) as? UITextField
        let newTextField = self.view.viewWithTag(201) as? UITextField
        if oldTextField?.text == "" || newTextField?.text == "" {return}
        
        if isHaveChinese(oldTextField?.text ?? "") || isHaveChinese(newTextField?.text ?? "") {
            return
        }
        changePassword(OldPassword: oldTextField?.text ?? "", NewPassword: newTextField?.text ?? "")
    }
}

extension ChangePassWordVC : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let cell = tableView.cellForRow(at: IndexPath(row: textField.tag-200, section: 0)) as! ApplyTextFieldCell
        cell.warnLabel.text = textField.text?.count==0 ? "密码不能为空" : ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 200 {
            textField.resignFirstResponder()
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ApplyTextFieldCell
            cell.textField.becomeFirstResponder()
        }else {
            submitClick()
        }
        return true
    }
    
    func isHaveChinese(_ string: String) -> Bool {
        
        for (_, value) in string.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
}

extension ChangePassWordVC {
    func changePassword(OldPassword:String ,NewPassword:String){
        HomeNetTool.changePassword(url: changeType.rawValue, UserId: loginModel?.userId ?? "", InsId: loginModel?.InsId ?? "", OldPassword: OldPassword.md5(), NewPassword: NewPassword.md5()) {[weak self] in
            
            self?.signOut()
        }
    }
    
    func signOut(){
        
        let alert = UIAlertController(title: "", message: "\n密码修改成功！请重新登录帐号\n", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
            ZJKeyChain.delete("Login")
            self?.navigationController?.popToRootViewController(animated: true)
        }
        okAction.setValue(UIColor.darkGray, forKey: "_titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
