//
//  DetailVC.swift
//  NewSwift
//
//  Created by gail on 2019/5/27.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

enum DetailType {
    case school
    case coach
    case regist
}

class DetailVC: UIViewController {
    
    var schoolModel:SchoolModel?
    var coachModel:CoachModel?
    var registModel:RegistModel?
    var currentPage = 1
    var page:Page?
    var insId = ""
    var detailType:DetailType?
    lazy var controllors = [UIViewController]()
    lazy var titleArray:[String] = ["详情","报班"]
    
    lazy var tableView : TouchTableView = {
       let tableView = TouchTableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    lazy var backView: UIView = {
       var backView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headViewHeight))
        backView.addSubview(imageV)
        return backView
    }()
    lazy var effectView : UIVisualEffectView = {//毛玻璃
        var blur = UIBlurEffect(style: .dark)
        var effectView = UIVisualEffectView(effect: blur)
        effectView.frame = backView.frame
        return effectView
    }()

    lazy var imageV : UIImageView = {
        var imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headViewHeight))
        
        switch detailType {
        case .school?:
            imageV.sd_setImage(with: URL(string: schoolModel!.SchImage))
        case .coach?:
            imageV.sd_setImage(with: URL(string: coachModel!.CoachImage))
            
        default:
            imageV.sd_setImage(with: URL(string: registModel!.RegSiteImage))
        }
        
        return imageV
    }()
    lazy var contentScr:ContentScrollView = {
        var contentScr = ContentScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), controllers: controllors ,isNavigaBar:false)
        return contentScr
    }()
    lazy var titleScr:TitleScrollView = {
        var titleScr = TitleScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40), titleArray: titleArray, titleColor: UIColor.gray, selectColor: UIColor.darkGray ,isNavigaBar: false)
        let lineView = UIView(frame: CGRect(x: 0, y: 40-1, width: SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = UIColor.groupTableViewBackground
        titleScr.addSubview(lineView)
        return titleScr
    }()
    
    lazy var icon:UIImageView = {
       var width:CGFloat = 100
       var icon = UIImageView(frame: CGRect(x: (SCREEN_WIDTH-width)/2, y: (headViewHeight-width)/2, width: width, height: width))
        icon.image = imageV.image
        icon.layer.cornerRadius = width/2
        icon.layer.masksToBounds = true
        icon.layer.borderWidth = 1
        icon.layer.borderColor = UIColor.white.cgColor
        icon.contentMode = .scaleAspectFill
        
        return icon
    }()
    
    var canScroll : Bool?
    var barImageView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVC()
        setUpUI()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("Detail_leaveTop"), object: nil, queue: nil) { (_) in
            self.canScroll = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
extension DetailVC {

    fileprivate func addChildVC()  {
        
        let messageVC = DetailMessageVC()
        let classVC = ClassListVC()
        switch detailType {
        case .school?:
            messageVC.schoolModel = schoolModel
            classVC.insId = schoolModel?.InsId ?? ""
            self.navigationItem.title = schoolModel?.ShortName
            
        case .coach?:
            messageVC.coachModel = coachModel
            classVC.insId = coachModel?.InsId ?? ""
            classVC.coachName = coachModel?.Name ?? ""
            self.navigationItem.title = coachModel?.Name
        default:
            messageVC.registModel = registModel
            classVC.insId = registModel?.InsId ?? ""
            self.navigationItem.title = registModel?.RegSiteName
        }
        messageVC.detailType = detailType
        self.controllors.append(messageVC)
        self.addChildViewController(messageVC)
        
        classVC.insId = schoolModel?.InsId ?? ""
        self.controllors.append(classVC)
        self.addChildViewController(classVC)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置导航栏背景图片
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(GlobalColor.withAlphaComponent(0)), for: UIBarMetrics.default)
        //设置导航栏阴影图片
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //设置导航栏title初始颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white.withAlphaComponent(0)]
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    fileprivate func setUpUI() {
        
        self.tableView.tableHeaderView = backView
        view.addSubview(tableView)
        
        if self.detailType == .coach {
    
            imageV.addSubview(effectView)
            backView.addSubview(icon)
        }
    
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
    }
    
}

extension DetailVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Detail_CELL")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Detail_CELL")
        }
        cell?.addSubview(contentScr)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return titleScr
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        let tabOffsetY = tableView.rect(forSection: 0).minY - NavBarHeight
        

        if offsetY >= 0 {//设置导航栏动态透明
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(GlobalColor.withAlphaComponent(fabs(offsetY/(headViewHeight-NavBarHeight)))), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white.withAlphaComponent(fabs(offsetY/(headViewHeight-NavBarHeight)))]
        }
        

        if offsetY < 0 && self.detailType != .coach {//下拉放大图片
            var rect = self.imageV.frame
            let xoffset = offsetY/2
            rect.origin.y = offsetY
            rect.size.height = headViewHeight - offsetY
            rect.origin.x = xoffset
            rect.size.width = SCREEN_WIDTH + fabs(xoffset) * 2
            self.imageV.frame = rect
        }
       
        
        if offsetY >= tabOffsetY {
            self.canScroll = false
            NotificationCenter.default.post(name: NSNotification.Name.init("Detail_goTop"), object: nil)
        }
        if self.canScroll == false {
            tableView.contentOffset = CGPoint(x: 0, y: tabOffsetY)
        }
        
    }
}
