//
//  FindStudyTimeModel.swift
//  NewSwift
//
//  Created by gail on 2019/7/2.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class FindStudyTimeModel: Mappable {
    var page : Page?
    var array : [StudyTimeModel]?
    var code = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        page <- map["Page"]
        array <- map["Data"]
        code <- map["Code"]
    }
}

class StudyTimeModel: Mappable {
    
    var StuId = ""
    var StuNum = ""
    var StuName = ""
    var InsId = ""
    var TerminalNo = ""
    var Subject = ""
    var StudyType = ""
    var CoachId = ""
    var CoachName = ""
    var StudyDate = ""
    var StartTime = ""
    var EndTime = ""
    var Duration = ""
    var Mileage = ""
    var PhotoFile1 = ""
    var PhotoFile2 = ""
    var PhotoFile3 = ""
    var UpState = ""
    var ExeState = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        StuId <- map["StuId"]
        StuNum <- map["StuNum"]
        StuName <- map["StuName"]
        InsId <- map["InsId"]
        TerminalNo <- map["TerminalNo"]
        Subject <- map["Subject"]
        StudyType <- map["StudyType"]
        CoachId <- map["CoachId"]
        CoachName <- map["CoachName"]
        StudyDate <- map["StudyDate"]
        StartTime <- map["StartTime"]
        EndTime <- map["EndTime"]
        Duration <- map["Duration"]
        Mileage <- map["Mileage"]
        PhotoFile1 <- map["PhotoFile1"]
        PhotoFile2 <- map["PhotoFile2"]
        PhotoFile3 <- map["PhotoFile3"]
        UpState <- map["UpState"]
        ExeState <- map["ExeState"]
        
    }
}
