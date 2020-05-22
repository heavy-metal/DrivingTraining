//
//  RegistListModel.swift
//  NewSwift
//
//  Created by gail on 2019/5/16.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import ObjectMapper
class RegistListModel: Mappable {
    var page : Page?
    var registlistArray : [RegistModel]?
    var code = ""
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        page <- map["Page"]
        registlistArray <- map["Data"]
        code <- map["Code"]
    }
    
}

class RegistModel: Mappable{
    var RegSiteId = ""
    var InsId = ""
    var SchoolName = ""
    var RegSiteName = ""
    var District = ""
    var LinkMan = ""
    var RegSiteImage = ""
    var Address = ""
    var LngLat = ""
    var Tel = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        RegSiteId <- map["RegSiteId"]
        InsId <- map["InsId"]
        SchoolName <- map["SchoolName"]
        RegSiteName <- map["RegSiteName"]
        District <- map["District"]
        LinkMan <- map["LinkMan"]
        RegSiteImage <- map["RegSiteImage"]
        Address <- map["Address"]
        LngLat <- map["LngLat"]
        Tel <- map["Tel"]
        
    }
}
