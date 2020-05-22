//
//  BookCarOrderModel.swift
//  NewSwift
//
//  Created by gail on 2019/7/18.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class BookCarOrderModel: Mappable {
    var code = ""
    var message = ""
    var array:[CarChooseOrderModel]?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        code <- map["Code"]
        message <- map["Message"]
        array <- map["Data"]
    }
}
class CarChooseOrderModel: Mappable {
    var carID = ""
    var InsId = ""
    var CoachId = ""
    var CoachName = ""
    var SchDate = ""
    var SchTimeBegin = ""
    var SchTimeEnd = ""
    var Times = 0
    var IsHoliday = 0
    var TimeType = 0
    var Subject = ""
    var RegionId = ""
    var RegionName = ""
    var price = 0
    var Price = "" {
        didSet{
            price = (Price as NSString).integerValue
        }
    }
    var SchState = 0
    
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        carID <- map["Id"]
        InsId <- map["InsId"]
        CoachId <- map["CoachId"]
        CoachName <- map["CoachName"]
        SchDate <- map["SchDate"]
        SchTimeBegin <- map["SchTimeBegin"]
        SchTimeEnd <- map["SchTimeEnd"]
        Times <- map["Times"]
        IsHoliday <- map["IsHoliday"]
        TimeType <- map["TimeType"]
        Subject <- map["Subject"]
        RegionId <- map["RegionId"]
        RegionName <- map["RegionName"]
        Price <- map["Price"]
        SchState <- map["SchState"]
        
     
    }
    
}
