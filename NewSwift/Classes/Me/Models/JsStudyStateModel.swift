//
//  JsStudyStateModel.swift
//  DistanceEducation
//
//  Created by gail on 2018/10/16.
//  Copyright © 2018 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class JsStudyStateModel: Mappable {
    var code = ""
    var message = ""
    var studyStateModel:StudyStateModel?
    required init?(map: Map){}
    func mapping(map: Map){
        
        code <- map["Code"]
        message <- map["Message"]
        studyStateModel <- map["Data"]
    }
}
class StudyStateModel: Mappable {
    var StuId = ""
    var Name = ""
    var TrainType = ""
    var TStudyState = ""
    var T_Times1 = 0.0
    var C_Times1 = 0.0
    var H_Times1 = 0.0
    var P_Theory1 = 0.0
    var P_Times1 = 0.0
    var T_Times2 = 0.0
    var C_Times2 = 0.0
    var S_Times2 = 0.0
    var Miles2 = 0.0
    var P_Times2 = 0.0
    var T_Times3 = 0.0
    var C_Times3 = 0.0
    var S_Times3 = 0.0
    var Miles3 = 0.0
    var P_Times3 = 0.0
    var T_Times4 = 0.0
    var C_Times4 = 0.0
    var H_Times4 = 0.0
    var P_Theory4 = 0.0
    var P_Times4 = 0.0
    var State1 = ""
    var State2 = ""
    var State3 = ""
    var State4 = ""
    var GovExamDate1 = ""
    var GovExamResult1 = ""
    var GovExamDate2 = ""
    var GovExamResult2 = ""
    var GovExamDate3 = ""
    var GovExamResult3 = ""
    var GovExamDate4 = ""
    var GovExamResult4 = ""
    required init?(map: Map){}
    func mapping(map: Map){
        
        StuId <- map["StuId"]
        Name <- map["Name"]
        TrainType <- map["TrainType"]
        TStudyState <- map["TStudyState"]
        T_Times1 <- map["T_Times1"]
        C_Times1 <- map["C_Times1"]
        H_Times1 <- map["H_Times1"]
        P_Theory1 <- map["P_Theory1"]
        P_Times1 <- map["P_Times1"]
        T_Times2 <- map["T_Times2"]
        C_Times2 <- map["C_Times2"]
        S_Times2 <- map["S_Times2"]
        Miles2 <- map["Miles2"]
        P_Times2 <- map["P_Times2"]
        T_Times3 <- map["T_Times3"]
        C_Times3 <- map["C_Times3"]
        S_Times3 <- map["S_Times3"]
        Miles3 <- map["Miles3"]
        P_Times3 <- map["P_Times3"]
        T_Times4 <- map["T_Times4"]
        C_Times4 <- map["C_Times4"]
        H_Times4 <- map["H_Times4"]
        P_Theory4 <- map["P_Theory4"]
        P_Times4 <- map["P_Times4"]
        State1 <- map["State1"]
        State2 <- map["State2"]
        State3 <- map["State3"]
        State4 <- map["State4"]
        GovExamDate1 <- map["GovExamDate1"]
        GovExamResult1 <- map["GovExamResult1"]
        GovExamDate2 <- map["GovExamDate2"]
        GovExamResult2 <- map["GovExamResult2"]
        GovExamDate3 <- map["GovExamDate3"]
        GovExamResult3 <- map["GovExamResult3"]
        GovExamDate4 <- map["GovExamDate4"]
        GovExamResult4 <- map["GovExamResult4"]
    }
}
