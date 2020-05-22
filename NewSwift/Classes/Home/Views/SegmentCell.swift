

//
//  SegmentCell.swift
//  NewSwift
//
//  Created by gail on 2019/6/6.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class SegmentCell: UITableViewCell {

    lazy var segment:UISegmentedControl = {
        var segment = UISegmentedControl(items: ["男","女"])
        segment.selectedSegmentIndex = 0
        segment.tintColor = GlobalColor
        return segment
    }()
    
    lazy var icon:UIImageView = {
       var icon = UIImageView(image: UIImage(named: "xingbie"))
        return icon
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        selectionStyle = .none
        addSubview(icon)
        addSubview(segment)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.frame = CGRect(x: 10, y: (self.height-25)/2, width: 25, height: 25)
        segment.frame = CGRect(x: icon.frame.maxX+20, y: (self.height-25)/2, width: 120, height: 25)
    }
    
}
