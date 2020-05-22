//
//  ApplyTextFieldCell.swift
//  NewSwift
//
//  Created by gail on 2019/6/6.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class ApplyTextFieldCell: UITableViewCell {

    lazy var icon:UIImageView = {
        var icon = UIImageView()
        return icon
    }()
    lazy var textField:UITextField = {
        var textField = UITextField()
        textField.tintColor = GlobalColor
        textField.returnKeyType = .go
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    lazy var warnLabel:UILabel = {
        var warnLabel = UILabel()
        warnLabel.textColor = UIColor.red
        warnLabel.font = UIFont.systemFont(ofSize: 12)
        return warnLabel
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
        addSubview(textField)
        addSubview(warnLabel)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.frame = CGRect(x: 10, y: (self.height-25)/2, width: 25, height: 25)
        textField.frame = CGRect(x: icon.frame.maxX+20, y: (self.height-30)/2, width: SCREEN_WIDTH*5.5/10, height: 30)
        warnLabel.frame = CGRect(x: textField.frame.maxX, y: (self.height-15)/2, width: SCREEN_WIDTH-textField.frame.maxX, height: 15)
        
    }

}
