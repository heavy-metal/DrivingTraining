//
//  MapViewController.swift
//  NewSwift
//
//  Created by gail on 2019/6/13.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    lazy var mapView:MKMapView = {
        var mapView               = MKMapView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        mapView.userTrackingMode  = .follow
        mapView.mapType           = .standard
        mapView.showsUserLocation = true
        mapView.delegate          = self
        mapView.showsCompass      = false
        mapView.showsTraffic      = true
        return mapView
    }()
    lazy var locationManager : CLLocationManager = {
        var manager             = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter  = 100.0
        manager.delegate        = self
        // 距离筛选器: 单位是米, 当位置发生超过10米变化时才调用代理方法
//        manager.distanceFilter  = 5.0
        
        return manager
    }()
    
    var annotationArray:[MyAnnotation]?

    var isFirstCome = true
    
    var selectAnnotation:MyAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        view.addSubview(mapView)
        
        
    }

}
extension MapViewController : MKMapViewDelegate , CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if isFirstCome == true {
         
            mapView.addAnnotations(self.annotationArray!)
            isFirstCome = false
            
            let geocoder = CLGeocoder()
            guard let location = userLocation.location else {return}
            
            //反地理编码
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil || placemarks?.count == 0 {return}
                let placeMark = placemarks?.first
                userLocation.title = placeMark?.subLocality
                userLocation.subtitle = placeMark?.name
                
            }
            
            //调整地图区域跨度
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
    }
}
extension MapViewController {


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let userView = UserAnnotationView(annotation: annotation, reuseIdentifier: "user")
        
            userView.annotation = annotation
            
            return userView
        }
        let reuserId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId)
            as? MKPinAnnotationView
        pinView?.annotation = annotation
        if pinView == nil {
            //创建一个大头针视图
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
        }
        pinView?.canShowCallout = true
        pinView?.animatesDrop = true
        
        let btn = UIButton(type: .custom)
        btn.setTitle("🧭导航", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.addTarget(self, action: #selector(BtnClick), for: .touchUpInside)
        pinView?.rightCalloutAccessoryView = btn
        
        let imageV = UIImageView(frame: CGRect(x: 5, y: 0, width: 57, height: 40))
        imageV.isUserInteractionEnabled = true
        let imageBtn = UIButton(frame: imageV.frame)
        imageBtn.setTitle("", for: .normal)
        let anno = annotation as! MyAnnotation
        imageV.sd_setImage(with: URL(string: anno.icon ?? ""))
        imageV.addSubview(imageBtn)
        
        imageBtn.addTarget(self, action: #selector(imageVClick), for: .touchUpInside)

        pinView?.leftCalloutAccessoryView = imageV
        
        return pinView
    }
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        SVProgressHUD.showError(withStatus: "定位失败,请检查网络")
        SVProgressHUD.dismiss(withDelay: 1.5)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view1 in views {
            if view1.annotation is MKUserLocation {
                mapView.selectAnnotation(view1.annotation!, animated: true)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {return}
        self.selectAnnotation = view.annotation as? MyAnnotation

    }
    
    @objc fileprivate func imageVClick() {//驾校详情
    
        let detailVC = DetailVC()
        detailVC.detailType = .school
        detailVC.schoolModel = self.selectAnnotation?.schoolModel
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc fileprivate func BtnClick () {//导航
        let alertController = UIAlertController(title: "请选择地图导航", message: nil, preferredStyle: .actionSheet)
        var array = [String]()
        if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {array.append("高德地图")}
        if UIApplication.shared.canOpenURL(URL(string: "baidumap://map/")!) {array.append("百度地图")}
        array.append("系统地图")
        for title in array {
            let action = UIAlertAction(title: title, style: .default) { (action) in
                if action.title == "系统地图"{
                    self.goToSystemMap()
                }
                if action.title == "高德地图"{
                    self.gaodeDitu()
                }
                if action.title == "百度地图"{
                    self.baiduDitu()
                }
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func goToSystemMap(){//跳转系统地图
        let currentLocation = MKMapItem.forCurrentLocation()
        currentLocation.name = self.mapView.userLocation.subtitle
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: self.selectAnnotation!.coordinate, addressDictionary: nil))
        toLocation.name = self.selectAnnotation?.title
        MKMapItem.openMaps(with: [currentLocation, toLocation],launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:true])
    }
    func gaodeDitu(){//跳转高德地图
        guard let url = "iosamap://navi?sourceApplication=星云轻驾培&poiname=\(self.selectAnnotation?.title ?? "")&lat=\(self.selectAnnotation?.coordinate.latitude ?? 0.0)&lon=\(self.selectAnnotation?.coordinate.longitude ?? 0.0)&dev=1&style=0".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        UIApplication.shared.openURL(URL.init(string: url)!)
    }
    func baiduDitu() {//跳转百度地图
//        let latitude = self.mapView.userLocation.coordinate.latitude
//        let longitude = self.mapView.userLocation.coordinate.longitude
        let coor = GPSLocationTool.gcj02(toBd09: self.selectAnnotation!.coordinate)
        let getName = self.selectAnnotation?.title ?? ""
        let urlString = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(coor.latitude),\(coor.longitude)|name=\(getName)&mode=driving&coord_type=gcj02".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        UIApplication.shared.openURL(URL.init(string: urlString!)!)
    }
}



