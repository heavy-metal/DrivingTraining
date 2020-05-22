//
//  FillInSuggestVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/31.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class FillInSuggestVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var chooseBtn: ApplyBtn!
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    
    var loginModel:LoginModel?
    
    lazy var typeArray = ["投诉","咨询","建议","求助","系统反馈"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = grayBackColor
        chooseBtn.setTitle("请选择", for: .normal)
        chooseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        textView.delegate = self
        textView.tintColor = GlobalColor
        textView.layer.cornerRadius = 7
        textView.layer.masksToBounds = true
        textView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        titleField.tintColor = GlobalColor
        titleField.delegate = self
        textView.returnKeyType = .done
        titleField.returnKeyType = .next
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func chooseBtnClick(_ sender: Any) {
        let alert = UIAlertController(title: "反馈类型", message: nil, preferredStyle: .actionSheet)
        for str in typeArray {
            let action = UIAlertAction(title: str, style: .default) { (action) in
                self.chooseBtn.setTitle(action.title, for: .normal)
            }
            action.setValue(UIColor.darkGray, forKey: "_titleTextColor")
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        cancel.setValue(UIColor.darkGray, forKey: "_titleTextColor")
        
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func finishBtnClick(_ sender: Any) {
        if chooseBtn.titleLabel?.text == "请选择" {
            SVProgressHUD.showError(withStatus: "请选择反馈类型")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        if textView.text.count > 300 {
            SVProgressHUD.showError(withStatus: "内容不能超过300个字")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        if titleField.text?.count ?? 0 > 25 {
            SVProgressHUD.showError(withStatus: "标题不能超过25个字")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        if titleField.text?.count==0 || textView.text.count == 0 {
            SVProgressHUD.showError(withStatus: "标题或内容不能为空")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        let index = typeArray.index(of: chooseBtn.titleLabel!.text!)! + 1
        HomeNetTool.addSuggest(UserId: loginModel!.userId, Title: titleField.text ?? "", Type: index, Content: textView.text ?? "") { 
            SVProgressHUD.showSuccess(withStatus: "提交成功!")
            SVProgressHUD.dismiss(withDelay: 1)
            
        }
        
    }
    
}
extension FillInSuggestVC:UITextViewDelegate,UITextFieldDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        warnLabel.isHidden = textView.text.count != 0
        numberLabel.text = "\(textView.text.count)/300"
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        dealWithKeyboardFrame()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dealWithKeyboardFrame()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        textView.becomeFirstResponder()
        return true
    }
    // 控制输入文字的长度和内容
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return range.location < 300
    }
}
extension FillInSuggestVC {
    /// mark 键盘遮挡问题
    func dealWithKeyboardFrame() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("UIKeyboardWillShowNotification"), object: nil, queue: nil) { (dic) in
            let info = dic.userInfo as! [String:Any]
            let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let btnMaxY = self.finishBtn.frame.maxY
            if btnMaxY + keyboardFrame.size.height > self.view.height && self.view.frame.minY == 0 {
                let offset = btnMaxY - keyboardFrame.minY + 8
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
