//
//  ClassInfoCell.swift
//  NewSwift
//
//  Created by gail on 2019/5/30.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class ClassInfoCell: UITableViewCell {
    
    @IBOutlet weak var applyBtn: ApplyBtn!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classMoneyLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    
    var insId = ""
    
    var model:ClassModel? {
        didSet {
            classNameLabel.text = model?.ClassName
            carTypeLabel.text = "车型: \(model?.VehicleType ?? "")"
            classMoneyLabel.text = "$ \(model?.Amount ?? "")元"
        }
    }
    
    var coachName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
    }

 
    @IBAction func applyBtnClick(_ sender: UIButton) {
        let vc = ApplyViewController()
        vc.className = model?.ClassName ?? ""
        vc.schoolName = model?.SchoolName ?? ""
        vc.insID = insId
        vc.classID = model?.ClassId ?? ""
        self.viewController()?.navigationController?.pushViewController(vc, animated: true)
        
    }
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.origin.x += LINE_SPACE
            newFrame.size.width -= LINE_SPACE*2
            newFrame.origin.y += LINE_SPACE
            newFrame.size.height -= LINE_SPACE
            super.frame = newFrame
        }
    }
    
}
