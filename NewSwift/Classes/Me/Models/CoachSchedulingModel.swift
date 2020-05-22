//
//  CoachSchedulingModel.swift
//  NewSwift
//
//  Created by gail on 2019/8/16.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class CoachSchedulingModel: Mappable {
    
    var array : [SchedulingModel]?
    var code = ""
    var message = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        array <- map["Data"]
        code <- map["Code"]
        message <- map["Message"]
    }
}
class SchedulingModel: Mappable {
    var CoachId = ""
    var SchDate = ""
    var KyMinute = 0
    var YwMinute = 0
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        CoachId <- map["CoachId"]
        SchDate <- map["SchDate"]
        KyMinute <- map["KyMinute"]
        YwMinute <- map["YwMinute"]
    }
}
