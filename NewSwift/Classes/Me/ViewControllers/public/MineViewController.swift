//
//  MineViewController.swift
//  SwiftNewProject
//
//  Created by gail on 2017/12/8.
//  Copyright © 2017年 XNX. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {
    
    class CustomFlowLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            
            collectionView?.showsVerticalScrollIndicator = false
            collectionView?.showsHorizontalScrollIndicator = false
            let itemWidth = (SCREEN_WIDTH-LINE_SPACE*4)/3
            minimumInteritemSpacing = LINE_SPACE
            minimumLineSpacing = LINE_SPACE
            sectionInset = UIEdgeInsetsMake(LINE_SPACE, LINE_SPACE, 0, LINE_SPACE)
            itemSize = CGSize(width: itemWidth, height: itemWidth)
            
        }
    }
    
    lazy var collectView  = { () ->  UICollectionView in
        let layout = CustomFlowLayout()
        var collectView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-tabBarHeight), collectionViewLayout: layout)
        
        layout.headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: headViewHeight)
        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "kHeaderViewID")
   
        collectView.delegate = self as UICollectionViewDelegate
        collectView.dataSource = self as UICollectionViewDataSource
        collectView.register(UINib(nibName: "schoolCell", bundle: nil), forCellWithReuseIdentifier: "schoolCell")
        collectView.backgroundColor = UIColor.groupTableViewBackground
        return collectView
    }()
    lazy var studentImageArray = ["people","Timemoney","SUI_jindujihua","yueche","dingdan","liaotian-copy","mima","jianyi","aboutMine"]
    
    lazy var studentTitleArray = ["个人信息","学时查询","学习进度","网上约车","约车订单","客服中心","修改密码","投诉建议","关于我们"]
    
    lazy var coachImageArray = ["people","searchStudent","SUI_jindujihua","guanzhu","yueche","dingdan","liaotian-copy","mima","jianyi","aboutMine","",""]
    lazy var coachTitleArray = ["个人信息","学员查询","每日教学统计","已关注的学员","约车查询","我的排班","客服中心","修改密码","投诉建议","关于我们","",""]
    lazy var schoolImageArray = ["people","searchStudent","guanzhu","yueche","dingdan","liaotian-copy","mima","jianyi","aboutMine"]
    lazy var schoolTitleArray = ["驾校信息","学员查询","教练查询","车辆查询","已关注的学员","客服中心","修改密码","投诉建议","关于我们"]
    
    var loginModel:LoginModel?
    
    
    lazy var icon:UIImageView = {
        var width:CGFloat = 100
        var icon = UIImageView(frame: CGRect(x: (SCREEN_WIDTH-width)/2, y: (headViewHeight-width)/2, width: width, height: width))
        if let imageStr = loginModel?.UserImg {
            icon.sd_setImage(with: URL(string: imageStr))
        }
        icon.layer.cornerRadius = width/2
        icon.layer.masksToBounds = true
        icon.layer.borderWidth = 1
        icon.layer.borderColor = UIColor.white.cgColor
        icon.contentMode = .scaleAspectFill
        
        return icon
    }()
    
//    var rember_ip = IPADRESS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefault = UserDefaults.standard
        userDefault.set(IPADRESS, forKey: "REMBER_IP")
        userDefault.synchronize()//记住当前IP地址
        
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(collectView)
        if #available(iOS 11.0, *) {
            collectView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.tabBarController?.delegate = self
        
        if loginModel?.loginType != .school {
            navigationItem.rightBarButtonItem = UIBarButtonItem(directionType: .right, imageName: "icon_scanQR", target: self, action: #selector(scanQRClick))
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("bookCar"), object: nil, queue: nil) {[weak self] (_) in//首页跳转到约车
            self?.collectionView(self!.collectView, didSelectItemAt: IndexPath(item: 3, section: 0))
            self?.tabBarController?.selectedIndex = 1
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("ChangeIP"), object: nil, queue: nil) {[weak self] (_) in// 切换ip地址
            let ipStr = UserDefaults.standard.value(forKey: "REMBER_IP") as? String
            if ipStr != IPADRESS {
                let alert = UIAlertController(title: "温馨提示", message: "\n您已经切换了其他城市，请重新登录账号", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {[weak self] (_) in
                    ZJKeyChain.delete("Login")
                    UserDefaults.standard.removeObject(forKey: "StudentAlreadyRegistered")
                    self?.navigationController?.popViewController(animated: true)
                })
                alert.addAction(ok)
                self?.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置导航栏背景图片
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(GlobalColor.withAlphaComponent(0)), for: UIBarMetrics.default)
        //设置导航栏阴影图片
        self.navigationController?.navigationBar.shadowImage = UIImage()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
    }

}
extension MineViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch loginModel?.loginType {
        case .student?:
            return studentImageArray.count
        case .coach?:
            return coachImageArray.count
        default:
            return schoolImageArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "schoolCell", for: indexPath) as! schoolCell
        switch loginModel?.loginType {
            case .student?:
                cell.schoolicon.image = UIImage(named: studentImageArray[indexPath.row])
                cell.schoolNameLabel.text = studentTitleArray[indexPath.row]
            case .coach?:
                cell.schoolicon.image = UIImage(named: coachImageArray[indexPath.row])
                cell.schoolNameLabel.text = coachTitleArray[indexPath.row]
            default:
                cell.schoolicon.image = UIImage(named: schoolImageArray[indexPath.row])
                cell.schoolNameLabel.text = schoolTitleArray[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc = UserMessageVC()
            vc.userId = loginModel?.userId
            vc.loginType = loginModel?.loginType
            if loginModel?.loginType == .school {vc.insId = loginModel?.InsId}
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            if loginModel?.loginType == .student {
                let vc = FindStuyTimeViewController()
                vc.userId = self.loginModel?.userId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if loginModel?.loginType == .coach {
                let vc = CheckStudentVC()
                vc.loginModel = loginModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if loginModel?.loginType == .school {
                let vc = CheckStudentVC()
                vc.loginModel = loginModel
                vc.checkType = .studentList
                self.navigationController?.pushViewController(vc, animated: true)
            }

        case 2:
            if loginModel?.loginType == .student {
                let vc = StateStudyVC()
                vc.userId = self.loginModel?.userId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if loginModel?.loginType == .coach {
                let vc = TeachingStatisticsVC()
                vc.userId = loginModel?.userId ?? ""
                vc.coachId = loginModel?.userId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if loginModel?.loginType == .school {
                let vc = CheckStudentVC()
                vc.loginModel = loginModel
                vc.checkType = .SchoolCheckCoach
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 3:
            if loginModel?.loginType == .student {
                let vc = ReserveCarVC()
                vc.loginModel = self.loginModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if loginModel?.loginType == .coach {
                let vc = CheckStudentVC()
                vc.loginModel = self.loginModel
                vc.checkType = .didAttention
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if loginModel?.loginType == .school {
                let vc = CheckStudentVC()
                vc.loginModel = loginModel
                vc.checkType = .checkCar
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 4:
            if loginModel?.loginType == .student {
                let vc = InquireAboutCar()
                vc.loginModel = self.loginModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if loginModel?.loginType == .coach {
                let vc = FindBookCarVC()
                vc.userId = loginModel?.userId ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if loginModel?.loginType == .school {
                let vc = CheckStudentVC()
                vc.loginModel = loginModel
                vc.checkType = .didAttention
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 5:
        if loginModel?.loginType == .coach {
            let vc = CoachSchedulingVC()
            vc.userId = loginModel?.userId ?? ""
            vc.coachId = loginModel?.userId ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 6:
            if loginModel?.loginType == .student {
            let vc = ChangePassWordVC()
            vc.loginModel = self.loginModel
            self.navigationController?.pushViewController(vc, animated: true)
            }
            if loginModel?.loginType == .school {
                let vc = ChangePassWordVC()
                vc.loginModel = self.loginModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 7:
            if loginModel?.loginType == .student {
                let vc = CommonPageViewController()
                let fillInVC = FillInSuggestVC()
                fillInVC.loginModel = self.loginModel
                let historyVC = HistorySuggestVC()
                historyVC.loginModel = self.loginModel
                vc.titles = ["填写","历史"]
                vc.vcArray = [fillInVC,historyVC]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if loginModel?.loginType == .coach {
                let vc = ChangePassWordVC()
                vc.loginModel = self.loginModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if loginModel?.loginType == .school {
                let vc = CommonPageViewController()
                let fillInVC = FillInSuggestVC()
                fillInVC.loginModel = self.loginModel
                let historyVC = HistorySuggestVC()
                historyVC.loginModel = self.loginModel
                vc.titles = ["填写","历史"]
                vc.vcArray = [fillInVC,historyVC]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 8:
            if loginModel?.loginType == .coach {
                let vc = CommonPageViewController()
                let fillInVC = FillInSuggestVC()
                fillInVC.loginModel = self.loginModel
                let historyVC = HistorySuggestVC()
                historyVC.loginModel = self.loginModel
                vc.titles = ["填写","历史"]
                vc.vcArray = [fillInVC,historyVC]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        default:
            
            
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1.取出section的headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "kHeaderViewID", for: indexPath) as UICollectionReusableView
        let backImg = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headViewHeight))
        if let imageStr = loginModel?.UserImg {
            backImg.sd_setImage(with: URL(string: imageStr))
        }
        let toobar = UIToolbar(frame: backImg.frame)
        toobar.barStyle = .blackTranslucent
        backImg.addSubview(toobar)
        toobar.addSubview(icon)
        headerView.addSubview(backImg)
        
        let nameLabel = UILabel(frame: CGRect(x: (SCREEN_WIDTH-70)/2, y: icon.frame.maxY + 10, width: 70, height: 25))
        nameLabel.text = loginModel?.TrueName
        headerView.addSubview(nameLabel)
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        return headerView
    }

}
extension MineViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (tabBarController.selectedViewController?.isEqual(viewController))!  {
            return false
        }
        return true
    }
}
extension MineViewController {
//    fileprivate func getData () {
//        SVProgressHUD.setDefaultMaskType(.black)
//        SVProgressHUD.setDefaultAnimationType(.native)
//        SVProgressHUD.show()
//        switch loginModel?.loginType {
//        case .student?:
//            HomeNetTool.getStudentBasicMessage(UserId: loginModel?.userId ?? "", StuId: loginModel?.userId ?? "") {[weak self] (model) in
//                let vc = UserMessageVC()
//                vc.loginModel = self?.loginModel
//                vc.stuModel = model
//                self?.navigationController?.pushViewController(vc, animated: true)
//            }
//        case .coach?:
//            HomeNetTool.getCoachBasicMessage(UserId: loginModel?.userId ?? "", coachId: loginModel?.userId ?? "") {[weak self] (model) in
//                let vc = UserMessageVC()
//                vc.loginModel = self?.loginModel
//                vc.coachModel = model
//                self?.navigationController?.pushViewController(vc, animated: true)
//            }
//            
//        case .school?:
//            HomeNetTool.getSchoolBasicMessage(UserId: loginModel?.userId ?? "", insId: loginModel?.InsId ?? "") {[weak self] (model) in
//                let vc = UserMessageVC()
//                vc.loginModel = self?.loginModel
//                vc.schoolModel = model
//                self?.navigationController?.pushViewController(vc, animated: true)
//            }
//            
//        default: break
//        }
//    }
    
    @objc fileprivate func scanQRClick() {
        
        let vc = HWScanViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MineViewController : ReturnScanStringDelegate {
    
    func returnScanCode(_ code: String!) {//扫码返回
        
        let strArr = code.prefix(code.count-2).components(separatedBy: ",")
        
        var loginstr = ""
        
        if loginModel?.loginType == .student {
            loginstr = "Student"
        }else if loginModel?.loginType == .coach {
           loginstr = "Coach"
        }
        
        HomeNetTool.upLoadQRcode(loginType: loginstr, TerminalNo: strArr.first ?? "", UserId: loginModel?.userId ?? "", TimeStamp: strArr.last ?? "") {
            SVProgressHUD.showSuccess(withStatus: "设备登录成功")
            SVProgressHUD.dismiss(withDelay: 1.5)
        }
    }
}
