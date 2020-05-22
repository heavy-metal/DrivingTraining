
//
//  ClassInfoModel.swift
//  NewSwift
//
//  Created by gail on 2019/5/28.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class ClassInfoModel: Mappable {
    var page : Page?
    var classArray : [ClassModel]?
    var code = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        page <- map["Page"]
        classArray <- map["Data"]
        code <- map["Code"]
    }
}

class ClassModel : Mappable {
    var Amount = ""
    var FileUrl = ""
    var VehicleType = ""
    var ClassId = ""
    var SchoolName = ""
    var SchoolId = ""
    var ClassName = ""
   
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        Amount <- map["Amount"]
        FileUrl <- map["FileUrl"]
        VehicleType <- map["VehicleType"]
        ClassId <- map["ClassId"]
        SchoolName <- map["SchoolName"]
        SchoolId <- map["SchoolId"]
        ClassName <- map["ClassName"]
        
    }
}
