
//
//  StuBasicModel.swift
//  NewSwift
//
//  Created by gail on 2019/7/1.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class StuBasicModel: Mappable {
    var code = ""
    var message = ""
    var stuModel:StuMessageModel?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        code <- map["Code"]
        message <- map["Message"]
        stuModel <- map["Data"]
    }
}
class StuMessageModel: Mappable {
    var StuId = ""
    var InsId = ""
    var SchoolName = ""
    var StuNum = ""
    var Name = ""
    var Sex = ""
    var StuImage = ""
    var IdCard = ""
    var Mobile = ""
    var ApplyDate = ""
    var TrainType = ""
    var StudyState = ""
    var LastTime = ""
    var UserState = ""
    var StopDate = ""
    var StopReason = ""
    var State1 = ""
    var State2 = ""
    var State3 = ""
    var State4 = ""
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        StuId <- map["StuId"]
        InsId <- map["InsId"]
        SchoolName <- map["SchoolName"]
        StuNum <- map["StuNum"]
        Name <- map["Name"]
        Sex <- map["Sex"]
        StuImage <- map["StuImage"]
        IdCard <- map["IdCard"]
        Mobile <- map["Mobile"]
        ApplyDate <- map["ApplyDate"]
        TrainType <- map["TrainType"]
        StudyState <- map["StudyState"]
        LastTime <- map["LastTime"]
        UserState <- map["UserState"]
        StopDate <- map["StopDate"]
        StopReason <- map["StopReason"]
        State1 <- map["State1"]
        State2 <- map["State2"]
        State3 <- map["State3"]
        State4 <- map["State4"]
    }
}
