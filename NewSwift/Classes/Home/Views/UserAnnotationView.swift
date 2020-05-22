

//
//  UserAnnotationView.swift
//  NewSwift
//
//  Created by gail on 2019/6/18.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit
import MapKit
class UserAnnotationView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.image = UIImage(named:"fujingjiaxiao")
        self.canShowCallout = true
        let icon = UIImageView(image: UIImage(named:"man"))
        icon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.leftCalloutAccessoryView = icon
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
