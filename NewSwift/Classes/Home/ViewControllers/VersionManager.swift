//
//  VersionManager.swift
//  DistanceEducation
//
//  Created by gail on 2019/1/11.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit


class VersionManager: NSObject {
    /// app版本更新检测
    ///
    /// - Parameter appId: apple ID - 开发者帐号对应app处获取
    static let share = VersionManager()
    override init() {
        super.init()

    }
     func updateAppVersion(){
        let appId:String = "1252917972"
        //获取appstore上的最新版本号
        let appUrl = URL.init(string: "http://itunes.apple.com/lookup?id=" + appId)
        guard let appMsg = try? String.init(contentsOf: appUrl!, encoding: .utf8) else{
            return
        }
        let appMsgDict:NSDictionary = VersionManager.share.getDictFromString(jString: appMsg)
        let appResultsArray:NSArray = (appMsgDict["results"] as? NSArray)!
        let appResultsDict:NSDictionary = appResultsArray.lastObject as! NSDictionary
        let appStoreVersion:String = appResultsDict["version"] as! String
        let appStoreVersion_Float:Float = Float(appStoreVersion)!
        
        //获取当前手机安装使用的版本号
        let localVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let localVersion_Float:Float = Float(localVersion)!
        
        //用户是否设置不再提示
//        let userDefaults = UserDefaults.standard
//        let res = userDefaults.bool(forKey: "NO_ALERt_AGAIN")
        //appstore上的版本号大于本地版本号 - 说明有更新
        if appStoreVersion_Float > localVersion_Float {
            let alertC = UIAlertController.init(title: "\(appStoreVersion_Float)版本更新了!", message: "\n请前往APP商城下载最新版本", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: "去更新", style: .default, handler: { (handler) in
                VersionManager.share.updateApp(appId:appId)
            })
            yesAction.setValue(UIColor.darkGray, forKey: "_titleTextColor")

            alertC.addAction(yesAction)

            UIApplication.shared.keyWindow?.rootViewController?.present(alertC, animated: true, completion: nil)
        }
    }
    
    //去更新
    func updateApp(appId:String) {
        let updateUrl:URL = URL.init(string: "http://itunes.apple.com/app/id" + appId)!
//        UIApplication.shared.openURL(updateUrl)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(updateUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(updateUrl)
        }
    }
    
    //JSONString转字典
    func getDictFromString(jString:String) -> NSDictionary {
        let jsonData:Data = jString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
}
