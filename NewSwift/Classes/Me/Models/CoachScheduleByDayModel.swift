//
//  CoachScheduleByDayModel.swift
//  NewSwift
//
//  Created by gail on 2019/8/20.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class CoachScheduleByDayModel: Mappable {
    var page : Page?
    var array : [ScheduleByDayModel]?
    var code = ""
    var message = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        page <- map["Page"]
        array <- map["Data"]
        code <- map["Code"]
        message <- map["Message"]
    }
}
class ScheduleByDayModel: Mappable {
    var StuId = ""
    var InsId = ""
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
    var Price = ""
    var SchState = 0
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        StuId <- map["Id"]
        InsId <- map["InsId"]
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
