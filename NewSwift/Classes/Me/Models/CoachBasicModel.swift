//
//  CoachBasicModel.swift
//  NewSwift
//
//  Created by gail on 2019/7/1.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class CoachBasicModel: Mappable {
    var code = ""
    var message = ""
    var coachModel:CoachMessageModel?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        code <- map["Code"]
        message <- map["Message"]
        coachModel <- map["Data"]
    }
}
class CoachMessageModel: Mappable{
    var Mobile = ""
    var Name = ""
    var InsId = ""
    var UserState = ""
    var CoachId = ""
    var IdCard = ""
    var StarLevel = ""
    var CoachImage = ""
    var District = ""
    var TeachPermitted = ""
    var CoachNum = ""
    var LicNum = ""
    var StopDate = ""
    var StopReason = ""
    var SchoolName = ""
    var Sex = ""
    var LastTime = ""
    
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        Mobile <- map["Mobile"]
        Name <- map["Name"]
        InsId <- map["InsId"]
        UserState <- map["UserState"]
        CoachId <- map["CoachId"]
        IdCard <- map["IdCard"]
        StarLevel <- map["StarLevel"]
        CoachImage <- map["CoachImage"]
        District <- map["District"]
        TeachPermitted <- map["TeachPermitted"]
        CoachNum <- map["CoachNum"]
        LicNum <- map["LicNum"]
        StopDate <- map["StopDate"]
        StopReason <- map["StopReason"]
        SchoolName <- map["SchoolName"]
        Sex <- map["Sex"]
        LastTime <- map["LastTime"]
        
    }
}
