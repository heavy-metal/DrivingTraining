//
//  ReserveCarTimeModel.swift
//  NewSwift
//
//  Created by gail on 2019/7/8.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class ReserveCarTimeModel: Mappable {
    
    var array : [Timemodel]?
    var code = ""
    var message = ""
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        array <- map["Data"]
        code <- map["Code"]
        message <- map["Message"]
    }
}
class Timemodel: Mappable {
    var CoachId = ""
    var SchDate = ""
    var KyMinute = ""
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        CoachId <- map["CoachId"]
        SchDate <- map["SchDate"]
        KyMinute <- map["KyMinute"]
    }
}
