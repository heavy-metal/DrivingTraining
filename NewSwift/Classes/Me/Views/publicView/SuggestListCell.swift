//
//  SuggestListCell.swift
//  NewSwift
//
//  Created by gail on 2019/7/31.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class SuggestListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stateBtn: ApplyBtn!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        stateBtn.isEnabled = false
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
