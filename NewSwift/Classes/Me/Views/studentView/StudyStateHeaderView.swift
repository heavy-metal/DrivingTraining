//
//  StudyStateHeaderView.swift
//  DistanceEducation
//
//  Created by gail on 2018/10/18.
//  Copyright © 2018 NewSwift. All rights reserved.
//

import UIKit

class StudyStateHeaderView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
 
    var model:StudyStateModel? {
        didSet {
            nameLabel.text = model?.Name
            stateLabel.text = model?.TStudyState
            carTypeLabel.text = model?.TrainType
        }
    }
}
