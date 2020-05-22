//
//  SeduTimesCell.swift
//  NewSwift
//
//  Created by gail on 2019/8/28.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class SeduTimesCell: UITableViewCell {
    
    lazy var intervalLabel:UILabel = {
        var intervalLabel = UILabel()
        intervalLabel.font = UIFont.systemFont(ofSize: 14)
        intervalLabel.textAlignment = .center
        return intervalLabel
    }()
    
    lazy var timeLabel:UILabel = {
        var timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textAlignment = .center
        return timeLabel
    }()
    
    lazy var priceLabel:UILabel = {
        var priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textAlignment = .center
        return priceLabel
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(intervalLabel)
        addSubview(timeLabel)
        addSubview(priceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        intervalLabel.frame = CGRect(x: 0, y: (height-20)/2, width: SCREEN_WIDTH/3, height: 20)
        timeLabel.frame = CGRect(x: SCREEN_WIDTH/3, y: (height-20)/2, width: SCREEN_WIDTH/3, height: 20)
        priceLabel.frame = CGRect(x: SCREEN_WIDTH/3*2, y: (height-20)/2, width: SCREEN_WIDTH/3, height: 20)
    }

}
