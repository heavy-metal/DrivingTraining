//
//  PublicListModel.swift
//  NewSwift
//
//  Created by gail on 2019/6/12.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper

class PublicListModel: Mappable {
    var page : Page?
    var publicArray : [PublicModel]?
    var code = ""
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        page <- map["Page"]
        publicArray <- map["Data"]
        code <- map["Code"]
    }
}

class PublicModel: Mappable {
    var InfoId = ""
    var InfoTitle = ""
    var InfoFrom = ""
    var FileUrl = ""
    var InfoType = 0
    var PublishTime = ""
    var IsTop = 0
    var InfoIcon = ""
    var InfoContent = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        InfoId <- map["InfoId"]
        InfoTitle <- map["InfoTitle"]
        InfoFrom <- map["InfoFrom"]
        FileUrl <- map["FileUrl"]
        InfoType <- map["InfoType"]
        PublishTime <- map["PublishTime"]
        IsTop <- map["IsTop"]
        InfoIcon <- map["InfoIcon"]
        InfoContent <- map["InfoContent"]
    }
}
