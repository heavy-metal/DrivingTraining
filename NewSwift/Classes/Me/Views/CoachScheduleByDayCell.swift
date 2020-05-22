//
//  CoachScheduleByDayCell.swift
//  NewSwift
//
//  Created by gail on 2019/8/21.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class CoachScheduleByDayCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var model:ScheduleByDayModel? {
        didSet{
            
            timeLabel.text = "\(model?.SchTimeBegin ?? "") ~ \(model?.SchTimeEnd ?? "")  ,\(model?.Times ?? 0)分钟"
            typeLabel.text = "\(model?.Subject ?? ""),\(model?.RegionName ?? "")"
            priceLabel.text = "\(model?.Price ?? "")元,\(model?.SchState == 1 ? "已约" : "可约")"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
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
