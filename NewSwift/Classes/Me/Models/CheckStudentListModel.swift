//
//  CheckStudentListModel.swift
//  NewSwift
//
//  Created by gail on 2019/8/7.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class CheckStudentListModel: Mappable {
    var page : Page?
    var array : [CheckStudentModel]?
    var code = ""
    var message = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        page <- map["Page"]
        array <- map["Data"]
        code <- map["Code"]
        message <- map["Message"]
    }
}

class CheckStudentModel: Mappable {
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
