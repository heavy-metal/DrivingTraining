//
//  StudentFindTimeCell.swift
//  NewSwift
//
//  Created by gail on 2019/7/2.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class StudentFindTimeCell: UITableViewCell {
    
    var model:StudyTimeModel? {
        didSet{
            typeLabel.text = model?.StudyType
            timeLabel.text = "\(model?.StudyDate ?? "")  \(model?.StartTime ?? "")-\(model?.EndTime ?? "")"
            state1Btn.setTitle(model?.UpState, for: .normal)
            state2Btn.setTitle(model?.ExeState, for: .normal)
            hoursLabel.text = "\(model?.Duration ?? "") (小时)"
        }
    }

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var state1Btn: StydyTimeBtn!
    @IBOutlet weak var state2Btn: StydyTimeBtn!
    @IBOutlet weak var photeBtn: ApplyBtn!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photeBtn.setTitle("照片", for: .normal)
        photeBtn.isEnabled = false
        selectionStyle = .none
    }

    @IBAction func FindPhotoClick(_ sender: ApplyBtn) {
        
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
