//
//  rowsCell.swift
//  NewSwift
//
//  Created by gail on 2017/12/25.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit
import RxSwift
import MapKit

class rowsCell: UITableViewCell {
    
    var jktjUrl = ""
    var jklcUrl = ""
    lazy var annotationArray = [MyAnnotation]()
    
    class CustomFlowLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()

            collectionView?.showsVerticalScrollIndicator = false
            collectionView?.showsHorizontalScrollIndicator = false
            let itemWidth = (SCREEN_WIDTH-LINE_SPACE*5)/4
            minimumInteritemSpacing = LINE_SPACE
            minimumLineSpacing = LINE_SPACE
            sectionInset = UIEdgeInsetsMake(LINE_SPACE, LINE_SPACE, 0, LINE_SPACE)
            itemSize = CGSize(width: itemWidth, height: itemWidth)
            
        }
    }
    
    lazy var collectView  = { () ->  UICollectionView in
       var collectView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: COLLECTVIEW_HEIGHT), collectionViewLayout: CustomFlowLayout())
        collectView.delegate = self as UICollectionViewDelegate
        collectView.dataSource = self as UICollectionViewDataSource
        collectView.register(UINib(nibName: "schoolCell", bundle: nil), forCellWithReuseIdentifier: "schoolCell")
        collectView.backgroundColor = UIColor.groupTableViewBackground
        return collectView
    }()
    lazy var btnImageArray = ["yueche","fujingjiaxiao.png","zhengcezixun-1.png","jiakaoliucheng","Process","xuechexuzhi.png","gongnue","tongzhitonggao.png"]

    lazy var btnTitleArray = ["预约学车","附近驾校","政策资讯","驾考流程","驾考条件","学车须知","驾考攻略","通知通告"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension rowsCell : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "schoolCell", for: indexPath) as! schoolCell
        cell.schoolicon.image = UIImage(named: btnImageArray[indexPath.row])
        cell.schoolNameLabel.text = btnTitleArray[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            let userId = UserDefaults.standard.value(forKey: "StudentAlreadyRegistered")
            if userId == nil {
                SVProgressHUD.showError(withStatus: "此功能只允许学员登录后使用")
                SVProgressHUD.dismiss(withDelay: 1)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name.init("bookCar"), object: nil)
            }
            
        case 1:
            self.getData()
        case 2:
            let vc = PublicListController()
            vc.getListIndex = 2
            vc.title = "政策资讯"
            self.viewController().navigationController?.pushViewController(vc, animated: true)
            
        case 3:
            let webVC = CZJWebViewController(urlString: jklcUrl)
            self.viewController().navigationController?.pushViewController(webVC, animated: true)
            
        case 4:
            let webVC = CZJWebViewController(urlString: jktjUrl)
            self.viewController().navigationController?.pushViewController(webVC, animated: true)
            
        case 5:
            let vc = PublicListController()
            vc.getListIndex = 1
            vc.title = "驾考条件"
            self.viewController().navigationController?.pushViewController(vc, animated: true)
            
        case 6:
            let vc = PublicListController()
            vc.getListIndex = 3
            vc.title = "学车须知"
            self.viewController().navigationController?.pushViewController(vc, animated: true)
            
        default:
            let vc = PublicListController()
            vc.getListIndex = 4
            vc.title = "通知通告"
            self.viewController().navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
extension rowsCell {
    fileprivate func getData() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.show()
        HomeNetTool.getInsListData(Success: { (array) in
            SVProgressHUD.dismiss()
            let vc = MapViewController()
            for model in array {
                let arr = model.LngLat.components(separatedBy: ",")
                if arr.first == "" {continue}
                let myAnnotation = MyAnnotation()
                let latitude = (arr.last! as NSString).doubleValue
                let longitude = (arr.first! as NSString).doubleValue
                //原生地图获取坐标转化为真实坐标
                let coor = GPSLocationTool.transform(CLLocationCoordinate2DMake(latitude, longitude))
                myAnnotation.coordinate = CLLocationCoordinate2DMake(coor.latitude ,coor.longitude)
                myAnnotation.title = model.ShortName
                myAnnotation.subtitle = model.Address
                myAnnotation.icon = model.SchImage
                myAnnotation.schoolModel = model
                self.annotationArray.append(myAnnotation)
            }
            vc.annotationArray = self.annotationArray
            
            self.viewController().navigationController?.pushViewController(vc, animated: true)

        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
}
