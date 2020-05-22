
//
//  AllDistrictModel.swift
//  NewSwift
//
//  Created by gail on 2019/5/21.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper

class AllDistrictModel: Mappable {
    
    var code = ""
    var Message = ""
    var districtRows : [DistrictModel]?
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        Message <- map["Message"]
        code <- map["Code"]
        districtRows <- map["Data"]
    }
}
class DistrictModel : Mappable {
    
    var cityIndex = 66666
    var Name = ""
    
    required init?(map: Map){}
    func mapping(map: Map){
        
        cityIndex <- map["District"]
        Name <- map["Name"]
        
    }
}
