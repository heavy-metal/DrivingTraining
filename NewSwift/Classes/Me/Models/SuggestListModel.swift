//
//  SuggestListModel.swift
//  NewSwift
//
//  Created by gail on 2019/8/1.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper

class SuggestListModel: Mappable {
    
    var page : Page?
    var array : [SuggestModel]?
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

class SuggestModel: Mappable{
    lazy var stateArr = ["待处理","已处理","继续跟踪"]
    var FeedbackId = ""
    var InsId = ""
    var SchoolName = ""
    var UserType = 0
    var UserId = ""
    var UserName = ""
    var Mobile = ""
    var FeedbackTime = ""
    var FeedbackType = 0
    var Title = ""
    var Content = ""
    var UserRead = 0
    var opState = ""
    var OpState = 0 {
        didSet{
          opState = stateArr[OpState]
        }
    }
    var OpContent = ""
    var OpTime = ""
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        FeedbackId <- map["FeedbackId"]
        InsId <- map["InsId"]
        SchoolName <- map["SchoolName"]
        UserType <- map["UserType"]
        UserId <- map["UserId"]
        UserName <- map["UserName"]
        Mobile <- map["Mobile"]
        FeedbackTime <- map["FeedbackTime"]
        FeedbackType <- map["FeedbackType"]
        Title <- map["Title"]
        Content <- map["Content"]
        UserRead <- map["UserRead"]
        OpState <- map["OpState"]
        OpContent <- map["OpContent"]
        OpTime <- map["OpTime"]
        
    }
}

