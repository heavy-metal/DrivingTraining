//
//  CheckCarListModel.swift
//  NewSwift
//
//  Created by gail on 2019/10/12.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class CheckCarListModel: Mappable {
    var array : [CheckCarModel]?
    var code = ""
    var message = ""
    var page : Page?
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        array <- map["Data"]
        code <- map["Code"]
        message <- map["Message"]
        page <- map["Page"]
    }
}

class CheckCarModel:Mappable {
    var CarId = ""
    var InsId = ""
    var SchoolName = ""
    var CarNum = ""
    var FraNum = ""
    var EngNum = ""
    var LicNum = ""
    var PlateColor = ""
    var Manufacture = ""
    var Brand = ""
    var PerDriType = ""
    var BuyDate = ""
    var CarImage = ""
    var SyncState = ""
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        CarId <- map["CarId"]
        InsId <- map["InsId"]
        SchoolName <- map["SchoolName"]
        CarNum <- map["CarNum"]
        FraNum <- map["FraNum"]
        EngNum <- map["EngNum"]
        LicNum <- map["LicNum"]
        PlateColor <- map["PlateColor"]
        Manufacture <- map["Manufacture"]
        Brand <- map["Brand"]
        PerDriType <- map["PerDriType"]
        BuyDate <- map["BuyDate"]
        CarImage <- map["CarImage"]
        SyncState <- map["SyncState"]
        
    }
}
