//
//  SeduTimesModel.swift
//  NewSwift
//
//  Created by gail on 2019/8/28.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class SeduTimesModel: Mappable {
    var array : [SeduTimeModel]?
    var code = ""
    var message = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        array <- map["Data"]
        code <- map["Code"]
        message <- map["Message"]
    }
}

class SeduTimeModel: Mappable {
    var ConfigId = ""
    var BeginTime = ""
    var EndTime = ""
    var Times = 0
    var Price = 0
    var TimeType = 0
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        ConfigId <- map["ConfigId"]
        BeginTime <- map["BeginTime"]
        EndTime <- map["EndTime"]
        Times <- map["Times"]
        Price <- map["Price"]
        TimeType <- map["TimeType"]
    }
}
