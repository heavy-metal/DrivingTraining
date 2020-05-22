
import ObjectMapper//
//  SchoolBaseModel.swift
//  NewSwift
//
//  Created by gail on 2019/7/1.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class SchoolBaseModel: Mappable {
    var code = ""
    var message = ""
    var schoolModel:SchoolModel?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        code <- map["Code"]
        message <- map["Message"]
        schoolModel <- map["Data"]
    }
}


