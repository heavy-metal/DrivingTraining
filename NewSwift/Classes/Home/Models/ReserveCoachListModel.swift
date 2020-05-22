//
//  ReserveCoachListModel.swift
//  NewSwift
//
//  Created by gail on 2019/7/5.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class ReserveCoachListModel: Mappable {
    var page : Page?
    var array : [ReserveModel]?
    var code = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        page <- map["Page"]
        array <- map["Data"]
        code <- map["Code"]
    }
}
class ReserveModel: Mappable {
    var CoachId = ""
    var InsId = ""
    var CoachNum = ""
    var Name = ""
    var IdCard = ""
    var Mobile = ""
    var TeachPermitted = ""
    var CoachImage = ""
    var StarLevel = ""
    var SchoolName = ""
    
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        
        CoachId <- map["CoachId"]
        InsId <- map["InsId"]
        CoachNum <- map["CoachNum"]
        Name <- map["Name"]
        IdCard <- map["IdCard"]
        Mobile <- map["Mobile"]
        TeachPermitted <- map["TeachPermitted"]
        CoachImage <- map["CoachImage"]
        StarLevel <- map["StarLevel"]
        SchoolName <- map["SchoolName"]
    }
}
