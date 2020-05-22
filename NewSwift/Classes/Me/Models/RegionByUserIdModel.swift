//
//  RegionByUserIdModel.swift
//  NewSwift
//
//  Created by gail on 2019/8/27.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class RegionByUserIdModel: Mappable {
    var array : [RegionIdModel]?
    var code = ""
    var message = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        array <- map["Data"]
        code <- map["Code"]
        message <- map["Message"]
    }
}

class RegionIdModel: Mappable {
    var RegionId = ""
    var Name = ""
    var InsId = ""

    required init?(map: Map){}
    
    func mapping(map: Map){
        
        RegionId <- map["RegionId"]
        Name <- map["Name"]
        InsId <- map["InsId"]
        
    }
}
