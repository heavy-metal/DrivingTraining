//
//  RatingModel.swift
//  NewSwift
//
//  Created by gail on 2019/7/9.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class RatingModel: Mappable {
    var code = ""
    var message = ""
    var ratingStarModel:RatingStarModel?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        code <- map["Code"]
        message <- map["Message"]
        ratingStarModel <- map["Data"]
    }
}
class RatingStarModel: Mappable {
    var ratingID = ""
    var OrderNo = ""
    var Quality = 0
    var Attitude = 0
    var Standard = 0
    var Honest = 0
    var Content = ""
    
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        ratingID <- map["ID"]
        OrderNo <- map["OrderNo"]
        Quality <- map["Quality"]
        Attitude <- map["Attitude"]
        Standard <- map["Standard"]
        Honest <- map["Honest"]
        Content <- map["Content"]
        
    }
    
}

