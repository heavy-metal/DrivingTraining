//
//  StudyStateCell.swift
//  DistanceEducation
//
//  Created by gail on 2018/10/18.
//  Copyright © 2018 NewSwift. All rights reserved.
//

import UIKit

class StudyStateCell: UITableViewCell {
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var part2BackView: UIView!
    @IBOutlet weak var part3BackView: UIView!
    @IBOutlet weak var part1BackView: UIView!
    @IBOutlet weak var partStateLabel: UILabel!
    @IBOutlet weak var part1NetHourLabel: UILabel!
    @IBOutlet weak var part2FaceHourLabel: UILabel!
    @IBOutlet weak var throughHourLabel: UILabel!
//    @IBOutlet weak var simulationLabel: UILabel!
    
    lazy var part1ProgressView = XLWaveProgress(frame: CGRect(x: 0, y: 0, width: 85, height: 85))
    lazy var part2ProgressView = XLWaveProgress(frame: CGRect(x: 0, y: 0, width: 85, height: 85))
    lazy var part3ProgressView = XLWaveProgress(frame: CGRect(x: 0, y: 0, width: 85, height: 85))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        part1BackView.addSubview(part1ProgressView)
        part2BackView.addSubview(part2ProgressView)
        part3BackView.addSubview(part3ProgressView)

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
