//
//  InquireAboutCarCell.swift
//  NewSwift
//
//  Created by gail on 2019/7/8.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class InquireAboutCarCell: UITableViewCell {

    
    @IBOutlet weak var evaluateBtn: ApplyBtn!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var orderDetailLabel: UILabel!
    
    
    var model:SearchCarOrderModel? {
        didSet{
            coachNameLabel.text = model?.CoachName
            typeLabel.text = model?.Subject == "" ? "暂无" : model?.Subject
            orderDetailLabel.text = "\(model?.AmountYF ?? "")$, \(model?.orderState ?? ""), \(model?.payState ?? "")"
            evaluateBtn.setTitle(model?.stuPjState, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        evaluateBtn.isEnabled = false
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
