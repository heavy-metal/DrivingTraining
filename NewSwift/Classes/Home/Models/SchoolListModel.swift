//
//  SchoolListModel.swift
//  NewSwift
//
//  Created by gail on 2018/1/8.
//  Copyright © 2018年 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class SchoolListModel: Mappable {
    
    var Page : Page?
    var Data : [SchoolModel]?
    var code = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        Page <- map["Page"]
        Data <- map["Data"]
        code <- map["Code"]
    }
   
}
class Page : Mappable {
    
    var currentPage : NSInteger?
    var totalPage : NSInteger?
    var totalRecord : NSInteger?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        currentPage <- map["CurrentPage"]
        totalPage <- map["TotalPage"]
        totalRecord <- map["TotalRecord"]
    }
}

class SchoolModel: Mappable {
    
    var InsId = ""
    var LngLat = ""
    var RegMan = ""
    var Fax = ""
    var RegTel = ""
    var InsCode = ""
    var Name = ""
    var Address = ""
    var District = ""
    var Level = ""
    var TracarNum = 0
    var SchImage = ""
    var ShortName = ""
    var FileUrl = ""
    var BusiScope = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        InsId <- map["InsId"]
        LngLat <- map["LngLat"]
        RegMan <- map["RegMan"]
        Fax <- map["Fax"]
        RegTel <- map["RegTel"]
        Name <- map["Name"]
        Address <- map["Address"]
        District <- map["District"]
        Level <- map["Level"]
        TracarNum <- map["TracarNum"]
        SchImage <- map["SchImage"]
        ShortName <- map["ShortName"]
        FileUrl <- map["FileUrl"]
        BusiScope <- map["BusiScope"]
        
    }
}
