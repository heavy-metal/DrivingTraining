//
//  ReplySuggestCell.swift
//  NewSwift
//
//  Created by gail on 2019/8/1.
//  Copyright © 2019 NewSwift. All rights reserved.
//

import UIKit

class ReplySuggestCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
