//
//  SeduConfigsModel.swift
//  NewSwift
//
//  Created by gail on 2019/8/27.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class SeduConfigsModel: Mappable {
    
    var array : [SeduConfigModel]?
    var code = ""
    var message = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        array <- map["Data"]
        code <- map["Code"]
        message <- map["Message"]
    }
}

class SeduConfigModel: Mappable {
    var ConfigId = ""
    var InsId = ""
    var ConfigName = ""
    var IsHoliday = 0
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        ConfigId <- map["ConfigId"]
        InsId <- map["InsId"]
        ConfigName <- map["ConfigName"]
        IsHoliday <- map["IsHoliday"]
    }
}
