//
//  CoachListModel.swift
//  NewSwift
//
//  Created by gail on 2018/1/12.
//  Copyright © 2018年 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class CoachListModel: Mappable {
    
    var page : Page?
    var coachlistArray : [CoachModel]?
    var code = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        page <- map["Page"]
        coachlistArray <- map["Data"]
        code <- map["Code"]
    }
    
}

class CoachModel : Mappable {
    
    var InsId = ""
    var Mobile = ""
    var CoachState = ""
    var LastTime = ""
    var CoachNum = ""
    var CoachCardNo = ""
    var UserState = ""
    var CoachId = ""
    var Birthday = ""
    var TeachType = ""
    var CoachImage = ""
    var District = ""
    var StopReason = ""
    var StopDate = ""
    var IdCard = ""
    var SchoolName = ""
    var Sex = ""
    var Name = ""
    var TeachPermitted = ""
    var StarLevel:CGFloat?
    var LicNum = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        InsId <- map["InsId"]
        Mobile <- map["Mobile"]
        CoachState <- map["CoachState"]
        LastTime <- map["LastTime"]
        CoachNum <- map["CoachNum"]
        CoachCardNo <- map["CoachCardNo"]
        UserState <- map["UserState"]
        CoachId <- map["CoachId"]
        Birthday <- map["Birthday"]
        TeachType <- map["TeachType"]
        CoachImage <- map["CoachImage"]
        District <- map["District"]
        StopReason <- map["StopReason"]
        StopDate <- map["StopDate"]
        IdCard <- map["IdCard"]
        SchoolName <- map["SchoolName"]
        Sex <- map["Sex"]
        Name <- map["Name"]
        TeachPermitted <- map["TeachPermitted"]
        StarLevel <- map["StarLevel"]
        LicNum <- map["LicNum"]
        
    }
    
    
}
