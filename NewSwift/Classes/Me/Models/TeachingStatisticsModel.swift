//
//  TeachingStatisticsModel.swift
//  NewSwift
//
//  Created by gail on 2019/8/13.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class TeachingStatisticsModel: Mappable {

    var array : [StudyTimeModel]?
    var code = ""
    var message = ""
    var CoachId = ""
    var StudyDate = ""
    var TotalTimes = ""
    var TotalMiles = ""
    var TotalStuCount = ""
    var TotalRecord = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        CoachId <- map["CoachId"]
        array <- map["Data"]
        code <- map["Code"]
        message <- map["Message"]
        StudyDate <- map["StudyDate"]
        TotalTimes <- map["TotalTimes"]
        TotalMiles <- map["TotalMiles"]
        TotalStuCount <- map["TotalStuCount"]
        TotalRecord <- map["TotalRecord"]
    }
}
