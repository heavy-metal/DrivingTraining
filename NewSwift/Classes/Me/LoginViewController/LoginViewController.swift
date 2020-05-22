//
//  LoginViewController.swift
//  DistanceEducation
//
//  Created by gail on 2018/6/1.
//  Copyright © 2018年 NewSwift. All rights reserved.
//

import UIKit
//import SDWebImage


class LoginViewController: UIViewController {
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var userTextfield: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var remberPswdBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var chooseCityBtn: UIButton!
    
    var loginType = "StudentLogin"
    
    var insId = ""
    
    var schoolName = ""
    
    var isHavePswd : Bool = false
    
    lazy var allSchoolNameArray = [String]()
    
    lazy var schoolArray = [SchoolModel]()
    
    lazy var schoolNameBtn : UIButton = {
        var schoolNameBtn = UIButton(type: .custom)
        schoolNameBtn.setImage(UIImage(named:"jiantou"), for: .normal)
        schoolNameBtn.layer.borderWidth = 1
        schoolNameBtn.layer.borderColor = UIColor.white.cgColor
        schoolNameBtn.layer.cornerRadius = 10
//        schoolNameBtn.setTitle("", for: .normal)
        schoolNameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        schoolNameBtn.addTarget(self, action: #selector(schoolNameBtnClick), for: .touchUpInside)
        return schoolNameBtn
    }()
    
    lazy var pickerView = CustomPickerView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height:SCREEN_HEIGHT*0.4+50), contentArray: allSchoolNameArray) {[weak self] (index) in
        
        self?.schoolNameBtn.setTitle(self?.allSchoolNameArray[index], for: .normal)
        let model = self!.schoolArray[index]
        self?.insId = model.InsId
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        schoolNameBtn.frame = CGRect(x: (chooseCityBtn.frame.minX-remberPswdBtn.frame.maxX-chooseCityBtn.width)/2+remberPswdBtn.frame.maxX, y: chooseCityBtn.y, width: chooseCityBtn.width, height: chooseCityBtn.height)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllSchoolName()
        
        chooseCityBtn.layer.borderWidth = 1
        chooseCityBtn.layer.borderColor = UIColor.white.cgColor
        chooseCityBtn.layer.cornerRadius = 10
        chooseCityBtn.layer.masksToBounds = true

        userTextfield.delegate = self
        userTextfield.placeholder = "用户名"
        userTextfield.textColor = UIColor.white
        

//        userTextfield.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        
        let placeholderLabel = object_getIvar(userTextfield, class_getInstanceVariable(UITextField.self, "_placeholderLabel")!) as! UILabel
        placeholderLabel.textColor = UIColor.white
        
        passwordTextField.tintColor = UIColor.white
        userTextfield.tintColor = UIColor.white
        passwordTextField.delegate = self
        passwordTextField.placeholder = "密码"
//        passwordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        
        let placeholderLabel1 = object_getIvar(passwordTextField, class_getInstanceVariable(UITextField.self, "_placeholderLabel")!) as! UILabel
               placeholderLabel1.textColor = UIColor.white
        
        passwordTextField.textColor = UIColor.white
        passwordTextField.isSecureTextEntry = true
        loginBtn.layer.cornerRadius = 15
        loginBtn.clipsToBounds = true
        loginBtn.backgroundColor = GlobalColor
        userTextfield.leftView = UIImageView(image: UIImage(named: "user_white.png"))
        passwordTextField.leftView = UIImageView(image: UIImage(named: "password_white.png"))
        
        view.addSubview(schoolNameBtn)
        schoolNameBtn.isHidden = true
        
    }
    
    //选择登录方式的按钮
    @IBAction func chooseCityBtnClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "选择登录方式", message: nil, preferredStyle: .actionSheet)
        let studentAction = UIAlertAction(title: "学员", style: .default) { (action) in
            
            sender.setTitle(action.title, for: .normal)
            self.loginType = "StudentLogin"
            self.schoolNameBtn.isHidden = true
            self.insId = ""
        }
        studentAction.setValue(UIColor.darkGray, forKey: "_titleTextColor")
        let coachAction = UIAlertAction(title: "教练", style: .default) { (action) in
            
            sender.setTitle(action.title, for: .normal)
            self.loginType = "CoachLogin"
            self.schoolNameBtn.isHidden = true
            self.insId = ""
        }
        coachAction.setValue(UIColor.darkGray, forKey: "_titleTextColor")
        let schoolAction = UIAlertAction(title: "驾校", style: .default) { (action) in
            
            sender.setTitle(action.title, for: .normal)
            self.loginType = "SchoolLogin"
           
            UIView.animate(withDuration: 0.4, animations: {
                self.pickerView.y -= (SCREEN_HEIGHT*0.4+50)
            })
            self.schoolNameBtn.isHidden = false
        }
        schoolAction.setValue(UIColor.darkGray, forKey: "_titleTextColor")
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.darkGray, forKey: "_titleTextColor")
        alert.addAction(studentAction)
        alert.addAction(coachAction)
        alert.addAction(schoolAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil);
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        if let loginInfo = ZJKeyChain.load("Login") as? [String:String] {
            remberPswdBtn.isSelected = true
            userTextfield.text = loginInfo["userName"]
            passwordTextField.text = loginInfo["passWord"]
            isHavePswd = true
            let logintype = loginInfo["loginType"]
            if logintype == "StudentLogin" {
                self.loginType = "StudentLogin"
                chooseCityBtn.setTitle("学员", for: .normal)
            }else if logintype == "CoachLogin" {
                self.loginType = "CoachLogin"
                chooseCityBtn.setTitle("教练", for: .normal)
            }else {
                self.loginType = "SchoolLogin"
                chooseCityBtn.setTitle("驾校", for: .normal)
                self.insId = loginInfo["insId"] ?? ""
                self.schoolNameBtn.setTitle(loginInfo["schoolName"], for: .normal)
                self.schoolNameBtn.isHidden = false
            }
            loginBtnClick(loginBtn)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //记住密码
    @IBAction func remberPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    //登录
    @IBAction func loginBtnClick(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if self.remberPswdBtn.isSelected == false {
            ZJKeyChain.delete("Login")
        }
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show(withStatus: "正在登录...")
        if userTextfield.text=="" || passwordTextField.text=="" {
            SVProgressHUD.showError(withStatus: "用户名或密码不能为空")
            SVProgressHUD.dismiss(withDelay: 1.5)
            return
        }
        if loginType == "SchoolLogin"{
            if insId == "" {
                SVProgressHUD.showError(withStatus: "请输入您当前所在的驾校")
                SVProgressHUD.dismiss(withDelay: 1.5)
                return
            }
        }
        
        getLoginInfo(userName: userTextfield.text ?? "", passWord: passwordTextField.text ?? "", loginType: loginType, insId: insId)
    }
   
}
extension LoginViewController {
    
    fileprivate func getLoginInfo (userName:String ,passWord:String ,loginType:String ,insId:String){
        let password = isHavePswd ? passWord : passWord.md5()
        HomeNetTool.getLoginInfo(loginType: loginType, UserName: userName, Password: password, insId: insId, Success: { (loginModel) in
            if self.remberPswdBtn.isSelected == true {
                if loginType != "SchoolLogin" {self.schoolNameBtn.setTitle(loginType, for: .normal)}
                ZJKeyChain.save("Login", data: ["userName":userName ,"passWord":password ,"loginType":loginType ,"insId":insId ,"schoolName":self.schoolNameBtn.titleLabel?.text])
//                let userDefault = UserDefaults.standard
//                userDefault.set(<#T##url: URL?##URL?#>, forKey: <#T##String#>)
            }
//            ZJKeyChain.save("LoginInfo", data: ["UserId":loginModel.userId ,"InsId":loginModel.InsId ,"GroupId":loginModel.GroupId])
            
            let mineVC = MineViewController()
            
            if self.loginType == "StudentLogin" {
                loginModel.loginType = .student
                let userDefault = UserDefaults.standard
                userDefault.set(loginModel.userId, forKey: "StudentAlreadyRegistered")
                
            }else if self.loginType == "CoachLogin" {
                loginModel.loginType = .coach
            }else {loginModel.loginType = .school}
            
            mineVC.loginModel = loginModel
            SVProgressHUD.dismiss()
            self.navigationController?.pushViewController(mineVC, animated: true)
        }) {[weak self] (error) in
            self?.isHavePswd = false
            self?.passwordTextField.text = ""
        }
    }
    
   
}


extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        SVProgressHUD.dismiss()
        
        if textField.text == "" {
            SVProgressHUD.showError(withStatus: "用户名或密码不能为空")
            SVProgressHUD.dismiss(withDelay: 2)
            return false
        }
        if textField == userTextfield {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isHavePswd = false
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dealWithKeyboardFrame()
    }
    
}
extension LoginViewController {
    /// mark 键盘遮挡问题
    func dealWithKeyboardFrame() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("UIKeyboardWillShowNotification"), object: nil, queue: nil) { (dic) in
            let info = dic.userInfo as! [String:Any]
            let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let btnMaxY = self.loginBtn.frame.maxY
            if btnMaxY + keyboardFrame.size.height > SCREEN_HEIGHT && self.view.frame.minY == 0 {
                let offset = btnMaxY - keyboardFrame.minY + 10
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
extension LoginViewController {
    func getAllSchoolName(){
        HomeNetTool.getInsListData(Success: {[weak self] (array) in
            for model in array {
                self?.allSchoolNameArray.append(model.ShortName)
            }
            self?.schoolArray = array
            self?.view.addSubview(self!.pickerView)
            self?.pickerView.pickerView.selectRow(3, inComponent: 0, animated: true)
        }) { (error) in
            
        }
    }
    @objc func schoolNameBtnClick () {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.pickerView.y -= (SCREEN_HEIGHT*0.4+50)
        })
    }
    
}
