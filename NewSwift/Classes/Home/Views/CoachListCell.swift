//
//  CoachListCell.swift
//  NewSwift
//
//  Created by gail on 2018/1/15.
//  Copyright © 2018年 NewSwift. All rights reserved.
//

import UIKit

class CoachListCell: UITableViewCell {

    @IBOutlet weak var fromShoolLabel: UILabel!
    @IBOutlet weak var starBackView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var applyBtn: ApplyBtn!
    

    
    lazy var starView:StartView = {
        var starView = StartView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        return starView
    }()
    
    var model:CoachModel? {
        didSet{
            icon.sd_setImage(with: URL(string: (model?.CoachImage)!))
            coachNameLabel.text = model?.Name
            fromShoolLabel.text = (model?.SchoolName)!
            starView.rating = (model?.StarLevel)!
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        starBackView.addSubview(starView)
        
        icon.layer.cornerRadius = icon.width/2
        icon.clipsToBounds = true
        icon.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        icon.layer.borderWidth = 0.5
        icon.contentMode = .scaleAspectFill
    }

    override var frame:CGRect{
        didSet {
            if self.viewController()?.navigationController?.viewControllers.last is ReserveCarVC {return}
            var newFrame = frame
            newFrame.origin.x += LINE_SPACE
            newFrame.size.width -= LINE_SPACE*2
//            newFrame.origin.y += LINE_SPACE
            newFrame.size.height -= LINE_SPACE
            super.frame = newFrame
        }
    }
    
    @IBAction func applyBtnClick(_ sender: ApplyBtn) {
        
        let vc = ApplyViewController()
        vc.insID = model?.InsId ?? ""
        vc.coachName = model?.Name ?? ""
        vc.schoolName = model?.SchoolName ?? ""
        vc.coachId = model?.CoachId ?? ""
        self.viewController().navigationController?.pushViewController(vc, animated: true)
    }
}
