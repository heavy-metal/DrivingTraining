//
//  MyAnnotation.swift
//  NewSwift
//
//  Created by gail on 2019/6/13.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import MapKit
class MyAnnotation: NSObject ,MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
    var title : String?
    var subtitle : String?
    var icon : String?
    var schoolModel:SchoolModel?
}
