
//
//  SchedulingRecordsVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/8.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class SchedulingRecordsVC : UIViewController {

    var loginModel:LoginModel?
    lazy var titleArray = [String]()
    lazy var timeModelArray = [Timemodel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "可约排班"
        
        for model in timeModelArray {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let data = dateFormatter.date(from: model.SchDate)
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "M月d日"
            let str = outputFormatter.string(from: data!)
            let vc = AppropriateSchedulingVC()
            vc.timeModel = model
            vc.loginModel = loginModel
            titleArray.append(str)
            addChildViewController(vc)
        }
        let pageMenu = PageMenu(frame: self.view.frame, titleColor: UIColor.white.withAlphaComponent(0.5), selectedColor: UIColor.white ,titleArray:titleArray ,parantVC:self)
        view.addSubview(pageMenu)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(commitClick))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = nil
    }

    @objc func commitClick() {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "commitClick"), object: nil)
    }
}

