//
//  HomeInfoModel.swift
//  NewSwift
//
//  Created by gail on 2017/12/15.
//  Copyright © 2017年 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeAllInfoModel: Mappable {
    var code:String?
    var message:String?
    var data:HomeInfoModel?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        code <- map["Code"]
        message <- map["Message"]
        data <- map["Data"]
    }
}

class HomeInfoModel: Mappable {
    
    var imgArray:[HeadInfo]?
    var schoolRowsArray:[Any]?
    var coachRowsArray:[Any]?
    var zczxArray:[Any]?
    var JktjUrl:String?
    var JklcUrl:String?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        imgArray <- map["ImgInfoRows"]
        schoolRowsArray <- map["InsRows"]
        coachRowsArray <- map["CoachRows"]
        zczxArray <- map["ZczxInfoRows"]
        JktjUrl <- map["JktjUrl"]
        JklcUrl <- map["JklcUrl"]
    }
}

class HeadInfo: Mappable {
    
    var InfoId : String?
    var InfoTitle : String?
    var InfoFrom : String?
    var FileUrl : String?
    var InfoType : NSInteger?
    var UpdateTime : String?
    var IsTop : NSInteger?
    var InfoIcon : String?
    var InfoContent : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        InfoId <- map["InfoId"]
        InfoTitle <- map["InfoTitle"]
        InfoFrom <- map["InfoFrom"]
        FileUrl <- map["FileUrl"]
        InfoType <- map["InfoType"]
        UpdateTime <- map["UpdateTime"]
        IsTop <- map["IsTop"]
        InfoIcon <- map["InfoIcon"]
        InfoContent <- map["InfoContent"]
        
    }
}
