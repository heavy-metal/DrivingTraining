//
//  LoginInfoModel.swift
//  NewSwift
//
//  Created by gail on 2019/6/24.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class LoginInfoModel: Mappable {
    var code = ""
    var message = ""
    var loginModel:LoginModel?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        code <- map["Code"]
        message <- map["Message"]
        loginModel <- map["Data"]
    }
}

enum LoginType {
    case student
    case coach
    case school
}

class LoginModel: Mappable {
    var userId = ""
    var Sex = ""
    var TrueName = ""
    var InsId = ""
    var LastTime = ""
    var UserType = ""
    var Mobile = ""
    var WxUserId = ""
    var UserImg = ""
    var GroupId = ""
    var IdCard = ""
    var loginType:LoginType?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        userId <- map["UserId"]
        Sex <- map["Sex"]
        TrueName <- map["TrueName"]
        InsId <- map["InsId"]
        LastTime <- map["LastTime"]
        UserType <- map["UserType"]
        Mobile <- map["Mobile"]
        WxUserId <- map["WxUserId"]
        UserImg <- map["UserImg"]
        GroupId <- map["GroupId"]
        IdCard <- map["IdCard"]
        
    }
  
}

