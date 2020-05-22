//
//  AppropriateSchedulingVC.swift
//  NewSwift
//
//  Created by gail on 2019/7/15.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class AppropriateSchedulingVC: UIViewController {

    var timeModel:Timemodel?
    var loginModel:LoginModel?
    lazy var array = [CarChooseOrderModel]()
    lazy var indexArray = [Int]()
    lazy var idArray = [String]()
    var today = ""
    
    class OrderFlowLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            
            let collectViewSpace = SCREEN_WIDTH * 0.025
            collectionView?.showsVerticalScrollIndicator = false
            collectionView?.showsHorizontalScrollIndicator = false
            let itemWidth = (SCREEN_WIDTH-collectViewSpace*4)/3
            minimumInteritemSpacing = collectViewSpace
            minimumLineSpacing = collectViewSpace
            sectionInset = UIEdgeInsetsMake(collectViewSpace, collectViewSpace, 0, collectViewSpace)
            itemSize = CGSize(width: itemWidth, height: itemWidth)
            
        }
    }
    
    lazy var collectView  = { () ->  UICollectionView in
        let layout = OrderFlowLayout()
        var collectView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NavBarHeight-40), collectionViewLayout: layout)
        
        collectView.delegate = self
        collectView.dataSource = self
        collectView.register(UINib(nibName: "AppropriateSchedulingCell", bundle: nil), forCellWithReuseIdentifier: "AppropriateSchedulingCell")
        collectView.backgroundColor = UIColor.groupTableViewBackground
        return collectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectView)
        view.backgroundColor = UIColor.groupTableViewBackground
        setUpHeaderReFresh()
        receiveNotificationCenter()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension AppropriateSchedulingVC : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppropriateSchedulingCell", for: indexPath) as! AppropriateSchedulingCell
        let model = array[indexPath.row]
        cell.timeLabel.text = "\(model.SchTimeBegin) ~ \(model.SchTimeEnd)"
        cell.typeLabel.text = "\(model.Subject)  \(model.Price)$"
        cell.addressLabel.text = model.RegionName == "" ? "暂无训练场" : model.RegionName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let defaults = UserDefaults.standard
        let schDate = defaults.value(forKey: "Date")
        if schDate  == nil {
            defaults.set(timeModel?.SchDate, forKey: "Date")
        }else{
            if schDate as? String != timeModel?.SchDate {
                SVProgressHUD.showError(withStatus: "时间段不能隔开")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
        }
    
        let cell = collectionView.cellForItem(at: indexPath) as! AppropriateSchedulingCell
        
        if indexArray.contains(indexPath.row) {
            let arr = indexArray.sorted { $0 < $1 }//升序
            if indexPath.row != arr.first && indexPath.row != arr.last {
                SVProgressHUD.showError(withStatus: "时间段需要连续性，无法取消")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
            indexArray = indexArray.filter { $0 != indexPath.row }
            print(indexArray)
            cell.chooseImageBtn.isSelected = false
            if indexArray.count == 0 { UserDefaults.standard.removeObject(forKey: "Date")}
            return
        }
        
        switch indexArray.count {
        case 0:
            indexArray.append(indexPath.row)
            break
        default:
            let arr = indexArray.sorted { $0 < $1 }//升序
            if indexPath.row == arr.first! - 1 {
                let leftModel = array[indexPath.row]
                let rightModel = array[indexArray.first!]
                if leftModel.SchTimeEnd == rightModel.SchTimeBegin {
                    indexArray.append(indexPath.row)
                }else{
                    SVProgressHUD.showError(withStatus: "时间段不能隔开")
                    SVProgressHUD.dismiss(withDelay: 1)
                    return
                }
            }else if indexPath.row == indexArray.last! + 1 {
                let leftModel = array[indexArray.last!]
                let rightModel = array[indexPath.row]
                if leftModel.SchTimeEnd == rightModel.SchTimeBegin {
                    indexArray.append(indexPath.row)
                }else{
                    SVProgressHUD.showError(withStatus: "时间段不能隔开")
                    SVProgressHUD.dismiss(withDelay: 1)
                    return
                }
            }else {
                SVProgressHUD.showError(withStatus: "时间段不能隔开")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
            break
       
        }
        print(indexArray)
        
        cell.chooseImageBtn.isSelected = !cell.chooseImageBtn.isSelected
        
    }
}
extension AppropriateSchedulingVC {
    func getData(){
        HomeNetTool.getBookCarOrderData(coachId: timeModel?.CoachId ?? "", UserId: loginModel?.userId ?? "", date: timeModel?.SchDate ?? "", Success: {[weak self] (array) in
            self?.array = array
            self?.collectView.reloadData()
            SVProgressHUD.dismiss()
            self?.collectView.mj_header.endRefreshing()
        }) {[weak self] (error) in
            self?.collectView.mj_header.endRefreshing()
        }
    }
    fileprivate func setUpHeaderReFresh() {
        
        collectView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.getData()
        })
        
        collectView.mj_header.beginRefreshing()
    }
}
extension AppropriateSchedulingVC {
    
    func receiveNotificationCenter() {//提交
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("commitClick"), object: nil, queue: nil) {[weak self] (_) in
            
            if self?.indexArray.count == 0 { return }
            
            let hour = 0.5 * Float(self?.indexArray.count ?? 0)
            
            if hour > 4.0 {
                SVProgressHUD.showError(withStatus: "约车时间不能超过4个小时")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
            
           self?.getWeekCount()
        }
    }
    
}

extension AppropriateSchedulingVC {
    
    func getWeekCount(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show()
        HomeNetTool.getWeekCountData(stuId: loginModel?.userId ?? "", UserId: loginModel?.userId ?? "") { (count) in
            self.getWeekAllCount(count)
        }
    }
    
    func getWeekAllCount(_ count:Int){
        
        HomeNetTool.getWeekAllCountData(groupId: loginModel?.GroupId ?? "", UserId: loginModel?.userId ?? "") { (allCount) in
            SVProgressHUD.dismiss()
            self.dealWith(allCount - count)
            
        }
    }
    func dealWith(_ count:Int){
        
        let hour = 0.5 * Float(self.indexArray.count )
       
        let arr = self.indexArray.sorted(){ $0 < $1 }
        let firstmodel = self.array[arr.first ?? 0]
        let lastmodel = self.array[arr.last ?? 0]
        
        var price = 0
        for i in arr {
            let model = self.array[i]
            price += model.price
            idArray.append(model.carID)
        }
        
        let vc = SubmitOrderVC()
        vc.timeStr = "\(UserDefaults.standard.value(forKey: "Date") ?? "") \(firstmodel.SchTimeBegin ) ~ \(lastmodel.SchTimeEnd )"
        vc.moneyStr = "共\(hour)小时  需付\(price)元"
        vc.typeStr = "\(lastmodel.Subject )  \(lastmodel.RegionName)"
        vc.bookCount = "本周还可预约\(count)次"
        vc.idStr = idArray.joined(separator: ",")
        vc.loginModel = loginModel
        vc.coachId = lastmodel.CoachId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
